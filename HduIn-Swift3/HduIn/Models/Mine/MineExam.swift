//
// Created by Lucas Woo on 3/1/16.
// Copyright (c) 2016 Redhome. All rights reserved.
//

import Foundation
import ObjectMapper

struct MineExam {

    struct Schedule: Mappable {
        var startTime: Date = Date()
        var examTime: String = ""
        var examPlace: String = ""
        var examCourse: String = ""
        var seatNumber: Int = 0

        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            startTime <- (map["EXAMTIME"], ScheduleStartTimeTransform())
            examTime <- map["EXAMTIME"]
            examPlace <- map["CLASSROOM"]
            examCourse <- map["COURSE"]
            seatNumber <- map["SEAT"]
        }
    }

    struct ScoreRecord: Mappable {

        var schoolYear: String = ""
        var courseName: String = ""
        var courseType: String = ""
        var courseCredit: Float = 0
        var score: String = ""

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {
            schoolYear <- map["SCHOOLYEAR"]
            courseName <- map["COURSE"]
            courseType <- map["COURSETYPE"]
            courseCredit <- map["CREDIT"]
            score <- map["SCORE"]
        }
    }
}

// MARK: - Transform
extension MineExam {
    class ScheduleStartTimeTransform: TransformType {
        typealias Object = Date
        typealias JSON = String

        let dateFormatter: DateFormatter

        init() {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY年M月d日(HH:mm"

            self.dateFormatter = formatter
        }

        func transformFromJSON(_ value: Any?) -> Date? {
            if let dateString = value as? String {
                return dateFormatter.date(from: dateString.split("-")[0])
            }
            return nil
        }

        func transformToJSON(_ value: Date?) -> String? {
            if let date = value {
                return dateFormatter.string(from: date)
            }
            return nil
        }
    }
}
