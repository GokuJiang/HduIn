

//
//  AlbumModel.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/19.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper

class FocusAlbumModel : NSObject, NSCoding, Mappable{
    
    var cover : String?
    var createdAt : String?
    var descriptionLable : String?
    var id : Int?
    var photos : [Photo]?
    var title : String?
    var updatedAt : String?
    
    class func newInstance(map: Map) -> Mappable?{
        return FocusAlbumModel()
    }
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map){
        cover <- map["cover"]
        createdAt <- map["createdAt"]
        descriptionLable <- map["description"]
        id <- map["id"]
        photos <- map["photos"]
        title <- map["title"]
        updatedAt <- map["updatedAt"]
    }

       /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cover = aDecoder.decodeObject(forKey: "cover") as? String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        descriptionLable = aDecoder.decodeObject(forKey: "description") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        photos = aDecoder.decodeObject(forKey: "photos") as? [Photo]
        title = aDecoder.decodeObject(forKey: "title") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    public func encode(with aCoder: NSCoder)
    {
        if cover != nil{
            aCoder.encode(cover, forKey: "cover")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if descriptionLable != nil{
            aCoder.encode(descriptionLable, forKey: "description")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if photos != nil{
            aCoder.encode(photos, forKey: "photos")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        
    }
    
}
