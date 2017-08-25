//
//  LabelFactroy.swift
//  ModelOnFingerTip-Swift
//
//  Created by 姜永铭 on 11/6/16.
//  Copyright © 2016 姜永铭. All rights reserved.
//

import UIKit

class LabelFactroy: NSObject {

    class func createLabel(fontSize size:CGFloat ,fontColor color:UIColor = UIColor.gray)->UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: size)
        label.textColor = color
        return label
    }
}
