//
//  Moya+ObjectMapper.swift
//  HduIn
//
//  Created by Lucas Woo on 2/28/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper

extension Response {

    /**
    Maps data received from the signal into an object which implements the Mappable protocol.

    - throws: If the conversion fails, the signal errors.

    - returns: An object which implements the Mappable protocol.
    */
    func mapObject<T: Mappable>() throws -> T {
        guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
            throw Moya.Error.jsonMapping(self)
        }
        return object
    }


    /**
    Maps data received from the signal into an array of objects which implement the
    Mappable protocol.

    - throws: If the conversion fails, the signal errors.

    - returns: Array of objects which implement the Mappable protocol.
    */
    func mapArray<T: Mappable>() throws -> [T] {
        guard let objects = Mapper<T>().mapArray(JSONObject: try mapJSON()) else {
            throw Moya.Error.jsonMapping(self)

        }
        return objects
    }

}
