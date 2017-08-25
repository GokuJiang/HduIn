//
//  CourseTime.swift
//  HduIn
//
//  Created by Lucas on 9/25/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

class CourseTime: Object, Mappable {

    // MARK: Properties
    dynamic var lesson = 0

    dynamic var startTime:String = ""
    dynamic var startHour = 0
    dynamic var startMinute = 0

    dynamic var endTime = ""
    dynamic var endHour = 0
    dynamic var endMinute = 0

    // MARK: LifeCycle
    required init() {
        super.init()
    }

    required convenience init?( map: Map) {
        self.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
        fatalError("init(value:schema:) has not been implemented")
    }

    func mapping(map: Map) {
        lesson <- map["LESSON"]
        startTime <- map["STARTTIME"]
        endTime <- map["ENDTIME"]

        startTime = startTime.trimmingCharacters(
            in: CharacterSet.whitespaces
        )
        endTime = endTime.trimmingCharacters(
            in: CharacterSet.whitespaces
        )

        let start = startTime.split(":")
        startHour = {
            if let a = Int(start[0]) {
                return a
            } else {
                return 0
            }
        }()
        startMinute = {
            if let a = Int(start[1]) {
                return a
            } else {
                return 0
            }
        }()

        let end = endTime.split(":")
        endHour = {
            if let a = Int(end[0]) {
                return a
            } else {
                return 0
            }
        }()
        endMinute = {
            if let a = Int(end[1]) {
                return a
            } else {
                return 0
            }
        }()
    }
}
