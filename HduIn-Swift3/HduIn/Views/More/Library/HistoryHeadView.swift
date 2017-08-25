//
//  HistoryHeadView.swift
//  HduIn
//
//  Created by Kevin on 2017/1/16.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class HistoryHeadView: UICollectionReusableView {
    var headTitle = LabelFactroy.createLabel(fontSize: 22, fontColor: HIColor.HduInBlue)
    var imageview = UIImageView()
    var line = UIView()
    override init(frame: CGRect){
        super.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
        //super.init(frame: frame)
        setupView()
    }
    func setupView(){
        self.addSubview(imageview)
        self.addSubview(headTitle)
        self.addSubview(line)
        self.backgroundColor = UIColor.white
        headTitle.textAlignment = .left
        headTitle.text = "历史记录"
        headTitle.font = UIFont.boldSystemFont(ofSize: 22)
        headTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(38)
            make.top.equalTo(15)
            make.width.greaterThanOrEqualTo(30)
        }
        
        
        imageview.image = UIImage(named: "library_historyblue")
        imageview.contentMode = .scaleAspectFit
        imageview.snp.makeConstraints { (make) in
            make.leading.equalTo(headTitle.snp.trailing).offset(20)
            make.width.height.equalTo(24)
            //make.top.equalTo(headTitle)
             make.centerY.equalTo(self.headTitle)
        }
        
        line.backgroundColor = UIColor.lightGray
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.trailing.equalTo(-10)
            make.height.equalTo(1)
            make.top.equalTo(headTitle.snp.bottom).offset(7)
        }
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
