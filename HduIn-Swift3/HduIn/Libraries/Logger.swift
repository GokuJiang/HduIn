//
//  Logger.swift
//  HduIn
//
//  Created by Lucas Woo on 1/4/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import XCGLogger

let log = XCGLogger(identifier: "xyz.hduin", includeDefaultDestinations: false)
let print = log
let debugPrint = log

func setupLogger() {
    setenv("XcodeColors", "YES", 0)

    let systemDestination = AppleSystemLogDestination(owner: log, identifier: "xyz.hduin.syslog")
    systemDestination.showLogIdentifier = false
    systemDestination.showFunctionName = true
    systemDestination.showThreadName = true
    systemDestination.showLevel = true
    systemDestination.showFileName = true
    systemDestination.showLineNumber = true
    systemDestination.showDate = true

    systemDestination.outputLevel = .severe

    #if DEBUG
        systemDestination.outputLevel = .debug
    #endif

    log.add(destination: systemDestination)
    
    let fileDestination = FileDestination(writeToFile: "/home/log/HudIn", identifier: "xyz.hduin.filelog")
    
    // Optionally set some configuration options
    fileDestination.outputLevel = .debug
    fileDestination.showLogIdentifier = false
    fileDestination.showFunctionName = true
    fileDestination.showThreadName = true
    fileDestination.showLevel = true
    fileDestination.showFileName = true
    fileDestination.showLineNumber = true
    fileDestination.showDate = true
    
    // Process this destination in the background
    fileDestination.logQueue = XCGLogger.logQueue
    
    // Add the destination to the logger
    log.add(destination: fileDestination)
    
    log.logAppDetails()
}
