//
//  PushAgent.swift
//  Hduin
//
//  Created by Lucas on 9/10/15.
//  Copyright (c) 2015 Redhome. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class PushAgent {

    // TODO: Compatibility Types, remove if necessary

    enum PushType: String {
        case Breaking = "Breaking"
        case Bulletin = "Bulletin"
        case Score = "Score"
    }

    enum PushAction: String {
        case Breaking = "cc.redhome.hduin.news.push"
        case Bulletin = "cc.redhome.hduin.notification.push"
        case Score = "cc.redhome.hduin.score.push"
    }

    class func transformOptions(_ options:  [AnyHashable : Any]) ->  [AnyHashable : Any] {
        var mutableCopy = options
        
        if let type = mutableCopy["type"] as? String {
            if let pushType = PushType(rawValue: type) {
                switch pushType {
                case .Breaking:
                    mutableCopy["action"] = PushAction.Breaking.rawValue
                case .Bulletin:
                    mutableCopy["action"] = PushAction.Bulletin.rawValue
                case .Score:
                    mutableCopy["action"] = PushAction.Score.rawValue
                }
            }
        }
        return mutableCopy
    }

    class func handleNotification(_ options:  [AnyHashable : Any]) -> Bool {
        log.info("Will handle notification: \(options)")
        let options = transformOptions(options)

        guard let action = options["action"] as? String else {
            return false
        }
        guard let pushAction = PushAction(rawValue: action) else {
            return false
        }
        switch pushAction {
        case .Breaking:
            appDelegate?.window?.rootViewController = MainViewController()
        case .Bulletin:
            break
        case .Score:
            appDelegate?.window?.rootViewController = MainViewController()
        }
        return true
    }

    class func handleForegroundNotification(_ userInfo:  [AnyHashable : Any]) -> Bool {
        log.info("Will handle foreground notification: \(userInfo)")

        let userInfo = transformOptions(userInfo)

        guard let action = userInfo["action"] as? String else {
            return false
        }
        guard let pushAction = PushAction(rawValue: action) else {
            return false
        }
        switch pushAction {
        case .Breaking:
            break
        case .Bulletin:
            break
        case .Score:
            let defaults = UserDefaults.standard
            let showScoreDirectly = defaults.bool(
                forKey: String(describing: SettingsViewController.SettingKeys.showScoreDirectly)
            )

            let score = userInfo["score"] as? String
            let courseName = userInfo["courseName"] as? String
            var message = ""
            if showScoreDirectly && score != nil && courseName != nil {
                message = "\(courseName!)成绩为\(score!)"
            } else {
                message = "你有一门新成绩出炉"
            }

            let content = UNMutableNotificationContent()
            content.body = message
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            // 发送请求标识符
            let requestIdentifier = "xyz.hduin.usernotification.myFirstNotification"
            // 创建一个发送请求
            let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
            // 将请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in
                if error == nil {
                    print.debug("Time Interval Notification scheduled: \(requestIdentifier)")
                }
            }

            
//            let localNotification = UILocalNotification()
//            localNotification.fireDate = Date()
//            localNotification.timeZone = NSTimeZone.default
//            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
        return true
    }
}
