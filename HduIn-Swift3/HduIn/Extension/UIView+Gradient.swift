//
//  UIView+Gradient.swift
//  HduIn
//
//  Created by 姜永铭 on 11/7/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

//import Foundation
import UIKit

extension UIView {
    func addGradientLayer(_ colors:[UIColor]) {
        let cgColor = colors.map { (color) -> CGColor in
            return color.cgColor
        }
        let layer = CAGradientLayer()
        layer.frame = self.frame
        layer.colors = cgColor
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        layer.locations = [0,1]
        layer.borderWidth = 0
        self.layer.insertSublayer(layer, at: 0)
    }
}
