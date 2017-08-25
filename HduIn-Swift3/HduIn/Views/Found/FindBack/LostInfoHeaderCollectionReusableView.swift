//
//  LostInfoHeaderCollectionReusableView.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/26.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

import UIKit


class LostInfoHeaderCollectionReusableView: UICollectionReusableView {
    
    //    var letfButton = UIButton()
    var rightButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContent() {
        self.backgroundColor = UIColor.white
        //        self.addSubview(self.letfButton)
        self.addSubview(self.rightButton)
        
        //        self.letfButton.snp.makeConstraints { (make) in
        //            make.leading.equalTo(36)
        //            make.top.equalTo(4)
        //            make.height.equalTo(29)
        //            make.width.equalTo(120)
        //        }
        //
        self.rightButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.top.equalTo(4)
            make.width.equalTo(120)
            make.height.equalTo(29)
            
        }
        let color = UIColor(hex: "28bcd2")
        
        self.rightButton.setTitle("+ 关注此类", for: .normal)
        self.rightButton.setTitleColor(color, for: .normal)
        self.rightButton.titleLabel?.font = UIFont(name: ".PingFangSC-Medium", size: 13)
        
        //        self.letfButton.setTitle("一卡通", for: .normal)
        //        self.letfButton.setTitleColor(color, for: .normal)
        //        self.letfButton.titleLabel?.font = UIFont(name: ".PingFangSC-Medium", size: 14)
        //        
    }
}
