//
//  HduInButton.swift
//  HduIn
//
//  Created by Json on 15/9/24.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit

class HduInButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
}
