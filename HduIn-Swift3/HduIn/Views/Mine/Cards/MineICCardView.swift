//
//  MineICCardView.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/10/3.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit

class MineICCardView: MineCardContentView {

    let balance = UILabel()

    let fontSize = 14 as CGFloat
    let balanceSize = 20 as CGFloat

    override func setupView() {
        super.setupView()

        self.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(48)
        }

        let remainingLabel = UILabel()
        let cnyLabel = UILabel()

        self.addSubview(remainingLabel)
        self.addSubview(balance)
        self.addSubview(cnyLabel)

        remainingLabel.font = UIFont.systemFont(ofSize: fontSize)
        remainingLabel.textColor = HIColor.MineCardTextColor
        remainingLabel.text = "mine_label_ic_card_remaining".localized()
        remainingLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(self).offset(42)
            make.bottom.equalTo(self).offset(-18)
            make.top.equalTo(self).offset(14)
        }

        balance.font = UIFont.systemFont(ofSize: balanceSize)
        balance.textAlignment = NSTextAlignment.right
        balance.textColor = HIColor.MineCardTextColor
        balance.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(cnyLabel.snp.leading).offset(-7)
            make.centerY.equalTo(remainingLabel)
        }

        cnyLabel.font = UIFont.systemFont(ofSize: fontSize)
        cnyLabel.textColor = HIColor.MineCardTextColor
        cnyLabel.text = "mine_label_ic_card_cny".localized()
        cnyLabel.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(self).offset(-30)
            make.bottom.equalTo(remainingLabel)
        }
    }

    // MARK:- out use
    func setData(_ val: Double) {
        balance.text = String(val)
        balance.alpha = 0
        UIView.animate(withDuration: 0.18) { () -> Void in
            self.balance.alpha = 1
        }
    }
}
