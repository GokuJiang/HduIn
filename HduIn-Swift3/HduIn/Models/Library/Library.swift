//
//  LibraryLents.swift
//  HduIn
//
//  Created by Kevin on 2017/1/16.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper



struct Library{
    
    struct LibraryLents:Mappable{
        var entityId:String = ""
        var title:String = ""
        var author:String = ""
        var publisher:String = ""
        var position:String = ""
        var surplusDays:Int = -1
        var deadline:String = ""
        var renewedTimes:Int = -1
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            entityId <- (map["entityId"])
            title <- map["title"]
            author <- map["author"]
            publisher <- map["publisher"]
            position <- map["position"]
            surplusDays <- map["surplusDays"]
            deadline <- map["deadline"]
            renewedTimes <- map["renewedTimes"]
        }
    }
    
    struct RankList:Mappable {
        var bookId:String = ""
        var title:String = ""
        var lentCount:String = ""
        
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            bookId <- (map["bookId"])
            title <- map["title"]
            lentCount <- map["lentCount"]
        }
        
        
    }
    
    struct SearchList:Mappable {
        var bookId:String = ""
        var title:String = ""
        var author:String = ""
        var position:String = ""
        var allCount:String = ""
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            bookId <- (map["bookId"])
            title <- map["title"]
            author <- map["author"]
            position <- map["position"]
            allCount <- map["allCount"]
        }
    }
    
    struct BookInfo: Mappable{
        var title: String = ""
        var author: String = ""
        var lentCount: Int = 0
        var publisher: String = ""
        var position: String = ""
        var entitis: [Entitis] = []
        
        init?(map: Map){
            
        }
        
        mutating func mapping(map: Map) {
            title <- map["title"]
            author <- map["author"]
            lentCount <- map["lentCount"]
            publisher <- map["publisher"]
            position <- map["position"]
            entitis <- map["entitis"]
        }
    }
    
    struct Entitis: Mappable {
        var isLent: Bool = true
        var location: String = ""
        var campus: String = ""
        
        init?(map: Map){
            
        }
        
        mutating func mapping(map: Map) {
            isLent <- map["isLent"]
            location <- map["location"]
            campus <- map["campus"]
        }
    }
    
    struct BookViewInfo: Mappable {
        var author : String = ""
        var bookId : String = ""
        var deadline : String = ""
        var lentDate : String = ""
        var title : String = ""
        
        init?(map: Map){
            
        }
        
        mutating func mapping(map: Map) {
            author <- map["author"]
            bookId <- map["bookId"]
            deadline <- map["deadline"]
            lentDate <- map["lentDate"]
            title <- map["title"]
        }
    }
    
    struct BookRenew:Mappable{
        var result:String = ""
        init?(map: Map){
            
        }
        
        mutating func mapping(map: Map) {
            result <- map["result"]
        }

    }
    
}
