//
//  AboutViewController.swift
//  HduIn
//
//  Created by Json on 15/7/2.
//  Amended by Lucas on 15/7/15
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    enum AboutEnum: String {
        case Developers = "开发者"
        case Rating = "去评分"
    }

    let labelArray: [AboutEnum] = [.Developers, .Rating]
    var aboutTable: UITableView!

    // MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "more_title_about".localized()

        self.view = {
            let aboutView = AboutView(frame: self.view.frame)
            aboutView.delegate = self
            aboutView.dataSource = self
            aboutTable = aboutView.aboutTable
            return aboutView
        }()
    }
}

// MARK: - AboutView Delegate

extension AboutViewController: AboutViewDelegate {
    func aboutView(_ aboutView: AboutView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch labelArray[indexPath.row] {
        case .Developers:
            let view = DevelopersView()
            let viewController = UIViewController()
            viewController.view = view
            viewController.title = "开发者"
            self.navigationController?.pushViewController(viewController, animated: true)
        case .Rating:
            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1038880945")!, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - AboutView DataSource

extension AboutViewController: AboutViewDataSource {
    func aboutView(_ aboutView: AboutView, numberOfItemsInTableView tableView: UITableView) -> Int {
        return labelArray.count
    }

    func aboutView(_ aboutView: AboutView, itemAtIndexPath indexPath: IndexPath) -> String {
        return labelArray[indexPath.item].rawValue
    }
}
