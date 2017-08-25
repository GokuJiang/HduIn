//
//  Delay.swift
//  HduIn
//
//  Created by Lucas Woo on 3/7/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation

typealias RequestTask = (_ cancel: Bool) -> Void

func delay(_ time:TimeInterval, queue:DispatchQueue = DispatchQueue.main, task:@escaping ()->Void)->RequestTask {
    var closure: (()->Void)? = task
    let result:RequestTask =  { cancel in
        if !cancel {
            queue.async {
                if let closure = closure {
                    closure()
                }
            }
        }
        closure = nil
    }
    
    queue.asyncAfter(deadline: .now() + time, execute: {
        result(false)
    })
    return result
    
}

func cancel(_ task: RequestTask) {
    task(true)
}
