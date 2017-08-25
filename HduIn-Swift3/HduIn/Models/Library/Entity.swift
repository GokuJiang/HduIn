//
//	Entity.swift
//
//	Create by 骏垒 杨 on 22/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Entity : NSObject, NSCoding, Mappable{

	var campus : String?
	var isLent : Bool?
	var location : String?


	class func newInstance(map: Map) -> Mappable?{
		return Entity()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		campus <- map["campus"]
		isLent <- map["isLent"]
		location <- map["location"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         campus = aDecoder.decodeObject(forKey: "campus") as? String
         isLent = aDecoder.decodeObject(forKey: "isLent") as? Bool
         location = aDecoder.decodeObject(forKey: "location") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if campus != nil{
			aCoder.encode(campus, forKey: "campus")
		}
		if isLent != nil{
			aCoder.encode(isLent, forKey: "isLent")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}

	}

}