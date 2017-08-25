//
//  Observable+ObjectMapper.swift
//  HduIn
//
//  Created by Lucas Woo on 2/28/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

extension ObservableType where E == Response {

    /**
    Maps data received from the signal into an object (on the default Background thread) which
    implements the Mappable protocol and returns the result back on the MainScheduler.

    - parameter type: If the conversion fails, the signal errors.

    - returns: Observable of an object implements the Mappable protocol
    */
    func mapObject<T: Mappable>(_ type: T.Type) -> Observable<T> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap  { response -> Observable <T> in
                return Observable.just(try response.mapObject())
            }
            .observeOn(MainScheduler.instance)
    }

    /**
    Maps data received from the signal into an array of objects (on the default Background thread)
    which implement the Mappable protocol and returns the result back on the MainScheduler

    - parameter type: If the conversion fails, the signal errors.

    - returns: Observable of an array of objects which implement the Mappable protocol
    */
    func mapArray<T: Mappable>(_ type: T.Type) -> Observable<[T]> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable < [T] > in
                return Observable.just(try response.mapArray())
        }
            .observeOn(MainScheduler.instance)
    }
}
