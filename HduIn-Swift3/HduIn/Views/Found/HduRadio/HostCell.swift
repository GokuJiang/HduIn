//
//  HostCell.swift
//  HduIn
//
//  Created by Kevin on 2016/12/1.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit
import AFImageHelper

class HostCell: UICollectionViewCell {

    var imageView = UIImageView()
    var titleLabel = UILabel()
    var bgView = UIView()
    var iconImageView = UIImageView()
    var timesLabel = LabelFactroy.createLabel(fontSize: 9, fontColor: UIColor.white)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        self.contentView.insertSubview(imageView, at: 0)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(bgView)
        self.bgView.addSubview(iconImageView)
        self.bgView.addSubview(timesLabel)

            imageView.snp.remakeConstraints{(make) in
                make.top.equalTo(0)
                make.centerX.equalTo(self.contentView)
                make.height.width.equalTo(self.contentView.snp.width).offset(-10)
            }
            titleLabel.snp.remakeConstraints{(make) in
                make.centerX.equalTo(imageView)
                make.top.equalTo(imageView.snp.bottom).offset(4)
                make.bottom.equalTo(-4)
            }
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView).offset(16)
            make.height.greaterThanOrEqualTo(19)
            make.bottom.equalTo(-8)
            bgView.backgroundColor = UIColor(hex: "000000").alpha(0.5)
        }
        
        iconImageView.snp.makeConstraints{(make) in
            make.bottom.equalTo(imageView).offset(-6)
            make.leading.equalTo(titleLabel.snp.trailing).offset(4)
            make.height.width.equalTo(8)
            iconImageView.image = UIImage(named: "Radio-Earphone")
        }
        timesLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing)
        }


        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
