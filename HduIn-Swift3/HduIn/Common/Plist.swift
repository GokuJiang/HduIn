//
//  Plist.swift
//  HduIn
//
//  Created by Lucas on 15/9/11
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit
class Plist {

    static let sharedInstance = Plist()
//    private let queue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    fileprivate let queue = DispatchQueue(label: "cc.jiayuan.plist")
    fileprivate let path: String
    fileprivate let cache: NSMutableDictionary

    fileprivate init() {
        self.path = (NSSearchPathForDirectoriesInDomains(
                .applicationSupportDirectory,
                .userDomainMask, true
            )[0] as NSString)
            .appendingPathComponent("HduIn.plist")
        if Plist.isPlistFileExists() {
            self.cache = NSMutableDictionary(contentsOfFile: self.path)!
        } else {
            self.cache = Plist.generateInitialPlist()
            self.sync()
        }
    }

    subscript(key: String) -> Any? {
        get {
            return self.cache.object(forKey: key)
        }
        set(value) {
            self.cache.setValue(value, forKey: key)
   
            self.sync()
        }
    }

    func sync() {
        queue.async {
            guard let cache = self.cache.copy() as? NSDictionary else {
                return
            }
            let result = cache.write(toFile: self.path, atomically: true)
            if !result {
                log.error("Plist write to file failed.")

            }
        }
    }

    fileprivate class func generateInitialPlist() -> NSMutableDictionary {
        let template = NSMutableDictionary()
        template["isFirst"] = NSNumber(value: true)
        return template
    }

    fileprivate class func isPlistFileExists() -> Bool {
        let applicationSupportPath = NSSearchPathForDirectoriesInDomains(
                .applicationSupportDirectory,
                .userDomainMask,
            true
        )[0]
        let plistPath = (applicationSupportPath as NSString)
            .appendingPathComponent("HduIn.plist")
        do {
            try FileManager.default.createDirectory(
                atPath: applicationSupportPath,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            log.error("Create application support path failed with error: \(error)")
        }
        return FileManager.default.fileExists(atPath: plistPath)
    }
}
