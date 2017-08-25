//
//	ReservationInfo.swift
//
//	Create by 骏垒 杨 on 24/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ReservationInfo : NSObject, NSCoding, Mappable{

	var author : String?
	var deadline : String?
	var status : String?
	var surplusDays : Int?
	var title : String?


	class func newInstance(map: Map) -> Mappable?{
		return ReservationInfo()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		author <- map["author"]
		deadline <- map["deadline"]
		status <- map["status"]
		surplusDays <- map["surplusDays"]
		title <- map["title"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         author = aDecoder.decodeObject(forKey: "author") as? String
         deadline = aDecoder.decodeObject(forKey: "deadline") as? String
         status = aDecoder.decodeObject(forKey: "status") as? String
         surplusDays = aDecoder.decodeObject(forKey: "surplusDays") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if author != nil{
			aCoder.encode(author, forKey: "author")
		}
		if deadline != nil{
			aCoder.encode(deadline, forKey: "deadline")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if surplusDays != nil{
			aCoder.encode(surplusDays, forKey: "surplusDays")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}