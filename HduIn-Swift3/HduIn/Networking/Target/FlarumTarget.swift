//
//  FlarumTarget.swift
//  HduIn
//
//  Created by 姜永铭 on 4/20/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum FlarumTarget {
    case get(String)
    case register(String, String)
    case token
    case login(String)
}

extension FlarumTarget: APITarget {
    var baseURL: URL {
        return URL(string: Networking.Base.Flarum.rawValue)!
    }

    var path: String {
        switch self {
        case .get(let id):
            return "/api/hduin/users/"+id
        case .register:
            return "/api/hduin/users"
        case .token:
            return "/api/hduin/token"
        case .login(let token):
            return "/auth/hduin?accessToken=" + token
        }
    }

    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        default:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .register(let name, let email):
            return ["data":[
                "type":"user",
                "attributes":["username":name,
                    "email":email]

                ]
            ]
        default:
            return nil
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    var task: Task {
        return .request
    }
    var acceptVersion: String {
        return "~2.0.0"
    }

    var auth: APIAuthType {
        switch self {
        case .get:
            return .None
        default:
            return .Default
        }
    }
}
