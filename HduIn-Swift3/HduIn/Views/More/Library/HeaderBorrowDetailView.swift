//
//  HeaderBorrowDetailView.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/14.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class HeaderBorrowDetailView: UIView {

    var bookNameLabel = UILabel()
    var authorNameLabel = UILabel()
    var publishHouseLabel = UILabel()
    var bookReferenceLabel = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    
    func setView(){
        
        let campusLabel = UILabel()
        let detailLabel = UILabel()
        let statusLabel = UILabel()
        
        self.addSubview(self.bookNameLabel)
        self.addSubview(self.authorNameLabel)
        self.addSubview(self.publishHouseLabel)
        self.addSubview(self.bookReferenceLabel)
        self.addSubview(campusLabel)
        self.addSubview(detailLabel)
        self.addSubview(statusLabel)
        
        campusLabel.text = "校区"
        detailLabel.text = "馆藏地"
        statusLabel.text = "书刊状态"
        
        //set color
        self.bookNameLabel.textColor = UIColor(hex: "50b5ed")
        self.authorNameLabel.textColor = UIColor(hex: "6c6c6c")
        self.publishHouseLabel.textColor = UIColor(hex: "6c6c6c")
        self.bookReferenceLabel.textColor = UIColor(hex: "6c6c6c")
        statusLabel.textColor = UIColor(hex: "50b5ed")
        campusLabel.textColor = UIColor(hex: "50b5ed")
        detailLabel.textColor = UIColor(hex: "50b5ed")
        
        //set font
        self.bookNameLabel.font = UIFont.systemFont(ofSize: 20, weight: 10)
        self.authorNameLabel.font = UIFont.systemFont(ofSize: 18, weight: 10)
        self.publishHouseLabel.font = UIFont.systemFont(ofSize: 12, weight: 10)
        self.bookReferenceLabel.font = UIFont.systemFont(ofSize: 12, weight: 10)
        campusLabel.font = UIFont.systemFont(ofSize: 18, weight: 10)
        detailLabel.font = UIFont.systemFont(ofSize: 18, weight: 10)
        statusLabel.font = UIFont.systemFont(ofSize: 18, weight: 10)
        
        //layout
        self.bookNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(27)
            make.top.equalTo(23)
            
        }
        
        self.authorNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.bookNameLabel.snp.leading)
            make.top.equalTo(self.bookNameLabel.snp.bottom).offset(19)
        }
        
        self.publishHouseLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.bookNameLabel.snp.leading)
            make.top.equalTo(self.authorNameLabel.snp.bottom).offset(15)
            
        }
        
        self.bookReferenceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.bookNameLabel.snp.leading)
            make.top.equalTo(self.publishHouseLabel.snp.bottom).offset(10)
        }
        
        campusLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(39)
            make.bottom.equalTo(-20)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(campusLabel.snp.trailing).offset(87)
            make.bottom.equalTo(campusLabel.snp.bottom)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(detailLabel.snp.trailing).offset(60)
            make.bottom.equalTo(campusLabel.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
