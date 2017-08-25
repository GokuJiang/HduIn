//
//  SearchHistoryHeaderCollectionReusableView.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/17.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class SearchHistoryHeaderCollectionReusableView: UICollectionReusableView {
    
    var headerTitle = UILabel()
    var searchIamgeView = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setView() {
        let lineView = UIView()
        
        self.addSubview(self.headerTitle)
        self.addSubview(lineView)
        self.addSubview(self.searchIamgeView)
        
                
        self.headerTitle.font = UIFont(name: "PingFangSC-Medium", size: 18)
        
        self.headerTitle.textColor = UIColor(hex: "50b5ed")
        lineView.backgroundColor = UIColor(red: 230.0 / 255, green: 230.0 / 255, blue: 230.0 / 255, alpha: 1.0)
        
        self.headerTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(28)
            make.bottom.equalTo(-10)
        }
        
        lineView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.leading.equalTo(21)
            make.height.equalTo(1.5)
            make.width.equalTo(340)
        }
        
        
    }
}
