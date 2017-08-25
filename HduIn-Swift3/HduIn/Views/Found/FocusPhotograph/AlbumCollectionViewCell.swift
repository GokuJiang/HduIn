//
//  AlbumCollectionViewCell.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class AlbumCollectionViewCell: UITableViewCell {
    
    var photoImageView = UIImageView()
    
    var titleLable = UILabel()
    
    var numberOfPictureLable = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(){
        
        let lineView = UIView()
        
        lineView.backgroundColor = UIColor.red
        self.numberOfPictureLable.backgroundColor = HIColor.hduBlackThree
        self.photoImageView.backgroundColor = HIColor.hduSoftBlue
        self.numberOfPictureLable.textColor = UIColor.white
        
        numberOfPictureLable.font = UIFont.boldSystemFont(ofSize: 9)
        self.titleLable.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.addSubview(lineView)
        self.addSubview(self.photoImageView)
        self.addSubview(self.titleLable)
        self.addSubview(self.numberOfPictureLable)
        
        self.numberOfPictureLable.layer.cornerRadius = 7.5
        self.numberOfPictureLable.layer.masksToBounds = true
        
        self.photoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.height.equalTo(180)
        }
        
        self.titleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(lineView.snp.trailing).offset(8)
            make.bottom.equalTo(lineView.snp.bottom)
            make.height.greaterThanOrEqualTo(10)
            titleLable.font = UIFont.systemFont(ofSize: 16)
        }
        
        self.numberOfPictureLable.snp.makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(27)
            make.height.equalTo(15)
            make.bottom.equalTo(self.photoImageView.snp.bottom).offset(-17)
            make.trailing.equalTo(self.photoImageView.snp.trailing).offset(-17)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(photoImageView)
            make.top.equalTo(self.photoImageView.snp.bottom).offset(8)
            make.height.equalTo(titleLable)
            make.width.equalTo(2)
        }
    }
    
}
