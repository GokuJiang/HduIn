//
//  ListTransform.swift
//  HduIn
//
//  Created by Lucas Woo on 3/28/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

//class ListTransform<T: Object>: TransformType where T: Mappable {

//    typealias Object = List<T>
//    typealias JSON = [AnyObject]
//
//    let mapper = Mapper<T>()
//
//    func transformFromJSON(_ value: Any?) -> Object? {
//        guard let array = value as? JSON else {
//            return nil
//        }
//        return Object(array.map { mapper.map($0) }.flatMap { object -> [T]in
//            switch object {
//            case .Some(let value):
//                return [value]
//            case .None:
//                return []
//            }
//        })
//    }
//
//    func transformToJSON(_ value: Object?) -> JSON? {
//        return value.map({
//            mapper.toJSON($0 as! T)
//        })
//    }
//}
