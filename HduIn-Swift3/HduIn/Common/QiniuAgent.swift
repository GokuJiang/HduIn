//
//  QiniuAgent.swift
//  HduIn
//
//  Created by Goku on 18/05/2017.
//  Copyright © 2017 姜永铭. All rights reserved.
//

import UIKit
import Qiniu


class QiniuAgent {
    
    static let shareInstance = QiniuAgent()
    let upManager  = QNUploadManager()
    var provider = APIProvider<QiniuTarget>()

    fileprivate init () {}
    
    func uploadDataToQiniu(imageData data:Data,  type:String, handler: @escaping QNUpCompletionHandler) {
        _ = provider.request(QiniuTarget.getToken)
            .mapObject(FindBack.postData.self)
            .subscribe{ (event)-> Void in
                switch event {
                case .next(let response):
                    guard let token  = response.token else {
                        return
                    }
                    self.upManager?.put(data, key: nil, token: token, complete: handler, option: nil)
                case .error( _):
                    break
                default:
                    break
                }
                
            }
    }
    
}
