//
//  APITarget.swift
//  HduIn
//
//  Created by Lucas Woo on 2/29/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation
import Moya

enum APIAuthType {
    case None
    case Default
}

protocol APITarget: TargetType {
    var acceptVersion: String { get }
    var auth: APIAuthType { get }
}
