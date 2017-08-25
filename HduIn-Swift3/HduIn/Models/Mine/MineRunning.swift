//
//  MineRunning.swift
//  HduIn
//
//  Created by Lucas on 9/24/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import ObjectMapper

struct MineRunning {

    struct RunningInfo: Mappable {
        var times: Int = 0
        var speed: Double = 0
        var distance: Int = 0

        init() {
        }

        init?( map: Map) {
        }

        mutating func mapping(map: Map) {
            times <- map["times"]
            speed <- map["speed"]
            distance <- map["distance"]
        }
    }

    struct RunningAchievement: Mappable {
        var date: Date = Date()
        var domain: String = ""
        var isValid: Bool = false
        var speed: Double = 0
        var mileage: Int = 0

        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            date <- (map["date"], ISO8601DateTransform())
            domain <- map["domain"]
            isValid <- map["isValid"]
            speed <- map ["speed"]
            mileage <- map["mileage"]
        }
    }
}
