//
//  EXButton.swift
//  HduIn
//
//  Created by Json on 15/7/10.
//  Copyright (c) 2015年 Redhome. All rights reserved.
//

import UIKit

extension UIButton {

    func setImageAndTitleLeft() {
        let SPACING: CGFloat = 6.0
        setImageAndTitleLeft(SPACING)
    }

    // imageView在上,label在下
    func setImageAndTitleLeft(_ spacing: CGFloat) {

        let imageSize = self.imageView?.frame.size
        let titleSize = self.titleLabel?.frame.size

        let totalHeight = imageSize!.height + titleSize!.height + spacing

        self.imageEdgeInsets = UIEdgeInsetsMake(
                -(totalHeight - imageSize!.height),
            0.0,
            0.0,
                -titleSize!.width
        )
        self.titleEdgeInsets = UIEdgeInsetsMake(
            0,
                -imageSize!.width,
                -(totalHeight - titleSize!.height),
            0.0
        )
    }
}
