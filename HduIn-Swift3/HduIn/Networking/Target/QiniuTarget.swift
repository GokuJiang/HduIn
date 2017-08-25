//
//  QiniuTarget.swift
//  HduIn
//
//  Created by Goku on 18/05/2017.
//  Copyright © 2017 姜永铭. All rights reserved.
//

import UIKit
import Moya

enum QiniuTarget {
    case getToken
}

extension QiniuTarget:APITarget {
    var baseURL: URL { return Networking.hudinTestURL }
    
    var path: String {
        switch self {
        case .getToken:
            return "/Upload/uploadToken"
        }
    }
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        return nil
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
