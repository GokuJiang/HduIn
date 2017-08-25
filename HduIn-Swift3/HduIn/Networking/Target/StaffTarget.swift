//
//  StaffTarget.swift
//  HduIn
//
//  Created by Lucas Woo on 2/28/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum StaffTarget {
    case cardConsume
    case cardRemaining

    case runningInfo
    case runningAchievement
}

extension StaffTarget: APITarget {
    var baseURL: URL {
        switch self {
        case .cardConsume, .cardRemaining:
            return Networking.hduapiURL
        default:
            return Networking.baseURL
        }
    }

    var path: String {
        switch self {
        case .cardConsume:
            return "/card/consume/\(UserModel.staffId)"
        case .cardRemaining:
            return "/card/remaining/\(UserModel.staffId)"

        case .runningInfo:
            return "/run/info/\(UserModel.staffId)"
        case .runningAchievement:
            return "/run/achievements/\(UserModel.staffId)"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .cardConsume:
            return ["sort": "-DEALTIME"]
        default:
            return nil
        }
    }

    var acceptVersion: String {
        return "~2.0.0"
    }

    var auth: APIAuthType {
        return .Default
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    var task: Task {
        return .request
    }
}
