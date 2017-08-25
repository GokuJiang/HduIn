//
//  FlarumModel.swift
//  HduIn
//
//  Created by 姜永铭 on 4/29/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
import RxSwift

class FlarumModel {

    static func getUserInfo(_ provider: APIProvider<FlarumTarget>,
                            failureClourse: @escaping  () -> Void,
                            successClourse:@escaping  () -> Void) {
        var success = true
        let staffId = UserModel.staffId
        _ = provider.request(FlarumTarget.get(staffId)) {result in
            switch result {
            case let .success(response):
                let json = JSON(data: response.data, options:.allowFragments)
                let errorJSON = json["error"]
                if errorJSON.exists() {
                    for (_, json):(String, JSON) in errorJSON {
                        if json["status"].stringValue == "404"{
                            log.error("404")
                        }
                    }
                    success = false
                    break
                } else {
                    log.debug("success")
                }

            case .failure(_):
                break
            }
            if !success {
                failureClourse()
            } else {
                successClourse()
            }
        }
    }

    static func register(_ provider: APIProvider<FlarumTarget>,
                         clourse:@escaping (_ statusCode: Int, _ isSuccess: Bool) -> Void,
                         userName: String,
                         email: String) {
        _ = provider.request(FlarumTarget.register(userName, email)) { result in
            var success = false
            var statusCode = 201
            switch result {
            case let .success(response):
                let json = JSON(data: response.data, options:.allowFragments)
                let errorJSON = json["error"]
                if errorJSON.exists() {
                    for (_, json):(String, JSON) in errorJSON {
                        statusCode = json["status"].intValue
                        break
                    }
                    break
                } else {
                    success = true
                    log.debug("success")
                }

            case .failure(_):
                success = false
                break
            }

            clourse(statusCode, success)
        }
    }

}
