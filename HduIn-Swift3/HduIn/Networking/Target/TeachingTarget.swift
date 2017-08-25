//
//  TeachingTarget.swift
//  HduIn
//
//  Created by Lucas Woo on 3/4/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum TeachingTarget {
    case courseSchedule(String, Int)

    case examSchedule
    case examScore
}

extension TeachingTarget: APITarget {
    public var task: Task {
        return .request
    }


    var baseURL: URL { return Networking.hduapiURL }

    var path: String {
        switch self {
        case .courseSchedule:
            return "/teaching/schedule/\(UserModel.staffId)"

        case .examSchedule:
            return "/exam/schedule/\(UserModel.staffId)"
        case .examScore:
            return "/exam/grade_current/\(UserModel.staffId)"
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
        case .courseSchedule(let schoolYear, let semester):
            return [
                "sort": "WEEKDAY,STARTSECTION",
                "filter[SCHOOLYEAR]": schoolYear,
                "filter[SEMESTER]": "\(semester)",
                "page[limit]": 50,
            ]
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

}
