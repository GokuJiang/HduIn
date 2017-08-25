//
//  UserModel.swift
//  HduIn
//
//  Created by Lucas Woo on 1/1/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import ObjectMapper
import AVOSCloud
//import RxCocoa
import Moya
import RxSwift
class UserModel {

    fileprivate static let provider = APIProvider<TokenTarget>()

    fileprivate static let plist = Plist.sharedInstance

    // MARK: User Info
    static var staffId: String {
        get {
            if let staffId = plist["staffId"] as? String {
                return staffId
            } else {
                return ""
            }
        }
        set {
            plist["staffId"] = newValue
        }
    }

    static var staffName: String {
        get {
            if let staffName = plist["staffName"] as? String {
                return staffName
            } else {
                return ""
            }
        }
        set {
            plist["staffName"] = newValue
        }
    }

    static var staffType: StaffType? {
        get {
            guard let staffTypeString = plist["staffType"] as? String else {
                return nil
            }
            return StaffType(rawValue: staffTypeString)
        }
        set {
            if let staffType = newValue {
                plist["staffType"] = staffType.rawValue
            }
        }
    }

    // MARK: Tokens
    static var apiToken: String {
        get {
            if let apiToken = plist["apiToken"] as? String {
                return apiToken
            } else {
                return "0 length string will be treated as null at server"
            }
        }
        set {
            plist["apiToken"] = newValue
            plist["lastUpdate"] = Date()
        }
    }

    static var refreshToken: String {
        get {
            if let refreshToken = plist["refreshToken"] as? String {
                return refreshToken
            } else {
                return ""
            }
        }
        set {
            plist["refreshToken"] = newValue
        }
    }
}

extension UserModel {
    static let timer:TimeInterval = 10

    enum RegisteringStage {
        case fetchingTokenInfo
        case fetchingStaffInfo
        case avLogin
        case installation
    }

    static func installationSavingObservable() -> Observable<Bool> {
        return Observable.create { (observable) -> Disposable in
            let installation = AVInstallation.current()
            installation["staffId"] = UserModel.staffId
            installation.saveInBackground({ (_, error) in
                if let err = error {
                    let code = (err as NSError).code
                    if code == 114 {
                        observable.onNext(true)
                    } else {
                        observable.onError(err)
                    }
                }else{
                    observable.onNext(true)
                }
                observable.onCompleted()
            })
            
            return Disposables.create {
                
            }
        }
    }

    static func registerObservable(_ apiToken: String,  refreshToken: String,stageCallback: ((_ stage: RegisteringStage) -> Void)? = nil) -> Observable<AVUser> {
        log.debug(
            "Prepare to login using apiToken: \(apiToken), refreshToken: \(refreshToken)"
        )
        UserModel.apiToken = apiToken
        UserModel.refreshToken = refreshToken

        stageCallback?(.fetchingTokenInfo)
        return provider.request(.info)
            .mapObject(TokenInfo.self)
            .flatMap { (token) -> Observable<Bool> in
                UserModel.staffId = token.staffId
                UserModel.staffName = token.staffName
                UserModel.staffType = token.staffType

                stageCallback?(.installation)
                return self.installationSavingObservable()
            }.flatMap { _ -> Observable<AVUser> in
                stageCallback?(.avLogin)
                return Observable.create { (observable) -> Disposable in
                    AVUser.logInWithUsername(
                        inBackground: UserModel.staffId,
                        password: UserModel.apiToken
                    ) { avUser, error in
                        if let avUser = avUser {
                            return observable.onNext(avUser)
                        }
                        if let error = error {
                            return observable.onError(error)
                        }
                        observable.onCompleted()
                    }
                    return Disposables.create {
                        
                    }
                }
            }.timeout(timer, scheduler: SerialDispatchQueueScheduler(qos: .background))
    }
}

// MARK: - TokenModel
extension UserModel {
    enum StaffType: String {
        case Bechelor = "Bechelor"
        case Master = "Master"
        case Employee = "Employee"
    }

    struct TokenInfo: Mappable {
        var staffName = ""
        var staffId = ""
        var staffType = StaffType.Bechelor

        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            staffId <- map["staffId"]
            staffName <- map["staffName"]
            var staffTypeString: String = ""
            staffTypeString <- map["staffType"]
            if let staffType = StaffType(rawValue: staffTypeString) {
                self.staffType = staffType
            }
        }
    }
}
