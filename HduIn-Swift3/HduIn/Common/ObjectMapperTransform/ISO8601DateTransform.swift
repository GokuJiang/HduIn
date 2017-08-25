//
//  ISO8601DateTransform.swift
//  HduIn
//
//  Created by Lucas Woo on 3/3/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import ObjectMapper

class ISO8601DateTransform: DateFormatterTransform {

    init() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        super.init(dateFormatter: formatter)
    }

}
