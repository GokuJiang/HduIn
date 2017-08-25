//
//  Networking.swift
//  HduIn
//
//  Created by Lucas Woo on 2/28/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import AVOSCloud

struct Networking {

    enum Base: String {
        case HduAPI = "https://api.hdu.edu.cn/"
        case HduIn = "https://hduin.hdu.edu.cn/"
        //case HduIn = "http://3404fd20.redhome.cc"
        case Leanapp = "https://hduin.leanapp.cn/"

        case News = "http://redstone.redhome.cc"
        case Flarum = "http://flarum.redhome.cc"
        
        case Test = "http://115.28.92.130:1337"
    }

    static let allBases: [Base] = [.HduIn, .HduAPI, .Leanapp]
    static let productionBases: [Base] = [.HduIn, .HduAPI, .Leanapp]

    static var baseURL: URL { return URL(string: Base.HduIn.rawValue)! }
    static var hduapiURL: URL { return URL(string: Base.HduAPI.rawValue)! }
    static var  hudinTestURL:URL {return URL(string: Base.Test.rawValue)!}
    static var loginURL: URL {
        return URL(string: "/auth/hduapi", relativeTo: Networking.baseURL)!
    }

}

// MARK: - Token
extension Networking {

    fileprivate static let tokenRefreshingBehaviorField = BehaviorSubject(value: false)
    static var tokenRefreshingBehavior: BehaviorSubject<Bool> {
        do {
            if try !tokenRefreshingBehaviorField.value() {
                // Not refreshing
                if let lastUpdate = Plist.sharedInstance["lastUpdate"] as? Date {
                    if Date().daysAfterDate(date: lastUpdate) > 7 {
                        //refreshToken()
//TODO refershToken
                    }
                } else {
                    //refreshToken()
                }
            }
        } catch {
            log.error("get tokenRefreshingBehavior value failed: \(error)")
        }
        return tokenRefreshingBehaviorField
    }

    fileprivate static var provider = RxMoyaProvider<TokenTarget>(
        endpointClosure: APIProvider.APIEndpointMapping,
        plugins: [APINetworkActivityPlugin()]
    )

    static func refreshToken() {
        tokenRefreshingBehaviorField.onNext(true)
        _ = provider.request(.refresh).mapSwiftyJSON().subscribe { (event) -> Void in
            switch event {
            case .next(let json):
                if let apiToken = json["token"].string, let refreshToken = json["refreshToken"].string {
                    UserModel.apiToken = apiToken
                    UserModel.refreshToken = refreshToken
                } else {
                    log.warning("Refresh action did not get expected token or refreshToken")
                }
            case .error(let error):
                log.error("Refresh token failed with error: \(error)")
                tokenRefreshingBehavior.onError(error)
            default:
                tokenRefreshingBehavior.onNext(false)
            }
        }
    }
}

// MARK: - Invalid Token
extension Networking {

    fileprivate static var invalidTokenAlertControllerPresenting = false

    static func showLoginViewController() {
        AVUser.logOut()
        if !LoginViewController.loginViewPresented {
            let loginController = LoginViewController()
            UIView.animate(withDuration: 0.25, animations: {
                appDelegate?.window?.rootViewController?.view.alpha = 0
            }) { _ in
                appDelegate?.window?.rootViewController = loginController
            }
        }
    }

    fileprivate static var invalidTokenAlertController: UIAlertController {
        let alertController = UIAlertController(
            title: "title_invalid_token".localized(),
            message: "message_invalid_token".localized(),
            preferredStyle: .alert
        )

        let passwordAction = UIAlertAction(
            title: "action_change_password".localized(),
            style: .default
        ) { _ in
            UIApplication.shared.open(URL(string: "http://pwd.hdu.edu.cn/")!, options: [:], completionHandler: nil)
//            UIApplication.shared.openURL(NSURL(string: "http://pwd.hdu.edu.cn/")!)
            Networking.invalidTokenAlertControllerPresenting = false
        }

        let reloginAction = UIAlertAction(
            title: "action_relogin".localized(),
            style: .default
        ) { _ in
            Networking.showLoginViewController()
            Networking.invalidTokenAlertControllerPresenting = false
        }

        alertController.addAction(passwordAction)
        alertController.addAction(reloginAction)

        return alertController
    }

    static func presentInvalidTokenAlertController() {
        if !invalidTokenAlertControllerPresenting && !LoginViewController.loginViewPresented {
            invalidTokenAlertControllerPresenting = true
            appDelegate?.window?.rootViewController?.present(
                Networking.invalidTokenAlertController,
                animated: true,
                completion: nil
            )
        }
    }
}
