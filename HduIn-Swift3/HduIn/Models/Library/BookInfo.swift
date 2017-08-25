//
//	BookInfo.swift
//
//	Create by 骏垒 杨 on 22/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BookInfo : NSObject, NSCoding, Mappable{

	var author : String?
	var entities : [Entity]?
	var lentCount : Int?
	var position : String?
	var publisher : String?
	var title : String?


	class func newInstance(map: Map) -> Mappable?{
		return BookInfo()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		author <- map["author"]
		entities <- map["entities"]
		lentCount <- map["lentCount"]
		position <- map["position"]
		publisher <- map["publisher"]
		title <- map["title"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         author = aDecoder.decodeObject(forKey: "author") as? String
         entities = aDecoder.decodeObject(forKey: "entities") as? [Entity]
         lentCount = aDecoder.decodeObject(forKey: "lentCount") as? Int
         position = aDecoder.decodeObject(forKey: "position") as? String
         publisher = aDecoder.decodeObject(forKey: "publisher") as? String
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
		if entities != nil{
			aCoder.encode(entities, forKey: "entities")
		}
		if lentCount != nil{
			aCoder.encode(lentCount, forKey: "lentCount")
		}
		if position != nil{
			aCoder.encode(position, forKey: "position")
		}
		if publisher != nil{
			aCoder.encode(publisher, forKey: "publisher")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}