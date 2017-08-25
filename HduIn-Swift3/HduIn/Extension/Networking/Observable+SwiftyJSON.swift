//
//  Observable+SwiftyJSON.swift
//  HduIn
//
//  Created by Lucas Woo on 3/1/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import SwiftyJSON

extension ObservableType where E == Response {

    func mapSwiftyJSON() -> Observable<JSON> {
        return observeOn(SerialDispatchQueueScheduler(qos: .background))
            .flatMap { response -> Observable<JSON> in
                return Observable.just(try response.mapSwiftyJSON())
            }
            .observeOn(MainScheduler.instance)
    }
}
