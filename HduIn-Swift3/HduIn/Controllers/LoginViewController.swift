//
//  LoginViewController.swift
//  HduIn
//
//  Created by Lucas on 15/9/20
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    let loginView = LoginView()

    static var loginViewPresented = false

    override func viewDidLoad() {
        super.viewDidLoad()
        LoginViewController.loginViewPresented = true
        self.title = "登录"

        loginView.delegate = self
        self.view.addSubview(loginView)
        loginView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self.view)
            make.center.equalTo(self.view)
        }
    }

    func didFinishLogin() {
        LoginViewController.loginViewPresented = false
        appDelegate?.resetRootViewController()
    }

    func decode(_ str: String?) -> String {
        guard let str = str else {
            return ""
        }
        guard let int = Int(str, radix: 16) else {
            return ""
        }
        return String(int)
    }
}

// MARK: - LoginView Delegate

extension LoginViewController: LoginViewDelegate {
    
    func loginWithURI(hduinSchemeUri uri: URL) {

        guard let components = URLComponents(url: uri, resolvingAgainstBaseURL: false) else {
            return
        }
        guard let queryItems = components.queryItems else {
            return
        }

        var apiToken = ""
        var refreshToken = ""

        if components.host == "authorize" {
            for item in queryItems {
                if item.name == "token" {
                    apiToken = item.value == nil ? "" : item.value!
                } else if item.name == "refreshToken" {
                    refreshToken = item.value == nil ? "" : item.value!
                }
            }
        }
        
        _ = UserModel.registerObservable(apiToken, refreshToken: refreshToken, stageCallback: loginView.updateStageUI)
            .subscribe({ (event) in
                switch event {
                case .next(_):
                    self.didFinishLogin()
                case .error(let error):
                    log.error("Login failed with error: \(error)")
                    self.loginView.loadCAS()
                default:
                    break
                }
            })

    }
}
