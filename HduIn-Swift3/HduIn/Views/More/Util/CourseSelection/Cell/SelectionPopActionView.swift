//
//  SelectionPopActionView.swift
//  HduIn
//
//  Created by Lucas Woo on 12/8/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionPopActionView: UIView {


    var stared = false {
        didSet {
            if stared {
                starButton.setTitle("取消收藏", for: UIControlState())
            } else {
                starButton.setTitle("收藏", for: UIControlState())
            }
        }
    }

    let detailsButton = UIButton()
    let starButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        self.backgroundColor = UIColor.clear

        let textFont = UIFont.systemFont(ofSize: 12)
        let tintColor = UIColor(hex: "3498db")

        let seperator = UIView()
        seperator.backgroundColor = UIColor(hex: "dcdcdc")
        self.addSubview(seperator)
        seperator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.height.equalTo(1)
            make.center.equalTo(self)
        }

        detailsButton.setTitle("课程详情", for: UIControlState())
        detailsButton.tintColor = tintColor
        detailsButton.titleLabel?.font = textFont
        detailsButton.setTitleColor(tintColor, for: UIControlState())
        self.addSubview(detailsButton)
        detailsButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.bottom.equalTo(seperator.snp.top)
        }

        starButton.setImage(UIImage(named: "Selection-Star"), for: UIControlState())
        starButton.setTitle("收藏", for: UIControlState())
        starButton.titleLabel?.font = textFont
        starButton.tintColor = tintColor
        starButton.setTitleColor(tintColor, for: UIControlState())
        self.addSubview(starButton)
        starButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(seperator.snp.bottom).offset(5)
        }
    }

}
