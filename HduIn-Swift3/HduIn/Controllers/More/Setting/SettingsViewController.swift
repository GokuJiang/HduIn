//
//  SettingsViewController.swift
//  HduIn
//
//  Created by Lucas on 7/23/15.
//  Copyright (c) 2015 Redhome. All rights reserved.
//

import UIKit
import InAppSettingsKit
import AVOSCloud
class SettingsViewController: IASKAppSettingsViewController {

    typealias Channel = LeanCloudAgent.Channel

    enum SettingKeys {
        case receiveNewsPush
        case receiveScorePush
        case showScoreDirectly

        static let AllValue: [SettingKeys] = [
                .receiveNewsPush,
                .receiveScorePush,
                .showScoreDirectly
        ]
    }

    // MARK: Properties
    var receiveNewsPush: Bool = true
    var receiveScorePush: Bool = true
    var showScoreDirectly: Bool = true

    var _hiddenKeys = Set<String>()

    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "more_title_settings".localized()
        self.navigationController!.navigationBar.tintColor = UIColor.white

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(SettingsViewController.defaultsDidChanged(notification:)),
            name: NSNotification.Name(rawValue: kIASKAppSettingChanged),
            object: nil
        )

        let defaults = UserDefaults.standard
        receiveNewsPush = defaults.bool(forKey: String(describing: SettingKeys.receiveNewsPush))
        receiveScorePush = defaults.bool(forKey: String(describing: SettingKeys.receiveScorePush))
        showScoreDirectly = defaults.bool(forKey: String(describing: SettingKeys.showScoreDirectly))

        setupView()

        self.showCreditsFooter = false
    }

    override func viewWillAppear(_ animated: Bool) {
        self.showDoneButton = false
        super.viewWillAppear(animated)
        AVAnalytics.beginLogPageView("\(type(of: self))")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AVAnalytics.endLogPageView("\(type(of: self))")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SettingsViewController.registerChannels()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Methods

    func setupView() {
        if !receiveScorePush {
            _hiddenKeys.insert(String(describing: SettingKeys.showScoreDirectly))
            setHiddenKeys(_hiddenKeys, animated: false)
        }
    }

    func defaultsDidChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            for item in SettingKeys.AllValue {
                if let value = userInfo[String(describing: item)] as? NSNumber {
                    switch item {
                    case .receiveNewsPush:
                        receiveNewsPush = Bool(value)
                        log.verbose(
                            "User Defaults ReceiveNewsPush changed to: \(self.receiveNewsPush)"
                        )
                        break
                    case .receiveScorePush:
                        receiveScorePush = Bool(value)
                        log.verbose(
                            "User Defaults ReceiveScorePush changed to: \(self.receiveScorePush)"
                        )
                        if receiveScorePush {
                            _hiddenKeys.remove(String(describing: SettingKeys.showScoreDirectly))
                            setHiddenKeys(_hiddenKeys, animated: true)
                        } else {
                            _hiddenKeys.insert(String(describing: SettingKeys.showScoreDirectly))
                            setHiddenKeys(_hiddenKeys, animated: true)
                        }
                        break
                    case .showScoreDirectly:
                        showScoreDirectly = Bool(value)
                        log.verbose(
                            "User Defaults ShowScoreDirectly changed to: \(self.showScoreDirectly)"
                        )
                        break
                    }
                }
            }
        }
    }

    // MARK: Class Methods
    class func registerUserDefaults() {
        let appDefaultsKeys: [SettingKeys] = [
                .receiveNewsPush,
                .receiveScorePush,
                .showScoreDirectly
        ]
        var appDefaults = [String: Any]()
        for item in appDefaultsKeys {
            appDefaults[String(describing: item)] = true
        }
        UserDefaults.standard.register(defaults: appDefaults)
    }

    class func registerChannels() {
        let defaults = UserDefaults.standard
        let receiveNewsPush = defaults.bool(forKey: String(describing: SettingKeys.receiveNewsPush))
        let receiveScorePush = defaults.bool(forKey: String(describing: SettingKeys.receiveScorePush))

        let currentInstallation = AVInstallation.current()

        if receiveNewsPush {
            currentInstallation.addUniqueObject(String(describing: Channel.Breaking), forKey: "channels")
        } else {
            currentInstallation.remove(String(describing: Channel.Breaking), forKey: "channels")
        }

        if receiveScorePush {
            currentInstallation.addUniqueObject(String(describing: Channel.Score), forKey: "channels")
        } else {
            currentInstallation.remove(String(describing: Channel.Score), forKey: "channels")
        }

        currentInstallation.saveEventually()
    }
}
