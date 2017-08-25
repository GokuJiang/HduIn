//
//  SelectionViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupControllers()
    }

    func setupControllers() {
        let viewControllers: [SelectionBaseViewController] = [
            SelectionPEViewController(),
            SelectionPublicViewController(),
            SelectionStarsViewController()
        ]
        let navigationControllers = viewControllers
            .map { (controller) -> UINavigationController in
                controller.delegate = self
                return SelectionNavigationController(rootViewController: controller)
        }

        self.viewControllers = navigationControllers

        self.tabBar.tintColor = UIColor(hex: "3498db")
    }

    func navigateBack(_ sender: UIButton!) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}
