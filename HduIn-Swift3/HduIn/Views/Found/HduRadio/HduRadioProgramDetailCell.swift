//
//  HduRadioProgramCell.swift
//  HduIn
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class HduRadioProgramDetailCell: UITableViewCell {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var titleLable = UILabel()
    var timeLable = UILabel()
    var issueLable = UILabel()
    var dateLable = UILabel()
    var pageViewLable = UILabel()
    var playImage = UIImageView()
    
    var lineView = UIView()
    
    required init?(coder eDecode: NSCoder) {
        super.init(coder: eDecode)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier:reuseIdentifier)
        
        self.contentView.addSubview(self.titleLable)
        self.contentView.addSubview(self.timeLable)
        self.contentView.addSubview(self.issueLable)
        self.contentView.addSubview(self.dateLable)
        self.contentView.addSubview(self.pageViewLable)
        self.contentView.addSubview(self.playImage)
        self.contentView.addSubview(self.lineView)
        
        
        self.playImage.image = UIImage(named: "Radio-GrayPlay")
        
        
        
        self.timeLable.font = UIFont.boldSystemFont(ofSize: 10)
        self.issueLable.font = UIFont.boldSystemFont(ofSize: 14)
        self.dateLable.font = UIFont.boldSystemFont(ofSize: 10)
        self.pageViewLable.font = UIFont.boldSystemFont(ofSize: 10)
        
        //set color
        self.dateLable.textColor = UIColor(white: 0 / 255.0, alpha: 0.6)
        self.titleLable.textColor = UIColor(white: 0 / 255.0, alpha: 0.88)
        self.pageViewLable.textColor = UIColor(white: 0 / 255.0, alpha: 0.6)
        self.timeLable.textColor = UIColor(white: 0 / 255.0, alpha: 0.6)
        self.issueLable.textColor = UIColor(white: 0 / 255.0, alpha: 0.6)
        self.lineView.backgroundColor = UIColor(white: 0.0, alpha: 0.26)
        
        //layout
        self.playImage.snp.makeConstraints { (make) in
            make.leading.equalTo(self.dateLable.snp.trailing).offset(3)
            make.centerY.equalTo(self.dateLable)
            make.width.height.equalTo(10)
        }
        
        self.titleLable.snp.makeConstraints({(make) in
            make.leading.equalTo(issueLable.snp.trailing).offset(8)
            make.top.equalTo(16)
        })
        
        self.timeLable.snp.makeConstraints({(make) in
            make.leading.equalTo(331)
            make.trailing.equalTo(-10)
            make.top.equalTo(22)
            make.height.equalTo(23.5)
        })
        
        self.issueLable.snp.makeConstraints({(make) in
            make.leading.top.equalTo(16)
        })
        
        self.dateLable.snp.makeConstraints({(make) in
            make.leading.equalTo(self.titleLable)
            make.top.equalTo(self.titleLable.snp.bottom).offset(6)
        })
        
        self.pageViewLable.snp.makeConstraints({(make) in
            make.leading.equalTo(playImage.snp.trailing).offset(6)
            make.centerY.equalTo(dateLable)
            //            make.height.equalTo(10.5)
        })
        
        self.lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(50)
            make.trailing.equalTo(20)
            make.bottom.equalTo(2)
            make.top.equalTo(64)
        }
        
    }


}
