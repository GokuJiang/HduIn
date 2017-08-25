//
//  WechatController.swift
//  HduIn
//
//  Created by Lucas on 10/4/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class WechatController: BaseViewController {

    typealias TargetType = MoreViewController.MenuType

    var target: TargetType = .library {
        didSet {
            fireTarget(target)
        }
    }

    var token: String?
    let webView = WKWebView()
    let provider = APIProvider<TokenTarget>()
    var hud: MBProgressHUD? = nil

    convenience init(target: TargetType) {
        self.init()
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.target = target
        fireTarget(target)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.frame = self.view.frame
        self.view.backgroundColor = UIColor.white
    }

    func fireTarget(_ target: TargetType) {
        self.title = "more_title_\(String(describing: target).lowercased())".localized()
        if let token = self.token {
            requestWeb(token)
        } else {
            _ = provider.request(.wechat)
                .mapSwiftyJSON()
                .map { $0["accessToken"].stringValue }
                .subscribe { (event) -> Void in
                    switch event {
                    case .next(let token):
                        self.requestWeb(token)
                    case .error(let error):
                        self.hud?.detailsLabelText = "读取失败"
                        log.error("Get wechat token failed: \(error)")
                    default:
                        break
                    }
            }
        }
    }

    func requestWeb(_ token: String) {
        var request: URLRequest?
        switch target {
        case .find:
            request = URLRequest(url: URL(string: "http://find.redhome.cc/mobie/index.php?token=true&auth=\(token)")!)
            break
        case .library:
            request = URLRequest(url: URL(string: "http://wechat.redhome.cc/web/library/?token=true&auth=\(token)")!)
            break
        case .repairs:
            request = URLRequest(url: URL(string: "http://wechat.redhome.cc/web/repair/?token=true&auth=\(token)")!)
            break
        default:
            break
        }

        self.hud?.hide(true)
        self.view = webView
        if let request = request {
            webView.load(request)
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
}
