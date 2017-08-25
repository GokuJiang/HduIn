//
//  HduRadioLargeCell.swift
//  HduIn
//
//  Created by 姜永铭 on 06/12/2016.
//  Copyright © 2016 姜永铭. All rights reserved.
//

import UIKit

class HduRadioLargeCell: UICollectionViewCell {
 
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var bgView = UIView()
    var timesLabel = LabelFactroy.createLabel(fontSize: 9, fontColor: UIColor.white)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        
        self.contentView.insertSubview(imageView, at: 0)
        self.contentView.addSubview(bgView)
        self.bgView.addSubview(titleLabel)
        let iconImageView = UIImageView()
        self.bgView.addSubview(iconImageView)
        self.bgView.addSubview(timesLabel)
        imageView.snp.remakeConstraints({ (make) in
            make.leading.trailing.top.bottom.equalTo(0)
            imageView.contentMode = .scaleToFill
        })
        
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView).offset(16)
            make.height.greaterThanOrEqualTo(19)
            make.bottom.equalTo(-8)
            bgView.backgroundColor = UIColor(hex: "000000").alpha(0.5)
        }
        
        titleLabel.snp.makeConstraints{(make) in
            make.top.leading.equalTo(0)
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textAlignment = .left
            titleLabel.textColor = UIColor.white
        }
        
        iconImageView.snp.makeConstraints{(make) in
            make.bottom.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.height.width.equalTo(8)
            iconImageView.image = UIImage(named: "Radio-Earphone")
        }
        
        timesLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing)
        }
        
    }
    
}
