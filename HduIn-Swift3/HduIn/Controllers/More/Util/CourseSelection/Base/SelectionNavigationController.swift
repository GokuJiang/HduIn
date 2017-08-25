//
//  SelectionNavigationController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionNavigationController: UINavigationController {

    // MARK: LifeCycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = UIColor(hex: "3498db")
        self.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor(hex: "3498db"),
            NSFontAttributeName: UIFont.systemFont(ofSize: 17)
        ]
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}
