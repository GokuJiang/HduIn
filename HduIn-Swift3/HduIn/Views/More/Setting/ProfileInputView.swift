//
//  ProfileInputView.swift
//  HduIn
//
//  Created by Lucas Woo on 10/20/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class ProfileInputView: UIView {

    let promptLabel = UILabel()
    let inputField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        self.backgroundColor = UIColor(hex: "f1f2f3")

        promptLabel.textColor = UIColor(hex: "333333")
        promptLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(promptLabel)
        promptLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(10 + 64)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }

        inputField.textColor = UIColor(hex: "333333")
        inputField.font = UIFont.systemFont(ofSize: 16)
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.addSubview(inputField)
        inputField.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(promptLabel.snp.bottom).offset(10)
            make.left.equalTo(promptLabel)
            make.right.equalTo(promptLabel)
            make.height.equalTo(30)
        }

    }

}
