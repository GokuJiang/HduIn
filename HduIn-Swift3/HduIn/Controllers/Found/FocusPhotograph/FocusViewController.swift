//
//  FocusViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class FocusViewController: UITabBarController {
    var backBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let photographerVC = FocusPhotogragherViewController()
        let shareVC = FocusShareViewController()
        let albumVC = FocusAlbumViewController()
        
        let photographerItem = UITabBarItem(title: "摄影师", image: UIImage(named: "camera-gray")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "camera-black")?.withRenderingMode(.alwaysOriginal))
        
        photographerItem.badgeColor = UIColor.gray
        photographerVC.tabBarItem = photographerItem
        
        let shareItem = UITabBarItem(title: "干货分享", image: UIImage(named: "share-gray")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "share-black")?.withRenderingMode(.alwaysOriginal))
        shareVC.tabBarItem = shareItem
        
        let albumItem = UITabBarItem(title: "照片专辑", image: UIImage(named: "picture-gray")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "picture-black")?.withRenderingMode(.alwaysOriginal))
        albumVC.tabBarItem = albumItem
        
        let subViewControllers = [
            albumVC,
            shareVC,
            photographerVC
        ]
        let navigationViewControllers = subViewControllers.map{ subViewController -> UINavigationController in
            subViewController.view.frame = self.view.frame
            subViewController.view.bounds = self.view.bounds
            (subViewController as? TabBarViewController)?.setupTabInfo()
            return UINavigationController(rootViewController:subViewController)
        }
        
        self.viewControllers = navigationViewControllers
        setBackButton()
        // Do any additional setup after loading the view.
    }
    
    func setBackButton(){
        self.view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "TabBar-Back"), for: UIControlState.normal)
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FocusViewController: UITabBarControllerDelegate{
    
}




