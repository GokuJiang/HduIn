//
//  RealmAgent.swift
//  HduIn
//
//  Created by Lucas on 9/24/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAgent {
    static var isLoggedPath = false
    static let schemaVersion: UInt64 = 1
    

    static func getDefaultConfigration() -> Realm.Configuration {
        let staffId = UserModel.staffId
        let documentPath: String = NSSearchPathForDirectoriesInDomains(
                .documentDirectory,
                .userDomainMask, true
        )[0]
        let path = (documentPath as NSString).appendingPathComponent("\(staffId).realm")


        let config = Realm.Configuration(
            fileURL: URL(fileURLWithPath: path),
            readOnly: false,
            schemaVersion: schemaVersion,
            migrationBlock: migration,
            deleteRealmIfMigrationNeeded: true)
        
               if !isLoggedPath {
            isLoggedPath = true
//            log.debug("Realm Path: \(path)")
        }
        return config
    }

    class func migration(_ migration: Migration, oldSchemaVersion: UInt64) {

    }
}
