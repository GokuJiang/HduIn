//
//  LibraryTarget.swift
//  HduIn
//
//  Created by Kevin on 2017/1/16.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import Moya


enum LibraryTarget {
    case lentsIndex
    case rank
    case search(String,Int)
    case bookInfo(String)
    case viewHistory
    case reservation
    case renew(String)
}

extension LibraryTarget: APITarget {
    public var task: Task {
        return .request
    }
    
    
    var baseURL: URL {
        //        #if DEBUG
        //        return URL(string: Networking.Base.HduIn.rawValue)!
        //        #else
        return Networking.baseURL
        //  #endif
    }
    
    var path: String {
        switch self {
        case .lentsIndex:
            return "/library/v1/lents"
        case .rank:
            return "/library/v1/rank"
        case .search:
            return "/library/v1/search"
        case .bookInfo(let bookId):
            return "/library/v1/books/\(bookId)"
        case .viewHistory:
            return "/library/v1/lents/history"
        case .reservation:
            return "/library/v1/reservations"
        case .renew(let entityId):
            return "/library/v1/lents/\(entityId)/renew"
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
        case .search(let keyword, let page):
            return [
                "keyword": "\(keyword)",
                "page": "\(page)"
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
