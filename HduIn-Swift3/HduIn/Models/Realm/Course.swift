//
//  Course.swift
//  HduIn
//
//  Created by Lucas on 9/24/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import ObjectMapper

class Course: Object, Mappable {

    // MARK: Properties

    dynamic var name = ""
    dynamic var teacher = ""
    dynamic var classroom = ""

    dynamic var startWeek = 0
    dynamic var endWeek = 0
    dynamic var weekDay = 0
    dynamic var distribute = ""

    dynamic var startSection = 0
    dynamic var endSection = 0

    var startTime: String? {
        return realm?.objects(CourseTime.self)
            .filter("lesson = %@", startSection).first?.startTime
    }
    var endTime: String? {
        return realm?.objects(CourseTime.self)
            .filter("lesson = %@", endSection).first?.endTime
    }

    // MARK: LifeCycle

    required init() {
        super.init()
    }

    required init?(map: Map) {
        super.init()
    }
//    convenience required init?(map: Map) {
//    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }    

    func mapping(map: Map) {
        name <- map["COURSE"]
        teacher <- map["TEACHER"]
        classroom <- map["CLASSROOM"]

        startWeek <- map["STARTWEEK"]
        endWeek <- map["ENDWEEK"]
        weekDay <- map["WEEKDAY"]
        distribute <- map["DISTRIBUTE"]

        startSection <- map["STARTSECTION"]
        endSection <- map["ENDSECTION"]
    }
}
