////
////  NewsPost.swift
////  HduIn
////
////  Created by Lucas Woo on 3/28/16.
////  Copyright © 2016 Redhome. All rights reserved.
////
//
//import Foundation
//import ObjectMapper
//import Realm
//import RealmSwift
//
//class NewsPost: Object {
//
//    // MARK: Meta props
//    dynamic var id = ""
//
//    dynamic var weight = 0
//
//    dynamic var state = ""
//
//    dynamic var modeString = ""
//    var mode: Mode { return Mode(rawValue: modeString) ?? .Common }
//
//    // MARK: Props
//    dynamic var imageURLString: String?
//    dynamic var title = ""
//    dynamic var slug = ""
//
//    dynamic var publishedDate = NSDate()
//    var categories = List<NewsCategory>()
//
//    // MARK: Content
//    dynamic var brief = ""
//
//    // MARK: Response Meta
//    struct Meta {
//        var pages = 0
//        var count = 0
//
//        var posts: [NewsPost] = []
//    }
//
//    required init() {
//        super.init()
//    }
//
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        super.init(realm: realm, schema: schema)
//    }
//
//    convenience required init?( map: Map) {
//        self.init()
//    }
//
//    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
//    }
//}
//
//extension NewsPost {
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//
//    override static func indexedProperties() -> [String] {
//        return ["title"]
//    }
//}
//
//extension NewsPost: Mappable {
//    func mapping(map: Map) {
//        id <- map["_id"]
//        weight <- map["weight"]
//
//        modeString <- map["mode"]
//        state <- map["state"]
//
//        imageURLString <- map["image"]
//        title <- map["title"]
//        slug <- map["slug"]
//        brief <- map["content.brief"]
//
//        publishedDate <- (map["publishedDate"], ISO8601DateTransform())
//        categories <- (map["categories"], ListTransform<NewsCategory>())
//    }
//}
//
//extension NewsPost.Meta: Mappable {
//    init?(map: Map) {}
//
//    mutating func mapping(map: Map) {
//        pages <- map["meta.pages"]
//        count <- map["meta.count"]
//
//        posts <- map["data"]
//    }
//}
//
//extension NewsPost {
//    enum State: String {
//        case Published = "published"
//        case Archived = "archived"
//    }
//
//    enum Mode: String {
//        case Common = "common"
//        case Hybrid = "hybrid"
//        case Banner = "banner"
//    }
//}
