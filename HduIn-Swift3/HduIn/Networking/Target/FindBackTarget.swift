//
//  FindBack.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/3/27.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import Moya

enum FindBackTarget{
    case FindoutLost(String, String)
    case FindoutFind(String, String)
    case fdfindhistory
    case fdlosthistory
    case FindoutLostItem(String)
    case FindoutFindItem(String)
    case searchLost(String)
    case searchFind(String)
    case markLost(String, String)
    case markFind(String, String)
    case upload(Data,String)
    case postFind(FindoutLostModel)
    case postLost(FindoutLostModel)
}

extension FindBackTarget: APITarget{
    public var task: Task{
        switch self {
        case .upload(let data,let name):
            let formData:[MultipartFormData] = [MultipartFormData(provider: .data(data), name: name)]
            return .upload(.multipart(formData))
        default:
            return .request
        }
        
    }
    
    var baseURL: URL{
        return Networking.hudinTestURL
    }
    
    var path: String{
        switch self {
        case .FindoutLost(let limit, let skip):
            return "/Findout_Lost/?limit=\(limit)&skip=\(skip)"
        case .FindoutFind(let limit, let skip):
            let requestPath = "/Findout_Find/?limit=\(limit)&skip=\(skip)"
            return requestPath
        case .searchLost:
            return "/Findout_Lost/search"
        case .searchFind:
            return "/Findout_Find/search"
        case .FindoutLostItem(let id):
            return "/Findout_Lost/\(id)"
        case .FindoutFindItem(let id):
            return "/Findout_Find/\(id)"
        case .markLost(let id, _):
            return "/Findout_Lost/\(id)"
        case .markFind(let id, _):
            return "/Findout_Find/\(id)"
        case .upload:
            return "/Upload/upload"
            
        case .postFind(let model):
            let path = "/Findout_Find"
            guard let queryString =  model.toString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return path
            }
            return path + queryString
            
        case .postLost(let model):
            let path = "/Findout_Lost/"
            guard let queryString = model.toString().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                return path
            }
            return path + queryString
            
        case .fdfindhistory:
            return "/Findout_Find?status=1&author=\(UserModel.staffId)"
        case .fdlosthistory:
            return "/Findout_Lost?status=1&author=\(UserModel.staffId)"
        }
    }
    
    var method: Moya.Method{
        switch self {
        case .FindoutLost:
            return .get
        case .FindoutFind:
            return .get
        case .searchLost:
            return .get
        case .searchFind:
            return .get
        case .FindoutFindItem:
            return .get
        case .FindoutLostItem:
            return .get
        case .fdfindhistory:
            return .get
        case .fdlosthistory:
            return .get
        case .markFind:
            return .delete
        case .markLost:
            return .delete
        default:
            return .post
        }
    }
    
    var parameters: [String: Any]?{
        switch self {
        case .searchLost(let keyword):
            return [
                "keyword":keyword
            ]
        case .searchFind(let keyword):
            return [
                "keyword" : keyword
            ]
        case .markLost(_, let number):
            return [
                "student_number": number
            ]
        case .markFind(_, let number):
            return [
                "student_number": number
            ]

        default:
            return nil
        }
    }
    
    var acceptVersion: String{
        return "~2.0.0"
    }
    
    var auth: APIAuthType{
        return .Default
    }
    
    var sampleData: Data{
        return "".data(using: String.Encoding.utf8)!
    }
}
