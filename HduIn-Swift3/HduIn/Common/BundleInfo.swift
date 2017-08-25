//
//  BundleInfo.swift
//  HduIn
//
//  Created by Lucas Woo on 3/1/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation

struct BundleInfo {
    static let Identifier = Bundle.main
        .infoDictionary!["CFBundleIdentifier"] as? String

    static let Version = Bundle.main
        .infoDictionary!["CFBundleVersion"] as? String

    static let ShortVersion = Bundle.main
        .infoDictionary!["CFBundleShortVersionString"] as? String
}
