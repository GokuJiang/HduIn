//
//  ObjectDetailView.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/13.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class ObjectDetailView: UIView {
    var image = UIImageView()
    var nameTitle = UILabel()
    var nameLable = UILabel()
    var numberTitle = UILabel()
    var numberLable = UILabel()
    var timeTitle = UILabel()
    var timeLable = UILabel()
    var addressTitle = UILabel()
    var addressLable = UILabel()
    var detailTitle = UILabel()
    var detailLable = UILabel()
    var telTitle = UILabel()
    var telLable = UILabel()
    var telIcon = UIImageView()
    var localTitle = UILabel()
    var localLable = UILabel()
    
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        addViews()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        self.addSubview(image)
        self.addSubview(nameTitle)
        self.addSubview(nameLable)
        self.addSubview(numberTitle)
        self.addSubview(numberLable)
        self.addSubview(addressTitle)
        self.addSubview(addressLable)
        self.addSubview(timeTitle)
        self.addSubview(timeLable)
        self.addSubview(detailTitle)
        self.addSubview(detailLable)
        self.addSubview(telIcon)
        self.addSubview(telTitle)
        self.addSubview(telLable)
        self.addSubview(localTitle)
        self.addSubview(localLable)
    }

    func setupView(){
        self.image.snp.makeConstraints { (make) in
            make.top.equalTo(25)
            make.leading.equalTo(23)
            make.size.equalTo(CGSize(width: 145, height: 143))
            image.contentMode = .scaleAspectFit
        }
        self.nameTitle.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(180)
            nameTitle.font = UIFont.systemFont(ofSize: 16)
            nameTitle.text = "姓名："
            nameTitle.textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
        }
        
        self.nameLable.snp.makeConstraints { (make) in
            make.top.equalTo(nameTitle)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(nameTitle.snp.trailing).offset(2)
            nameLable.font = UIFont.systemFont(ofSize: 16)
            nameLable.textColor = UIColor(red: 40/255, green: 188/255, blue: 210/255, alpha: 1)
        }
        
        self.numberTitle.snp.makeConstraints { (make) in
            make.top.equalTo(nameTitle.snp.bottom).offset(12)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(nameTitle)
            numberTitle.font = UIFont.systemFont(ofSize: 16)
            numberTitle.text = "学号："
            numberTitle.textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
        }
        
        self.numberLable.snp.makeConstraints { (make) in
            make.top.equalTo(numberTitle)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(numberTitle.snp.trailing).offset(2)
            numberLable.font = UIFont.systemFont(ofSize: 16)
            numberLable.textColor = UIColor(red: 40/255, green: 188/255, blue: 210/255, alpha: 1)
        }
        
        self.timeTitle.snp.makeConstraints { (make) in
            make.top.equalTo(numberTitle.snp.bottom).offset(12)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(nameTitle)
            timeTitle.font = UIFont.systemFont(ofSize: 16)
            timeTitle.text = "捡到时间："
            timeTitle.textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
        }

        self.timeLable.snp.makeConstraints { (make) in
            make.top.equalTo(timeTitle)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(timeTitle.snp.trailing).offset(2)
            timeLable.font = UIFont.systemFont(ofSize: 16)
            timeLable.textColor = UIColor(red: 40/255, green: 188/255, blue: 210/255, alpha: 1)
        }

        self.addressTitle.snp.makeConstraints { (make) in
            make.top.equalTo(timeTitle.snp.bottom).offset(12)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(nameTitle)
            addressTitle.font = UIFont.systemFont(ofSize: 16)
            addressTitle.text = "捡到地点："
            addressTitle.textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
        }
        
        self.addressLable.snp.makeConstraints { (make) in
            make.top.equalTo(addressTitle.snp.bottom).offset(3)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(19)
            make.leading.equalTo(nameTitle)
            addressLable.font = UIFont.systemFont(ofSize: 15)
            addressLable.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
            addressLable.numberOfLines = 0
        }
        
        self.detailTitle.snp.makeConstraints { (make) in
            make.top.equalTo(image.snp.bottom).offset(11)
            make.leading.equalTo(image)
            make.width.greaterThanOrEqualTo(40)
            make.height.greaterThanOrEqualTo(20)
            detailTitle.text = "详细信息"
            detailTitle.font = UIFont.systemFont(ofSize: 14)
            detailTitle.textColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        }
        
        self.detailLable.snp.makeConstraints { (make) in
            make.top.equalTo(detailTitle.snp.bottom).offset(10)
            make.leading.equalTo(detailTitle)
            make.trailing.equalTo(-20)
            make.height.greaterThanOrEqualTo(50)
            detailLable.numberOfLines = 2
            detailLable.font = UIFont.systemFont(ofSize: 14)
            detailLable.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        }
        
        self.telTitle.snp.makeConstraints { (make) in
            make.top.equalTo(detailLable.snp.bottom).offset(68)
            make.centerX.equalTo(self)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(20)
            //telTitle.text = "热心童鞋联系方式"
            telTitle.font = UIFont.systemFont(ofSize: 14)
            telTitle.textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
        }
        
        self.telIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(telTitle)
            make.top.equalTo(telTitle.snp.bottom).offset(14)
            make.width.height.equalTo(15)
            telIcon.image = UIImage(named: "hot")
        }
        self.telLable.snp.makeConstraints { (make) in
            make.centerY.equalTo(telIcon)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(20)
            make.leading.equalTo(telIcon.snp.trailing).offset(5)
            telLable.textColor = UIColor(red: 40/255, green: 188/255, blue: 210/255, alpha: 1)
            telLable.font = UIFont.systemFont(ofSize: 16)
        }
        self.localTitle.snp.makeConstraints { (make) in
            make.top.equalTo(telLable.snp.bottom).offset(14)
            make.centerX.equalTo(self)
            make.height.greaterThanOrEqualTo(20)
            make.width.greaterThanOrEqualTo(30)
            localTitle.text = "领取地点"
            localTitle.font = UIFont.systemFont(ofSize: 14)
            localTitle.textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
        }

        self.localLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(localTitle.snp.bottom).offset(5)
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(20)
            localLable.textColor = UIColor(red: 40/255, green: 188/255, blue: 210/255, alpha: 1)
            localLable.font = UIFont.systemFont(ofSize: 14)
        }

        
        
    }
    

}
