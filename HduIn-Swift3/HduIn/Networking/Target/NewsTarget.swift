//
//  NewsTarget.swift
//  HduIn
//
//  Created by Lucas Woo on 3/29/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum NewsTarget {
    case posts(Int, Int)
    case categories(Int, Int)
}

extension NewsTarget: TargetType {
    public var task: Task {
        return .request
    }

    var baseURL: URL {
        return URL(string: Networking.Base.News.rawValue)!
    }

    var path: String {
        switch self {
        case .posts:
            return "/api/posts"
        case .categories:
            return "/api/categories"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        switch self {
        case .posts(let offset, let size):
            return [
                "sort": "publishedDate",
                "fields": "_id,weight,mode,image,title,slug," +
                    "content.brief,state,publishedDate,author,categories",
                "page[number]": offset / size + 1,
                "page[size]": size
            ]
        case .categories(let offset, let size):
            return [
                "page[offset]": offset,
                "page[size]": size
            ]
        }
    }

    var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }

}
