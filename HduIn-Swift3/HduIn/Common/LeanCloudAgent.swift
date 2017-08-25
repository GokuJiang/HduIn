//
//  LeanCloudAgent.swift
//  HduIn
//
//  Created by Lucas on 9/10/15.
//  Copyright (c) 2015 Redhome. All rights reserved.
//

import Foundation
import UIKit
import AVOSCloud
import AVOSCloudCrashReporting
import UserNotifications

class LeanCloudAgent {

    static func registerService(_ launchOptions: [AnyHashable: Any]?) {
        
        AVOSCloudCrashReporting.enable()
        LeanCloudAgent.registerSubclass()

        #if DEBUG
            // Register Debug service "HduIn-Test"
            AVOSCloud.setApplicationId(
                "leh34dmue91swq1o1z0e0fwo68zisf9k4mzkgmr3z1nbawxq",
                clientKey: "6moadsv4xv7lqglhx8am70l8jzs4kp3p0tcw2rz6ynvcxi7n"
            )
            AVOSCloud.setAllLogsEnabled(false)
        #else
            // Register Release service "HduIn"
            AVOSCloud.setApplicationId(
                "06h46ddqre5dwxqzygkzivlo61d596p0g4dfjru3accrxxot",
                clientKey: "e85vwf9gmyxtl04mmvzwjq4jd68sg02p5fv5q20e7ga7y4cz"
            )
            AVOSCloud.setAllLogsEnabled(false)
        #endif
        AVAnalytics.trackAppOpened(launchOptions: launchOptions)
        AVAnalytics.updateOnlineConfig()
        let installation = AVInstallation.current()
        installation["versionCode"] = BundleInfo.Version
        installation.saveEventually()
    }

    static func registerPushService(_ application: UIApplication) {
        // Register Apple Push Notification Service & LeanCloud Push Service
        guard let version =  Double(UIDevice.current.systemVersion)  else{
            return
        }
        
        if version >= 10.0 {
            let uncenter = UNUserNotificationCenter.current()
            uncenter.delegate = appDelegate
            uncenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (grant, error) in
                UIApplication.shared.registerForRemoteNotifications()
            })
            
            uncenter.getNotificationSettings(completionHandler: { (settings) in
                if settings.authorizationStatus == .notDetermined {
                    print.debug("未选择")
                }else if settings.authorizationStatus == .denied{
                    print.debug("未认证")
                }else if settings.authorizationStatus == .authorized {
                    print.debug("已认证")
                }
            })
        }
//        else if version >= 8.0 {
//            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
//            application.registerForRemoteNotifications()
//        }

        
    }

    static func getMajorSystemVersion() -> Int {
        // Return: 7 when device is iOS 7 or 8 when device is iOS 8, etc.
        return Int(String(Array(UIDevice.current.systemVersion.characters)[0]))!
    }

    static func registerSubclass() {}
}

// MARK: - Channels

extension LeanCloudAgent {

    enum Channel {
        case Breaking
        case Score
    }

    static func registerDefaultChannels() {
        let currentInstallation = AVInstallation.current()
        currentInstallation.addUniqueObject(String(describing: Channel.Breaking), forKey: "channels")
        currentInstallation.addUniqueObject(String(describing: Channel.Score), forKey: "channels")
        currentInstallation.saveEventually()
    }
}


// MARK: - Online Parameters

extension LeanCloudAgent {

    enum ParamStatus: String {
        case Disabled = "disabled"
        case Enabled = "enabled"
        case Hidden = "hidden"
    }

    enum OnlineParams: String {
        case ShouldShowCourse
        case ShouldShowExamSchedule
        case ShouldShowExamResult
        case ShouldShowNews
        case ShouldShowRunning
        case CourseSelectionEnabled = "Status.CourseSelection.Enabled"
        case CourseSelectionPremiereDate = "Status.CourseSelection.PremiereDate"
    }

    static func getOnlineParam<T: Parsable>(_ name: OnlineParams) -> T {
        guard let param = AVAnalytics.getConfigParams(name.rawValue) as? String else {
            return T.parse("")
        }
        return T.parse(param)
    }

    static func getOnlineParamDate(_ name: OnlineParams) -> Date {
        guard let param = AVAnalytics.getConfigParams(String(describing: name)) as? String else {
            return Date()
        }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: param) ?? Date()
    }
}

// MARK: - Parsable

protocol Parsable {
    static func parse(_ value: String) -> Self
}

extension LeanCloudAgent.ParamStatus: Parsable {
    static func parse(_ value: String) -> LeanCloudAgent.ParamStatus {
        if let status = LeanCloudAgent.ParamStatus(rawValue: value) {
            return status
        } else {
            return .Hidden
        }
    }
}

extension String: Parsable {
    static func parse(_ value: String) -> String {
        return value
    }
}

extension Bool: Parsable {
    static func parse(_ value: String) -> Bool {
        return value == "true"
    }
}
