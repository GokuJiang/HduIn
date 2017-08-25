//
//  Photo.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/19.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper

class Photo : NSObject, NSCoding, Mappable{
    required init?(map: Map) {
        
    }



    
    var album : Int?
    var createdAt : String?
    var id : Int?
    var like : Int?
    var photographer : Int?
    var updatedAt : String?
    var url : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Photo()
    }
    private override init(){}
    
    func mapping(map: Map)
    {
        album <- map["album"]
        createdAt <- map["createdAt"]
        id <- map["id"]
        like <- map["like"]
        photographer <- map["photographer"]
        updatedAt <- map["updatedAt"]
        url <- map["url"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        album = aDecoder.decodeObject(forKey: "album") as? Int
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        like = aDecoder.decodeObject(forKey: "like") as? Int
        photographer = aDecoder.decodeObject(forKey: "photographer") as? Int
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    func encode(with aCoder: NSCoder) 
    {
        if album != nil{
            aCoder.encode(album, forKey: "album")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if like != nil{
            aCoder.encode(like, forKey: "like")
        }
        if photographer != nil{
            aCoder.encode(photographer, forKey: "photographer")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
        
    }
    
}

