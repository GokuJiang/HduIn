//
//  FocusShareTableViewCell.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class FocusShareTableViewCell: UITableViewCell {
    
//    var titleLable = UILabel()
    var introductionLable = UILabel()
    var summmaryLable = UILabel()
    var backgroudView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp() {
        let enterButton = UIImageView()
//        let topLineView = UIView()
//        let bottomLineView = UIView()
        
        //add
        self.contentView.addSubview(backgroudView)
        self.contentView.addSubview(enterButton)
//        self.contentView.addSubview(self.titleLable)
        self.contentView.addSubview(self.introductionLable)
        self.contentView.addSubview(self.summmaryLable)
//        self.contentView.addSubview(topLineView)
//        self.contentView.addSubview(bottomLineView)
        
        
        //set color
//        self.titleLable.textColor = UIColor.white
//        topLineView.backgroundColor = UIColor.white
//        bottomLineView.backgroundColor = UIColor.white
        self.backgroudView.backgroundColor = HIColor.hduSoftBlue
        self.introductionLable.textColor = HIColor.hduBlack60
        self.summmaryLable.textColor = HIColor.hduBlack20
        
        //set size
//        self.titleLable.font = UIFont.boldSystemFont(ofSize: 15)
        self.summmaryLable.font = UIFont.boldSystemFont(ofSize: 10)
        self.introductionLable.font = UIFont.boldSystemFont(ofSize: 14)
        
        //layout
        backgroudView.snp.makeConstraints { (make) in
            make.top.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.bottom.equalTo(-64)
        }
        
        self.introductionLable.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.bottom.equalTo(-35)
        }
        
        self.summmaryLable.snp.makeConstraints { (make) in
            make.leading.equalTo(self.introductionLable.snp.leading)
            make.top.equalTo(self.introductionLable.snp.bottom).offset(12)
        }
        
        enterButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-22)
            make.trailing.equalTo(-8)
            make.width.equalTo(8)
            make.height.equalTo(15)
            enterButton.image = UIImage(named: "Album-enter")
            
        }
        
//        topLineView.snp.makeConstraints { (make) in
//            make.top.equalTo(50)
//            make.centerX.equalTo(contentView)
//            make.width.equalTo(74)
//            make.height.equalTo(1)
//        }
//        
//        bottomLineView.snp.makeConstraints { (make) in
//            //make.leading.equalTo(topLineView.snp.leading)
//            make.centerX.equalTo(contentView)
//            make.top.equalTo(self.titleLable.snp.bottom).offset(8)
//            make.width.equalTo(74)
//            make.height.equalTo(1)
//        }
//        
//        self.titleLable.snp.makeConstraints { (make) in
//            //make.leading.equalTo(150)
//            make.centerX.equalTo(contentView)
//            make.top.equalTo(topLineView.snp.bottom).offset(8)
//            make.width.greaterThanOrEqualTo(40)
//            titleLable.textAlignment = .center
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
