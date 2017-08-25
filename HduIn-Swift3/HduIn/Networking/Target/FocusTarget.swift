//
//  FocusTarget.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/19.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import Moya


enum FocusTarget {
    case album
    case singleAlbum(String)
    case photo
    case singlePhoto(String)
    case photographer
    case singlePhotographer(String)
    case article
    case singleArticle(String)
    case like(Int)
}

extension FocusTarget: APITarget {
    public var task: Task {
        return .request
    }
    
    
    var baseURL: URL {
        return URL(string: "http://115.28.92.130:1337")!

    }
    
    var path: String {
        switch self {
        case .album:
            return "/Focus_Album"
        case .singleAlbum(let Album_id):
            return "/Focus_Album/\(Album_id)"
        case .photo:
            return "/Focus_Photo"
        case .singlePhoto(let photo_id):
            return "/Focus_Photo/\(photo_id)"
        case .photographer:
            return "/Focus_Photographer"
        case .singlePhotographer(let photographer_id):
            return "/Focus_Photographer/\(photographer_id)"
        case .article:
            return "/Focus_Article"
        case .singleArticle(let article_id):
            return "/Focus_Article/\(article_id)"
        case .like( _):
            return "Focus_Photo/like"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .like:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
//        case .search(let keyword, let page):
//            return [
//                "keyword": "\(keyword)",
//                "page": "\(page)"
//            ]
        case .like(let photoid):
            return ["id":"\(photoid)"]
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
