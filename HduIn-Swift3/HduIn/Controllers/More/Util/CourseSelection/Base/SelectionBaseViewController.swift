//
//  SelectionBaseViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import AVOSCloud

class SelectionBaseViewController: UIViewController {

    weak var delegate: SelectionViewController? = nil

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupTabBarItem()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTabBarItem()
    }

    // MARK: ViewLifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AVAnalytics.beginLogPageView("\(type(of: self))")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showBackActionButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AVAnalytics.endLogPageView("\(type(of: self))")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }


    func setupTabBarItem() {
    }

    // MARK: - NavigationBar Button

    func showBackActionButton() {
        guard let btn = Bundle.main.loadNibNamed(
            "NavigationBackButton",
            owner: nil,
            options: nil
        )?[0] as? UIButton else {
            return
        }
        btn.addTarget(delegate,
            action: #selector(SelectionViewController.navigateBack(_:)),
            for: .touchUpInside
        )
        btn.tintColor = UIColor(hex: "3498db")
        btn.setTitleColor(UIColor(hex: "3498db"), for: .normal)
        let barButton = UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = barButton
    }
}
