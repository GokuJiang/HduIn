//
//  SelectionStar.swift
//  HduIn
//
//  Created by Lucas Woo on 4/10/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import ObjectMapper

class SelectionStar: Object {
    dynamic var selectCode = ""
    dynamic var category = ""

    var categoryType: SelectionCourse.Category? {
        return SelectionCourse.Category(rawValue: category)
    }

    var course: SelectionCourse? {
        return realm?.objects(SelectionCourse.self).filter("selectCode = %@", selectCode).first
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
        super.init(value: value, schema: schema)
    }
    
    override static func primaryKey() -> String? {
        return "selectCode"
    }
    
    override static func indexedProperties() -> [String] {
        return ["category", "category"]
    }

}



// MARK: - Mappable
extension SelectionStar: Mappable {
    func mapping(map: Map) {
        selectCode <- map["select_code"]
        category <- map["category"]
    }
}
