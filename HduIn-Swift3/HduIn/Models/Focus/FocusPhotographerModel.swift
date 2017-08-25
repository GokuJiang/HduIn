//
//  FocusPhotogragherModel.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/19.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper

class FocusPhotographerModel : NSObject, NSCoding, Mappable{
    
    var avatar : String?
    var createdAt : String?
    var descriptionField : String?
    var id : Int?
    var name : String?
    var photos : [Photo]?
    var updatedAt : String?
    var wechat : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return FocusPhotographerModel()
    }
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        createdAt <- map["createdAt"]
        descriptionField <- map["description"]
        id <- map["id"]
        name <- map["name"]
        photos <- map["photos"]
        updatedAt <- map["updatedAt"]
        wechat <- map["wechat"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        name = aDecoder.decodeObject(forKey: "name") as? String
        photos = aDecoder.decodeObject(forKey: "photos") as? [Photo]
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        wechat = aDecoder.decodeObject(forKey: "wechat") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    public func encode(with aCoder: NSCoder)
    {
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if photos != nil{
            aCoder.encode(photos, forKey: "photos")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        if wechat != nil{
            aCoder.encode(wechat, forKey: "wechat")
        }
        
    }
    
}
