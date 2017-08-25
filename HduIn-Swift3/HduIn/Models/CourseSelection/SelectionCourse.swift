//
//  SelectionCourse.swift
//  HduIn
//
//  Created by Lucas Woo on 12/3/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import ObjectMapper

class SelectionCourse: Object {

    dynamic var selectCode = ""
    dynamic var name = ""
    dynamic var teacher = ""
    dynamic var time = ""
    dynamic var place = ""
    dynamic var total = 0
    dynamic var selectedCount = 0
    dynamic var category = ""

    var categoryType: Category? {
        return Category(rawValue: category)
    }

    var star: SelectionStar? {
        return realm?.objects(SelectionStar.self).filter("selectCode = %@", selectCode).first
    }

    required init() {
        super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    convenience required init?(map: Map) {
        self.init()
    }

    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    override static func primaryKey() -> String? {
        return "selectCode"
    }
    
    override static func indexedProperties() -> [String] {
        return ["category"]
    }

}



// MARK: - Mappable
extension SelectionCourse: Mappable {
    func mapping(map: Map) {
        selectCode <- map["select_code"]
        name <- map["name"]
        teacher <- map["teacher"]
        place <- map["place"]
        time <- map["time"]
        total <- map["total"]
        selectedCount <- map["selected_count"]
        category <- map["category"]
    }
}

extension SelectionCourse {
    enum Category: String {
        case Public = "public"
        case PE = "pe"
    }
}
