//
//  Album.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/2/3.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper


class Album : NSObject, NSCoding, Mappable{
    
    var coverUrl : String?
    var createdAt : Date?
    var date : Date?
    var id : Int?
    var introduction : String?
    var name : String?
    var updatedAt : Date?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Album()
    }
    private override init(){}
    required  init?(map: Map){
        
    }
    
    func mapping(map: Map)
    {
        coverUrl <- map["cover_url"]
        createdAt <- (map["createdAt"],ISO8601DateTransform())
        date <- (map["date"],ISO8601DateTransform())
        id <- map["id"]
        introduction <- map["introduction"]
        name <- map["name"]
        updatedAt <- (map["updatedAt"],ISO8601DateTransform())
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        coverUrl = aDecoder.decodeObject(forKey: "cover_url") as? String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        date = aDecoder.decodeObject(forKey: "date") as? Date
        id = aDecoder.decodeObject(forKey: "id") as? Int
        introduction = aDecoder.decodeObject(forKey: "introduction") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if coverUrl != nil{
            aCoder.encode(coverUrl, forKey: "cover_url")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if introduction != nil{
            aCoder.encode(introduction, forKey: "introduction")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        
    }
    
}
