//
//  TokenTarget.swift
//  HduIn
//
//  Created by Lucas Woo on 3/3/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum TokenTarget {
    case info
    case refresh
    case wechat
}

extension TokenTarget: APITarget {


    public var baseURL: URL { return Networking.baseURL }

    public var path: String {
        switch self {
        case .info:
            return "/token"
        case .refresh:
            return "/auth/refresh"
        case .wechat:
            return "/token/wechat"
        }
    }

    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .refresh:
            return [
                "refresh_token": UserModel.refreshToken,
            ]
        default:
            return nil
        }
    }

    public var acceptVersion: String {
        switch self {
        case .refresh:
            return ""
        default:
            return "~2.0.0"
        }
    }

    public var auth: APIAuthType {
        return .Default
    }

   public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
   public var task: Task {
        return .request
    }
}
