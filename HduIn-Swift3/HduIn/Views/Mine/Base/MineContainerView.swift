//
//  MineContainerView.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/9/24.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit
//import TZStackView

class MineContainerView: UIScrollView {

    // MARK: properties
    static let horizonMargin = 8
    static let verticalMargin = 12

    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {

        self.backgroundColor = HIColor.HduInBlue
        self.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.backgroundColor = UIColor.clear
        self.addSubview(stackView)

        stackView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self)
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
    }
}
