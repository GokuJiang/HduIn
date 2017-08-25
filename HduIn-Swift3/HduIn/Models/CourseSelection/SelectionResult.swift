//
//  SelectionResult.swift
//  HduIn
//
//  Created by Lucas Woo on 4/9/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import ObjectMapper

struct SelectionResult {
    var selectCode = ""
    var message = ""
}

extension SelectionResult: Mappable {
    init?( map: Map) {}

    mutating func mapping(map: Map) {
        selectCode <- map["select_code"]
        message <- map["result"]
    }
}
