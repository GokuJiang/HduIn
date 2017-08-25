//
//  MineCourseSchedule.swift
//  HduIn
//
//  Created by Lucas on 9/24/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import RealmSwift
import Timepiece
import ObjectMapper
import RxSwift

class MineCourseSchedule {

    fileprivate let publicProvider = APIProvider<PublicTarget>()
    fileprivate let teachingProvider = APIProvider<TeachingTarget>()

    var useCache = true

    enum CourseDistribute: String {
        case SingleWeek = "单"
        case DualWeek = "双"
        case EveryWeek = "每"
    }
}

// MARK: - ProcessedCourses
extension MineCourseSchedule {

    /**
     Observable for courses of a week

     - parameter singleWeek: is single week? automatically refer from timeline if is nil

     - returns: observable for Results of courses
     */
    func weekCoursesObservable(_ singleWeek: Bool? = nil) -> Observable<Results<Course>> {
        return courseSchedulesObservable().flatMap { (results) -> Observable<Results<Course>> in
            let sortDescriptors = [
                SortDescriptor(keyPath: "weekDay"),
                SortDescriptor(keyPath: "startSection")
            ]

            if let singleWeek = singleWeek {
                do {
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    return Observable.just(realm.objects(Course.self)
                        .filter("NOT distribute BEGINSWITH %@", singleWeek ?
                            CourseDistribute.DualWeek.rawValue :
                            CourseDistribute.SingleWeek.rawValue
                        ).sorted(by: sortDescriptors)
                    )
                } catch {
                    return Observable.error(error)
                }
            } else {
                return self.timelineObservable().map { (timeline) -> Results<Course> in
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    return realm.objects(Course.self)
                        .filter("NOT distribute BEGINSWITH %@", timeline.isSingleWeek() ?
                            CourseDistribute.DualWeek.rawValue :
                            CourseDistribute.SingleWeek.rawValue
                        ).sorted(by: sortDescriptors)
                }
            }
        }
    }

    /**
     Observable for courses of a week day

     - parameter weekDay: 1 through 7, e.g. Sunday is represented by 7.

     - returns: observable for Results of courses
     */
    func weekDayCoursesObservable(_ weekDay: Int) -> Observable<Results<Course>> {
        return weekCoursesObservable().map { (results) -> Results<Course> in
            return results.filter("weekDay = %@", weekDay).sorted(byKeyPath: "startSection")
        }
    }

    /**
     A convenience method for weekDayCoursesObservable(_:),
     automatically refer weekDay from calendar

     - returns: observable for Results of courses
     */
    func todayCoursesObservable() -> Observable<Results<Course>> {
        return weekDayCoursesObservable(getTodayWeekDay())
    }
}

// MARK: - CourseNetworking
extension MineCourseSchedule {

    /**
     Request courses with school year and semester referred from timeline
     will clean Courses database collection and refill it with freshes

     - returns: Observable for results of Course
     */
    func courseSchedulesObservable() -> Observable<Results<Course>> {
        return timelineObservable().flatMap { timeline -> Observable<Timeline> in
            return self.schoolTimeTableObservable().map { _ in
                return timeline
            }
        }.flatMap { timeline -> Observable<Results<Course>> in
            let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
            let courseCount = realm.objects(Course.self).count
            let plist = Plist.sharedInstance

            if self.useCache &&
                courseCount > 0 &&
                plist["fetchedCoursesSchoolYear"] as? String == timeline.schoolYear &&
                plist["fetchedCoursesSemester"] as? Int == timeline.semester {
                    return Observable.just(realm.objects(Course.self))
            }

            return self.teachingProvider
                .request(.courseSchedule(timeline.schoolYear, timeline.semester))
                .mapArray(Course.self)
                .observeOn(SerialDispatchQueueScheduler(qos: .background))
                .map { (records) -> [Course] in
                    plist["fetchedCoursesSchoolYear"] = timeline.schoolYear
                    plist["fetchedCoursesSemester"] = timeline.semester

                    return try self.sortAndMergeCourses(records)
                }
                .observeOn(MainScheduler.instance)
                .map { _ -> Results<Course> in
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    return realm.objects(Course.self)
                }
        }
    }

