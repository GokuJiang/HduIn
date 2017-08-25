//
//  LoginView.swift
//  HduIn
//
//  Created by karboom on 15/5/10.
//  Amended by Lucas on 15/7/20
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class LoginView: UIView {

    var delegate: LoginViewDelegate!
    let webView = WKWebView()
    var hud: MBProgressHUD? = nil

    var requestingCAS = true

    // MARK: LifeCycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        webView.frame = self.bounds
        webView.navigationDelegate = self
        self.addSubview(webView)
        webView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }

        loadCAS()
    }

    func loadCAS() {
        webView.load(URLRequest(url: Networking.loginURL))
        startLoading()
    }

    func startLoading() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25, animations: { 
                self.webView.alpha = 0
            })
            if let hud = self.hud {
                hud.show(true)
            }else {
                self.hud = MBProgressHUD.showAdded(to: self, animated: true)
            }
        }
    }

    func endLoading() {
        DispatchQueue.main.async {
            self.hud?.hide(true)
            self.hud = nil
            UIView.animate(withDuration: 0.25, animations: { 
                self.webView.alpha = 1
            })
        }
    }

    func updateStageUI(_ stage: UserModel.RegisteringStage) {
        
        DispatchQueue.main.async {
            switch stage {
            case .fetchingTokenInfo:
                self.hud?.labelText = "正在组装飞行器"
            case .fetchingStaffInfo:
                self.hud?.labelText = "正在检查飞行器"
            case .installation:
                self.hud?.labelText = "正在载入软体"
            case .avLogin:
                self.hud?.labelText = "正在准备起飞"
            }

        }

    }

    var timeoutValidator = 0
    
    func startTimer() {
        timeoutValidator = timeoutValidator + 1

//        timeoutValidator = timeoutValidator.successor()
        let ticket = timeoutValidator

        _ = delay(15) { () -> Void in
            if ticket == self.timeoutValidator {
                self.webView.reload()
                log.info("reloading webview")
                self.startTimer()
            }
        }
    }
}

// MARK: - WKNavigationDelegate

extension LoginView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        log.debug("login view commit navigation")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startTimer()
        log.debug("login view did start provisional navigation")
        startLoading()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        timeoutValidator = timeoutValidator.successor()
        timeoutValidator = timeoutValidator + 1
        if requestingCAS {
            log.info("login view finished navigation to CAS")
            self.endLoading()
        } else {
            log.info("login view finished navigation")
        }
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        let url = navigationAction.request.url!
        log.debug("login view deciding wether to navigate to \(url)")

        requestingCAS = false

        if url.scheme == "hduin" {
            delegate.loginWithURI(hduinSchemeUri: url)
            webView.stopLoading()
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }

        if let host = url.host {
            if host.hasSuffix("hdu.edu.cn") {
                requestingCAS = true
                decisionHandler(.allow)
                hud?.labelText = "正在加载"
                return
            }
        }

        if (Networking.allBases.contains { URL(string: $0.rawValue)!.host == url.host }) {
            decisionHandler(.allow)
            hud?.labelText = "正在读取"
            return
        }

        decisionHandler(.cancel)
        webView.load(URLRequest(url: Networking.loginURL))
    }

    func webView(_ webView: WKWebView,didFail navigation: WKNavigation!,withError error: Error) {
        log.debug("login view failed navigation")
        webView.load(URLRequest(url: Networking.loginURL))
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        log.debug("login view failed provisional navigation")
    }
}

// MARK: - Protocol LoginView Delegate

protocol LoginViewDelegate {
    func loginWithURI(hduinSchemeUri uri: URL)
}
