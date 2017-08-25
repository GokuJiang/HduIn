//
//	BookViewInfo.swift
//
//	Create by 骏垒 杨 on 24/1/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class BookViewInfo : NSObject, NSCoding, Mappable{

	var author : String?
	var bookId : String?
	var deadline : String?
	var lentDate : String?
	var title : String?


	class func newInstance(map: Map) -> Mappable?{
		return BookViewInfo()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		author <- map["author"]
		bookId <- map["bookId"]
		deadline <- map["deadline"]
		lentDate <- map["lentDate"]
		title <- map["title"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         author = aDecoder.decodeObject(forKey: "author") as? String
         bookId = aDecoder.decodeObject(forKey: "bookId") as? String
         deadline = aDecoder.decodeObject(forKey: "deadline") as? String
         lentDate = aDecoder.decodeObject(forKey: "lentDate") as? String
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
		if bookId != nil{
			aCoder.encode(bookId, forKey: "bookId")
		}
		if deadline != nil{
			aCoder.encode(deadline, forKey: "deadline")
		}
		if lentDate != nil{
			aCoder.encode(lentDate, forKey: "lentDate")
		}
		if title != nil{
			aCoder.encode(title, forKey: "title")
		}

	}

}