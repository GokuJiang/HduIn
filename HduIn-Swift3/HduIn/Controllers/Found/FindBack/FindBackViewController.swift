//
//  FindBackViewController.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/19.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class FindBackViewController: UITabBarController {

    var backBtn = UIButton()
    var buttonView = UIView()
    var postButton = UIButton()
    
    override func viewDidLoad() {
        self.initViewControllers()
        super.viewDidLoad()
        self.delegate = self
        self.view.backgroundColor = UIColor.white
        self.tabBar.barTintColor = UIColor.white
        setPostButton()
        setBackButton()
    }
    
    func initViewControllers() {
        let subViewControllers = [
            FindInfoViewController(),
            UIViewController(),
            LostInfoViewController()
        ]
        
        let navigationViewControllers = subViewControllers.map {
            subViewController -> UINavigationController in
            subViewController.view.frame = self.view.frame
            subViewController.view.bounds = self.view.bounds
            (subViewController as? TabViewController)?.setupTabInfo()
            return UINavigationController(rootViewController: subViewController)
        }
        self.viewControllers = navigationViewControllers
    }
    
    func setBackButton(){
        self.view.addSubview(backBtn)
        backBtn.setImage(#imageLiteral(resourceName: "Back-LostFound"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(self.navigateBack), for: UIControlEvents.touchUpInside)
        self.backBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.leading.equalTo(16)
            make.top.equalTo(32)
        }
    }

    func navigateBack(sender:UIButton) {
        //        let transition = CATransition()
        //        transition.duration = 0.25
        //        transition.type = kCATransitionFade
        //        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true) {
            
        }
    }

    
    func setPostButton(){
        self.view.addSubview(buttonView)
        self.view.addSubview(postButton)
        self.buttonView.addSubview(postButton)
        self.buttonView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(0)
            make.height.width.equalTo(62)
            buttonView.backgroundColor = UIColor.white
            buttonView.layer.cornerRadius = 62/2
            buttonView.layer.masksToBounds = true
        }
        self.postButton.snp.makeConstraints { (make) in
            make.center.equalTo(self.buttonView)
            make.width.height.equalTo(56)
            postButton.backgroundColor = HIColor.hduGreenBlue
            postButton.layer.cornerRadius = 56/2
            postButton.layer.masksToBounds = true
            postButton.setTitle("+", for: .normal)
            postButton.setTitleColor(UIColor.white, for: .normal)
            postButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            postButton.titleLabel?.textAlignment = .center
            postButton.addTarget(self, action: #selector(self.postItem), for: .touchUpInside)
        }
    }
    
    func postItem(){
        self.present(UINavigationController(rootViewController:PostViewController()), animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension FindBackViewController: UITabBarControllerDelegate {
    
}
