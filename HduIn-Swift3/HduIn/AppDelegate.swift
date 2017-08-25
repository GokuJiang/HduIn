//
//  AppDelegate.swift
//  HduIn
//
//  Created by karboom on 15/5/1.
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit
import UserNotifications
import AVOSCloud

let appDelegate = UIApplication.shared.delegate as? AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupLogger()
        SettingsViewController.registerUserDefaults()
        
        LeanCloudAgent.registerService(launchOptions as [NSObject : AnyObject]?)
        LeanCloudAgent.registerPushService(application)
        
        let plist = Plist.sharedInstance
        
        if let isFirst = plist["isFirst"] as? Bool {
            if isFirst {
                plist["isFirst"] = NSNumber(value: false)
                LeanCloudAgent.registerDefaultChannels()
            }
        }
        if AVUser.current() == nil {
            let loginViewController = LoginViewController()
            self.window?.rootViewController = loginViewController
        } else {
            if let notificationPayload =
                launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
                    as?  [AnyHashable : Any] {
                let handled = PushAgent.handleNotification(notificationPayload)
                if !handled {
                    self.window?.rootViewController = MainViewController()
                }
            } else {
                self.window?.rootViewController = MainViewController()
            }
        }
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        #if DEBUG
            let fps = FPSLabel.sharedInstance
            self.window?.addSubview(fps)
            fps.snp.makeConstraints({
                (make) -> Void in
                make.size.equalTo(CGSize(width: 55, height: 20))
                make.left.equalTo(15)
                make.bottom.equalTo(-40)
            })
        #endif
        
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Clear all badge
        let num = application.applicationIconBadgeNumber
        if num != 0 {
            let currentInstallation = AVInstallation.current()
            currentInstallation.badge = 0
            currentInstallation.saveEventually()
            application.applicationIconBadgeNumber = 0
        }
//        UNUserNotificationCenter.removeAllPendingNotificationRequests(application)
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //Register device with APNs token
        AVOSCloud.handleRemoteNotifications(withDeviceToken: deviceToken)

    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        _ = PushAgent.handleForegroundNotification(userInfo)
        if application.applicationState != UIApplicationState.active {
            AVAnalytics.trackAppOpened(withRemoteNotificationPayload: userInfo)
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Failed register at APNS
        log.error("Failed to register for remote notification: \(error.localizedDescription)")
    }

    func resetRootViewController() {
        let mainViewController = MainViewController()
        mainViewController.view.alpha = 0
        self.window?.rootViewController = mainViewController
        UIView.animate(withDuration: 0.25) {
            mainViewController.view.alpha = 1
        }
        #if DEBUG
            let fps = FPSLabel.sharedInstance
            self.window?.bringSubview(toFront: fps)
        #endif
    }
    
}

extension AppDelegate:UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print.debug(response)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        print.debug(notification)
    }
}
