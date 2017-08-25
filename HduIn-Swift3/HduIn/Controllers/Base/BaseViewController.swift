//
//  BaseViewController.swift
//  HduIn
//
//  Created by Json on 15/7/8.
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit
import AVOSCloud

class BaseViewController: UIViewController {
    
    // MARK: ViewLifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AVAnalytics.beginLogPageView("\(type(of: self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController.
        wireRainbow()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AVAnalytics.endLogPageView("\(type(of: self))")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    // MARK: - NavigationBar Button

    func showBackActionButton(_ action: Selector = #selector(BaseViewController.navigateBack(sender:))) {
        guard let btn = Bundle.main.loadNibNamed(
            "NavigationBackButton",
            owner: nil,
            options: nil
        )?[0] as? UIButton else {
            return
        }
        btn.addTarget(self, action: action, for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = barButton
    }

    // MARK: - Navigation

    func navigateBack(sender: UIButton!) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }

    func popBackToSideMenuViewController(_ sender: UIButton!) {
        appDelegate?.resetRootViewController()
    }

    // MARK: - RainbowNavigation

    lazy var rainbowNavigation = RainbowNavigation()

    func wireRainbow() {
        if let navigationController = navigationController {
            rainbowNavigation.wireTo(navigationController: navigationController)
        }
    }

}

extension BaseViewController: RainbowColorSource {
    func navigationBarInColor() -> UIColor {
        return HIColor.HduInBlue
    }
}
