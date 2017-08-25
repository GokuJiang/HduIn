//
//  MainViewController.swift
//  HduIn
//
//  Created by Json on 15/7/2.
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        self.initViewControllers()
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.tintColor = HIColor.hduTabbarBlue
    }

    func initViewControllers() {
        let subViewControllers = [
            FoundViewController(),
            MineViewController(),
            FunctionViewController(),
            MoreViewController()
        ]

        let navigationViewControllers = subViewControllers.map {
            subViewController -> UINavigationController in
            subViewController.view.frame = self.view.frame
            subViewController.view.bounds = self.view.bounds
            (subViewController as? TabViewController)?.setupTabInfo()
            if subViewController is FunctionViewController{
                let vc = UINavigationController(rootViewController: subViewController)
                vc.navigationBar.tintColor = UIColor(hex: "5a5a5a")
                let shdowPath = UIBezierPath(roundedRect: vc.navigationBar.frame, cornerRadius: 0).cgPath
                vc.navigationBar.layer.shadowPath = shdowPath

                vc.navigationBar.layer.shadowColor = UIColor(hex: "2b2b2").alpha(0.5).cgColor
                vc.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
                vc.navigationBar.layer.shadowOpacity = 0.5
                vc.navigationBar.barTintColor = UIColor(hex: "ffffff")
                return vc
            }
            return BaseNavigationController(rootViewController: subViewController)
        }

        self.viewControllers = navigationViewControllers
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension MainViewController: UITabBarControllerDelegate {
    
}
