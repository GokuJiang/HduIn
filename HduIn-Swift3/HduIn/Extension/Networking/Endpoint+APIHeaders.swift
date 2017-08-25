//
//  Endpoint+APIHeaders.swift
//  HduIn
//
//  Created by Lucas Woo on 2/29/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

extension Endpoint where Target: APITarget {

    func endpointByAddingAPIHeaders(_ target: Target) -> Endpoint<Target> {
        switch target.auth {
        case .None:
            return self
        default:
            return self.adding(newHttpHeaderFields: [
                "X-Access-Token": UserModel.apiToken,
                "Accept-Version": target.acceptVersion,
                "X-Requested-With": BundleInfo.Identifier!
                ])

        }
    }
}
