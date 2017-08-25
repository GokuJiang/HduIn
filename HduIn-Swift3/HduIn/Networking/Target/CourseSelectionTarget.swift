//
//  CourseSelectionTarget.swift
//  HduIn
//
//  Created by Lucas Woo on 4/9/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum CourseSelectionTarget {
    case District

    case GetStars
    case CreateStar(String)
    case SubmitStar
    case DeleteStar(String)

    case GetSelected
    case DeleteSelected(String)

    case GetPublics
    case SelectPublic(String)

    case GetPEs
    case SelectPE(String)
}

extension CourseSelectionTarget: APITarget {
    var baseURL: URL { return Networking.baseURL }

    var path: String {
        switch self {
        case .District:
            return "/selection/district"
        case .GetStars:
            return "/selection/stars"
        case .CreateStar:
            return "/selection/stars"
        case .SubmitStar:
            return "/selection/stars"
        case .DeleteStar(let selectCode):
            return "/selection/stars/\(selectCode)"
        case .GetSelected:
            return "/selection/selected"
        case .DeleteSelected(let selectCode):
            return "/selection/selected/\(selectCode)"
        case .GetPublics:
            return "/selection/courses/public"
        case .SelectPublic:
            return "/selection/courses/public"
        case .GetPEs:
            return "/selection/courses/pe"
        case .SelectPE:
            return "/selection/courses/pe"
        }
    }

    var method: Moya.Method {
        switch self {
        case .CreateStar:
            return .post
        case .SubmitStar:
            return .put
        case .DeleteStar:
            return .delete
        case .DeleteSelected:
            return .delete
        case .SelectPublic:
            return .post
        case .SelectPE:
            return .post
        default:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .CreateStar(let selectCode):
            return ["select_code": selectCode]
        case .SubmitStar:
            return ["action": "submit"]
        case .SelectPublic(let selectCode):
            return ["select_code": selectCode]
        case .SelectPE(let selectCode):
            return ["select_code": selectCode]
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
