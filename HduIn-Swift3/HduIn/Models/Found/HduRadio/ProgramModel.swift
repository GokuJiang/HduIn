//
//  ProgramModel.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/2/3.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper

class ProgramModel : NSObject, NSCoding, Mappable{
    
    var album : Album?
    var audioUrl : String?
    var bgimageUrl : String?
    var coverUrl : String?
    var createdAt : Date?
    var director : Director?
    var duration : String?
    var hosts : [Director]?
    var id : Int?
    var issue : String?
    var name : String?
    var producer : Director?
    var times : String?
    var updatedAt : Date?
    var uploadTime : Date?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ProgramModel()
    }
    private override init(){}
    required  init?(map: Map){
        
    }
    
    func mapping(map: Map)
    {
        album <- map["album"]
        audioUrl <- map["audio_url"]
        bgimageUrl <- map["bgimage_url"]
        coverUrl <- map["cover_url"]
        createdAt <- (map["createdAt"],ISO8601DateTransform())
        director <- map["director"]
        duration <- map["duration"]
        hosts <- map["hosts"]
        id <- map["id"]
        issue <- map["issue"]
        name <- map["name"]
        producer <- map["producer"]
        times <- map["times"]
        updatedAt <- (map["updatedAt"],ISO8601DateTransform())
        uploadTime <- (map["upload_time"],ISO8601DateTransform())
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        album = aDecoder.decodeObject(forKey: "album") as? Album
        audioUrl = aDecoder.decodeObject(forKey: "audio_url") as? String
        bgimageUrl = aDecoder.decodeObject(forKey: "bgimage_url") as? String
        coverUrl = aDecoder.decodeObject(forKey: "cover_url") as? String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? Date
        director = aDecoder.decodeObject(forKey: "director") as? Director
        duration = aDecoder.decodeObject(forKey: "duration") as? String
        hosts = aDecoder.decodeObject(forKey: "hosts") as? [Director]
        id = aDecoder.decodeObject(forKey: "id") as? Int
        issue = aDecoder.decodeObject(forKey: "issue") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        producer = aDecoder.decodeObject(forKey: "producer") as? Director
        times = aDecoder.decodeObject(forKey: "times") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? Date
        uploadTime = aDecoder.decodeObject(forKey: "upload_time") as? Date
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if album != nil{
            aCoder.encode(album, forKey: "album")
        }
        if audioUrl != nil{
            aCoder.encode(audioUrl, forKey: "audio_url")
        }
        if bgimageUrl != nil{
            aCoder.encode(bgimageUrl, forKey: "bgimage_url")
        }
        if coverUrl != nil{
            aCoder.encode(coverUrl, forKey: "cover_url")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if director != nil{
            aCoder.encode(director, forKey: "director")
        }
        if duration != nil{
            aCoder.encode(duration, forKey: "duration")
        }
        if hosts != nil{
            aCoder.encode(hosts, forKey: "hosts")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if issue != nil{
            aCoder.encode(issue, forKey: "issue")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if producer != nil{
            aCoder.encode(producer, forKey: "producer")
        }
        if times != nil{
            aCoder.encode(times, forKey: "times")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        if uploadTime != nil{
            aCoder.encode(uploadTime, forKey: "upload_time")
        }
        
    }
    
}
