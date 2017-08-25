//
//  MoreViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 3/9/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Static
import AVOSCloud

class MoreViewController: TableViewController {

    var sections: [Section] {
        let avatarSection = Section(
            header: .view(ProfileCell(frame: CGRect(x: 0, y: 0,width: self.view.frame.width, height: 150), selection: selectionHandler(.profile))),
            footer: .view(MoreView.CellSpacingView())
        )

        var utilSection = Section(rows: [
            Row(text: "more_title_library".localized(),
                selection: selectionHandler(.library),
                image: UIImage(named: "More-Library"),
                cellClass: MoreView.CommonCell.self
            )
        ], footer: .view(MoreView.CellSpacingView()))

        let status = LeanCloudAgent
            .getOnlineParam(.CourseSelectionEnabled) as LeanCloudAgent.ParamStatus
        switch status {
        case .Enabled:
            utilSection.rows.append(Row(text: "more_title_course_selection".localized(),
                                        selection: selectionHandler(.courseSelection),
                                        image: UIImage(named: "More-CourseSelection"),
                cellClass: MoreView.CommonCell.self
            ))
        case .Disabled:
            utilSection.rows.append(Row(text: "more_title_course_selection_disabled".localized(),
                image: UIImage(named: "More-CourseSelection"),
                cellClass: MoreView.CommonCell.self
            ))
        case .Hidden:
            break
        }

        let settingsSection = Section(rows: [
            Row(text: "more_title_settings".localized(),
                selection: selectionHandler(.settings),
                image: UIImage(named: "More-Settings"),
                cellClass: MoreView.CommonCell.self
            ),
            Row(text: "more_title_switch_account".localized(),
                selection: selectionHandler(.switchAccount),
                image: UIImage(named: "More-SwitchAccount"),
                cellClass: MoreView.CommonCell.self
            ),
            Row(text: "more_title_feedback".localized(),
                selection: selectionHandler(.feedback),
                image: UIImage(named: "More-Feedback"),
                cellClass: MoreView.CommonCell.self
            ),
            Row(text: "more_title_about".localized(),
                selection: selectionHandler(.about),
                image: UIImage(named: "More-About"),
                cellClass: MoreView.CommonCell.self
            )
        ])

        return [avatarSection, utilSection, settingsSection]
    }

    let moreView = MoreView()

    let rainbowNavigation = RainbowNavigation()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = moreView
        moreView.frame = self.view.frame
        moreView.bounds = self.view.bounds
        self.view = moreView

        dataSource.sections = sections
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wireRainbow()
        AVAnalytics.beginLogPageView("\(type(of: self))")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AVAnalytics.endLogPageView("\(type(of: self))")
    }

}

// MARK: - TabViewController
extension MoreViewController: TabViewController {
    func setupTabInfo() {
        let title = "我的".localized()
        self.title = title

        let tabBarNoamalImage = UIImage(named: "user-grey")?.withRenderingMode(.alwaysOriginal)
        let tabBarSelectedImage:UIImage = #imageLiteral(resourceName: "userblue").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: title, image: tabBarNoamalImage,selectedImage: tabBarSelectedImage)
        self.tabBarItem = tabBarItem
    }
}

// MARK: - Selection Handler
extension MoreViewController {
    enum MenuType {
        case profile

        case library
        case courseSelection
        case repairs
        case find

        case settings
        case feedback
        case switchAccount
        case about
    }

    func selectionHandler(_ type: MenuType) -> () -> Void {
        switch type {
        case .profile:
            return { self.pushViewController( ProfileViewController()) }

        case .library:
            return {
                let controller = LibraryViewController()
                controller.modalTransitionStyle = .crossDissolve
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
                //self.pushViewController( WechatController(target: type))
            }
        case .courseSelection:
            return {
                let controller = SelectionViewController()
                controller.modalTransitionStyle = .crossDissolve
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true, completion: nil)
            }
        case .repairs:
            return { self.pushViewController( WechatController(target: type)) }
        case .find:
            return { self.pushViewController( WechatController(target: type)) }

        case .settings:
            return { self.pushViewController( SettingsViewController()) }
        case .feedback:
            return { self.pushViewController(FeedbackViewController()) }
        case .switchAccount:
            return {
                AVUser.logOut()
                let loginViewController = LoginViewController()
                appDelegate?.window?.rootViewController = loginViewController
            }
        case .about:
            return { self.pushViewController(AboutViewController()) }
        }
    }

    func pushViewController(_ controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - RainbowNavigation
extension MoreViewController: RainbowColorSource {
    func wireRainbow() {
        if let navigationController = navigationController {
            rainbowNavigation.wireTo(navigationController: navigationController)
        }
    }

    func navigationBarInColor() -> UIColor {
        return HIColor.HduInBlue
    }
}
