//
//  ArticleModel.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/19.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper

struct ArticleModel: Mappable {
    var cover : String = ""
    var createdAt:String = ""
    var id : Int = -1
    var summary : String = ""
    var title : String = ""
    var updatedAt:String = ""
    var url : String = ""
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map){
        cover <- map["cover"]
        createdAt <- map["createdAt"]
        id <- map["id"]
        summary <- map["summary"]
        title <- map["title"]
        updatedAt <- map["updatedAt"]
        url <- map["url"]
    }
}
