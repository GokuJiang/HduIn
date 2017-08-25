//
//  LibraryViewController.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/14.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class LibraryViewController: UITabBarController {
    var backBtn = UIButton()
    var searchBtn = UIButton()
    let rainbowNavigation = RainbowNavigation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tabBar.tintColor = UIColor(hex: "46aee8")
        wireRainbow()
        initViewControllers()
        setSearchButton()
    }

    
    func initViewControllers() {
        let subViewControllers = [
            BorrowViewController(),
            BookViewController(),
            BrowseViewController()
        ]
        
        let navigationViewControllers = subViewControllers.map {
            subViewController -> UINavigationController in
            subViewController.view.frame = self.view.frame
            subViewController.view.bounds = self.view.bounds
            (subViewController as? TabViewController)?.setupTabInfo()
            return BaseNavigationController(rootViewController: subViewController)
        }
        self.viewControllers = navigationViewControllers
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setBackButton(){
        self.view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "libraryback"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(self.navigateBack), for: UIControlEvents.touchUpInside)
        self.backBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 18, height: 25))
            make.leading.equalTo(16)
            make.top.equalTo(30)
        }
    }
    
    func setSearchButton(){
        self.view.addSubview(searchBtn)
        searchBtn.setImage(UIImage(named: "library_whitesearch"), for: UIControlState.normal)
        searchBtn.addTarget(self, action: #selector(self.search), for: UIControlEvents.touchUpInside)
        self.searchBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.trailing.equalTo(-16)
            make.top.equalTo(32)
        }
    }
    
    func navigateBack(sender:UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    func search(){
        let vc = SearchViewController()
        self.present(vc, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK: - RainbowNavigation
extension LibraryViewController: RainbowColorSource {
    func wireRainbow() {
        if let navigationController = navigationController {
            rainbowNavigation.wireTo(navigationController: navigationController)
        }
    }
    
    func navigationBarInColor() -> UIColor {
        return HIColor.HduInBlue
    }
}

extension LibraryViewController: UITabBarControllerDelegate{
    
}
