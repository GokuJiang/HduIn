//
//  PhotographerCollectionViewCell.swift
//  HduIn
//
//  Created by Kevin on 2016/12/15.
//  Copyright © 2016年 姜永铭. All rights reserved.
//
import UIKit
let PhotographerCollectionViewCellIdentify = "PhotographerCollectionViewCell"
class PhotographerCollectionViewCell: UICollectionViewCell {
    var imageView = UIImageView()
    var titleLabel = UILabel()
    var bgView = UIView()
    var iconImageView = UIImageView()
    var likeLabel = LabelFactroy.createLabel(fontSize: 10, fontColor: UIColor.white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        self.contentView.insertSubview(imageView, at: 0)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(bgView)
        self.bgView.addSubview(iconImageView)
        self.bgView.addSubview(likeLabel)
        
        imageView.snp.remakeConstraints{(make) in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.size.equalTo(self.contentView)
        }
        titleLabel.snp.remakeConstraints{(make) in
            make.leading.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.bottom.equalTo(-4)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textAlignment = .left
        
        bgView.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.contentView)
            make.height.greaterThanOrEqualTo(19)
            make.width.greaterThanOrEqualTo(28)
            make.bottom.equalTo(0)
            bgView.backgroundColor = UIColor(hex: "000000").alpha(0.5)
        }
        
        iconImageView.snp.makeConstraints{(make) in
            make.bottom.equalTo(bgView)
            make.leading.equalTo(bgView.snp.leading).offset(4)
            make.height.width.equalTo(10)
            iconImageView.image = UIImage(named: "Like")
        }
        likeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImageView).offset(1)
            make.leading.equalTo(iconImageView.snp.trailing)
        }
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
