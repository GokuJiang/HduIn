////
////  NewsCategory.swift
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
//class NewsCategory: Object {
//
//    dynamic var id = ""
//    dynamic var name = ""
//
//    var posts: [NewsPost] {
//        return linkingObjects(NewsPost.self, forProperty: "categories")
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
//
//    struct Meta {
//        var pages = 0
//        var count = 0
//
//        var categories: [NewsCategory] = []
//    }
//}
//
//extension NewsCategory {
//    override static func primaryKey() -> String? {
//        return "id"
//    }
//}
//
//extension NewsCategory: Mappable {
//    func mapping(map: Map) {
//        id <- map["_id"]
//        name <- map["name"]
//    }
//}
//
//extension NewsCategory.Meta: Mappable {
//    init?(map: Map) {}
//
//    mutating func mapping(map: Map) {
//        pages <- map["meta.pages"]
//        count <- map["meta.count"]
//
//        categories <- map["data"]
//    }
//}
