//
//  PublicTarget.swift
//  HduIn
//
//  Created by Lucas Woo on 3/3/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum PublicTarget {
    case schoolTimeTable
    case timeline
}

extension PublicTarget: APITarget {
    
    public var task: Task {
        return .request

    }

    var baseURL: URL { return Networking.hduapiURL }

    var path: String {
        switch self {
        case .schoolTimeTable:
            return "/public/schooltime/"
        case .timeline:
            return "/public/timeline/\(Date().toString(format: DateFormat.Custom("yyyyMMdd")))"
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
        case .schoolTimeTable:
            return [
                "page[limit]": 20,
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
