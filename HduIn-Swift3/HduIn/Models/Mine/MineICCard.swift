//
//  MineICCard.swift
//  HduIn
//
//  Created by Lucas on 9/24/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import ObjectMapper

struct MineICCard {

    struct ConsumeRecord: Mappable {
        var date:Date = Date()
        var amount: Double = 0

        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            date <- (map["DEALTIME"], ISO8601DateTransform())
            amount <- map["MONDEAL"]
        }
    }

    struct Remaining: Mappable {
        var value: Double = 0

        init?(map: Map) {

        }

        mutating func mapping(map: Map) {
            value <- map["REMAINING"]
        }
    }
}
