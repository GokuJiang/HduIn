//
//  Moya+SwiftyJSON.swift
//  HduIn
//
//  Created by Lucas Woo on 3/1/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

extension Response {

    func mapSwiftyJSON() throws -> JSON {
        let json = JSON(try mapJSON())
        return json
    }
}