    /**
     Network raw value of courses at afternoon are seperated into two records,
     which is merged before saved in realm

     - parameter courses: Network raw value array of Course

     - throws: Realm Error

     - returns: Organized array of Course
     */
    fileprivate func sortAndMergeCourses(_ courses: [Course]) throws -> [Course] {
        let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
        // Clear Stored Course
        try realm.write { realm.delete(realm.objects(Course.self)) }

        var sortedCourses = [Course]()
        // Store New Course
        for weekDay in 1 ... 7 {
            var courses = courses
                .filter { $0.weekDay == weekDay }
                .sorted { $0.startSection < $1.startSection }
            var merged = false
            var keysToRemove = [Int]()
            for (key, item) in courses.enumerated() {
                if key != 0 && !merged && item.name == courses[key - 1].name {
                    merged = true
                    keysToRemove.append(key)
                    courses[key - 1].endSection = item.endSection
                } else {
                    merged = false
                }
            }
            // Remove duplicate course
            for key in keysToRemove.reversed() {
                courses.remove(at: key)
            }
            // Write to database
            try realm.write { realm.add(courses) }
            sortedCourses.append(contentsOf: courses)
        }

        return sortedCourses
    }
}

// MARK: - SchoolTimeTable
extension MineCourseSchedule {

    /**
     Request school time table
     Will automatically remove all stored time table and refill with refreshes

     - returns: Observable for array of CourseTime
     */
    func schoolTimeTableObservable() -> Observable<Results<CourseTime>> {
        do {
            let  config = RealmAgent.getDefaultConfigration()
            let realm = try Realm(configuration: config)
            
            let results = realm.objects(CourseTime.self)
            if useCache && results.count > 0 {
                return Observable.just(results)
            }
        } catch {
            print.error(error)
            return Observable.error(error)
        }

        return publicProvider.request(.schoolTimeTable)
            .mapArray(CourseTime.self)
            .map { (records) -> Results<CourseTime> in
                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                // Clear Stored Data
                let old = realm.objects(CourseTime.self)
                try realm.write {
                    realm.delete(old)
                    realm.add(records)
                }
                return realm.objects(CourseTime.self)
            }
    }
}

// MARK: - Timeline
extension MineCourseSchedule {

    /**
     Observable for timeline, will automatically restore from cache

     - returns: Observable for timeline object
     */
    func timelineObservable() -> Observable<Timeline> {
        return publicProvider.request(.timeline)
            .mapObject(Timeline.self)
    }

    /**
     Weekday units are the numbers 1 through n, where n is the number of days in the week.
     For example, in the Gregorian calendar, n is 7 and Sunday is represented by 7.
     */

    struct Timeline: Mappable {
        var updateDate: Date = Date()
        var week: Int = 0
        var schoolYear: String = ""
        var semester: Int = 0

        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            updateDate <- (map["DATECODE"], ScheduleDateTransform())
            week <- map["WEEK"]
            schoolYear <- map["SCHOOLYEAR"]
            semester <- map["SEMESTER"]
        }

        func isSingleWeek() -> Bool {
            return week % 2 == 0 ? false : true
        }

        func isThisWeek() -> Bool {
            let comp1 = Timeline.getComponents(self.updateDate)
            let comp2 = Timeline.getComponents(Date())
            return (comp1.weekOfYear == comp2.weekOfYear)
        }

        static let calendar: Calendar = {
            var c = Calendar(identifier: Calendar.Identifier.gregorian)
            c.firstWeekday = 2
            return c
        }()

        static func getComponents(_ date: Date) -> DateComponents {
            return (Timeline.calendar as NSCalendar).components([
                    NSCalendar.Unit.year,
                    NSCalendar.Unit.month,
                    NSCalendar.Unit.day,
                    NSCalendar.Unit.weekOfYear,
                    NSCalendar.Unit.hour,
                    NSCalendar.Unit.minute,
                    NSCalendar.Unit.second,
                    NSCalendar.Unit.weekday,
                    NSCalendar.Unit.weekdayOrdinal,
                ], from: date
            )
        }
    }

    func getTodayWeekDay() -> Int {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.current
        var comps = (calendar as NSCalendar).component(NSCalendar.Unit.weekday, from: Date())
        /**
        Weekday units are the numbers 1 through n, where n is the number of days in the week.
        For example, in the Gregorian calendar, n is 7 and Sunday is represented by 1.
        */
        if comps == 1 {
            comps = 7
        } else {
            comps -= 1
        }
        return comps
    }
}

// MARK: - Transform
extension MineCourseSchedule {
    class ScheduleDateTransform: DateFormatterTransform {
        init() {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            super.init(dateFormatter: formatter)
        }
    }
}
