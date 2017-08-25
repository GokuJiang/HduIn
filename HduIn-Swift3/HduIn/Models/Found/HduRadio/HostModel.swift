//
//  HostModel.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/2/3.
//  Copyright © 2017年 姜永铭. All rights reserved.
//
import Foundation
import ObjectMapper
class HostModel : NSObject, NSCoding, Mappable{
    
    var audioUrl : String?
    var avatarUrl : String?
    var createdAt : String?
    var id : Int?
    var introduction : String?
    var level : Int?
    var name : String?
    var programs : [Program]?
    var updatedAt : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return HostModel()
    }
    required  init?(map: Map){
        
    }
    private override init(){}
    
    func mapping(map: Map)
    {
        audioUrl <- map["audio_url"]
        avatarUrl <- map["avatar_url"]
        createdAt <- map["createdAt"]
        id <- map["id"]
        introduction <- map["introduction"]
        level <- map["level"]
        name <- map["name"]
        programs <- map["programs"]
        updatedAt <- map["updatedAt"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        audioUrl = aDecoder.decodeObject(forKey: "audio_url") as? String
        avatarUrl = aDecoder.decodeObject(forKey: "avatar_url") as? String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        introduction = aDecoder.decodeObject(forKey: "introduction") as? String
        level = aDecoder.decodeObject(forKey: "level") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        programs = aDecoder.decodeObject(forKey: "programs") as? [Program]
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if audioUrl != nil{
            aCoder.encode(audioUrl, forKey: "audio_url")
        }
        if avatarUrl != nil{
            aCoder.encode(avatarUrl, forKey: "avatar_url")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if introduction != nil{
            aCoder.encode(introduction, forKey: "introduction")
        }
        if level != nil{
            aCoder.encode(level, forKey: "level")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if programs != nil{
            aCoder.encode(programs, forKey: "programs")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        
    }
    
}
