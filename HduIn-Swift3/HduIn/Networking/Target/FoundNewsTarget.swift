//
//  FoundNewsTarget.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/4/4.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import Moya

enum FoundNewsTarget {
    case banner
    case list
}


extension FoundNewsTarget: APITarget {
    public var task: Task {
        return .request
    }
    
    
    var baseURL: URL {
        return URL(string: "http://115.28.92.130:1337")!
        
    }
    
    var path: String {
        switch self {
        case .banner:
            return "/News_Banner"
        case .list:
            return "/News_News"
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
