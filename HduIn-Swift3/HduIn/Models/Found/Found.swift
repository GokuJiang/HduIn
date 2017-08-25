
//
//  Found.swift
//  HduIn
//
//  Created by Goku on 16/01/2017.
//  Copyright © 2017 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper

struct FoundModel :  Mappable{
    
    var author : String?
    var content : String?
    var coverUrl : String?
    var createdAt : String?
    var id : Int?
    var summary : String?
    var title : String?
    var updatedAt : String?
    var url : String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map){
        author <- map["author"]
        content <- map["content"]
        coverUrl <- map["cover_url"]
        createdAt <- map["createdAt"]
        id <- map["id"]
        summary <- map["summary"]
        title <- map["title"]
        updatedAt <- map["updatedAt"]
        url <- map["url"]
        
    }
    
    
}
