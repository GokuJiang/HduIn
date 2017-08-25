//
//  HduRadioTarget.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/2/3.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import Moya

enum HduRadioTarget {
    case albumList
    case album(String)
    case programList
    case program(String)
    case hostList
    case host(String)
}

extension HduRadioTarget: APITarget {
    public var task: Task {
        return .request
    }
    
    
    var baseURL: URL {

        return URL(string: "http://115.28.92.130:1337")!

    }
    
    var path: String {
        switch self {
        case .albumList:
            return "/Radio_Album"
        case .album(let AlbumID):
            return "/Radio_Album/\(AlbumID)"
        case .programList:
            return "/Radio_Program"
        case .program(let programID):
            return "/Radio_Program/\(programID)"
        case .hostList:
            return "/Radio_Host"
        case .host(let hostID):
            return "/Radio_Host/\(hostID)"
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

