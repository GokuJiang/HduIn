//
//  ExUIView.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/9/24.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit

extension UIView {

    func clearAllSubviews() {
        for item in subviews {
            item.removeFromSuperview()
        }
    }
}
