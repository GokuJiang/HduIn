//
//  SearchHistoryCollectionViewCell.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/17.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class SearchHistoryCollectionViewCell: UICollectionViewCell {
    
//    var tenNumberLabel: [UILabel] = Array(repeating: UILabel(), count: 10)
    var numberLabel = UILabel()
    var bookNameLabel = UILabel()
    var historyBookLabel = UILabel()
    var searchIamgeView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel(){
        
        self.contentView.addSubview(self.bookNameLabel)
        self.contentView.addSubview(self.numberLabel)
        self.contentView.addSubview(self.historyBookLabel)
        self.contentView.addSubview(self.searchIamgeView)
        
        self.bookNameLabel.font = UIFont(name: "PingFangSC-Medium", size: 12)
        self.numberLabel.font = UIFont(name: "PingFangSC-Medium", size: 12)
        self.historyBookLabel.font = UIFont(name: "PingFangSC-Medium", size: 12)
        
        self.bookNameLabel.textColor = UIColor(hex: "6c6c6c")
        self.historyBookLabel.textColor = UIColor(hex: "6c6c6c")
        
        self.numberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(28)
            make.top.equalTo(16)
        }
        
        self.bookNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.numberLabel.snp.leading).offset(14)
            make.top.equalTo(self.numberLabel.snp.top)
        }
        
        self.searchIamgeView.snp.makeConstraints { (make) in
            make.leading.equalTo(28)
            make.top.equalTo(22)
            make.width.height.equalTo(14)
        }
        
        self.historyBookLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.searchIamgeView.snp.trailing).offset(7)
            make.top.equalTo(22)
        }
    }
}
