//
//  BorrowCollectionViewCell.swift
//  HduIn
//
//  Created by Kevin on 2017/1/15.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class BorrowTableViewCell: UITableViewCell {
    var showDetail = false
    var bgView = UIView()
    var authorLable = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    var titleLable = LabelFactroy.createLabel(fontSize: 22, fontColor: UIColor.white)
    var deadlineLable = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    var publicHouseLable = LabelFactroy.createLabel(fontSize: 10, fontColor: UIColor.white)
    var numberLabe = LabelFactroy.createLabel(fontSize: 10, fontColor: UIColor.white)
    var renewNumberLable = LabelFactroy.createLabel(fontSize: 10, fontColor: UIColor.white)
    var residueLable = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    var residueNumberLable = LabelFactroy.createLabel(fontSize: 18, fontColor: UIColor.white)
    var renewButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupSmallView()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        self.addSubview(bgView)
        self.bgView.addSubview(authorLable)
        self.bgView.addSubview(titleLable)
        self.bgView.addSubview(deadlineLable)
        self.bgView.addSubview(publicHouseLable)
        self.bgView.addSubview(numberLabe)
        self.bgView.addSubview(renewNumberLable)
        self.bgView.addSubview(residueLable)
        self.bgView.addSubview(residueNumberLable)
        self.bgView.addSubview(renewButton)
    }
    
    func setupSmallView(){
        self.bgView.backgroundColor = UIColor(hex: "50b5ed")
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        self.bgView.snp.remakeConstraints { (make) in
            make.leading.equalTo(12)
            make.top.equalTo(5)
            make.trailing.equalTo(-12)
            make.height.equalTo(92.5)
            make.bottom.equalTo(-5)
        }
        
        //self.authorLable.text = ""
        self.authorLable.snp.remakeConstraints { (make) in
            make.top.equalTo(bgView).offset(4)
            make.leading.equalTo(16)
            make.height.equalTo(30)
            make.width.greaterThanOrEqualTo(15)
        }
        
        //self.deadlineLable.text = ""
        self.deadlineLable.snp.remakeConstraints { (make) in
            make.trailing.equalTo(-18)
            make.top.bottom.height.equalTo(self.authorLable)
        }
        
        //self.titleLable.text = ""
        self.titleLable.snp.remakeConstraints { (make) in
            make.top.equalTo(authorLable.snp.bottom).offset(-15)
            make.leading.equalTo(self.authorLable)
            make.bottom.equalTo(-33)//底部约束
            make.width.greaterThanOrEqualTo(40)
            make.height.equalTo(50)
        }
        self.titleLable.font = UIFont.boldSystemFont(ofSize: 23)
        
        self.residueLable.text = "剩余 :"
        self.residueLable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(-12)
            make.trailing.equalTo(-58)
            make.top.equalTo(self.deadlineLable.snp.bottom).offset(40)
            make.height.greaterThanOrEqualTo(10)
        }
        
        //self.residueNumberLable.text = ""
        self.residueNumberLable.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.residueLable.snp.trailing).offset(3)
            make.height.greaterThanOrEqualTo(15)
            make.trailing.equalTo(-12)
            make.centerY.equalTo(residueLable)
        }
        
        self.residueNumberLable.font = UIFont.boldSystemFont(ofSize: 20)
        
        renewButton.setTitle("续 借", for: .normal)
        renewButton.titleLabel?.textAlignment = .center
        renewButton.setTitleColor(HIColor.hduMediumBlue, for: .normal)
        renewButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        renewButton.backgroundColor = UIColor.white
        renewButton.layer.cornerRadius = 15
        renewButton.layer.masksToBounds = true
        
        publicHouseLable.snp.remakeConstraints { (make) in
            make.height.width.equalTo(1)
            make.leading.equalTo(-200)
            make.top.equalTo(-100)
        }
        
        numberLabe.snp.remakeConstraints { (make) in
            make.height.width.equalTo(1)
            make.leading.equalTo(-200)
            make.top.equalTo(-100)
        }
        
        renewNumberLable.snp.remakeConstraints { (make) in
            make.height.width.equalTo(1)
            make.leading.equalTo(-200)
            make.top.equalTo(-100)
        }
        
        renewButton.snp.remakeConstraints { (make) in
            make.height.width.equalTo(1)
            make.leading.equalTo(-200)
            make.top.equalTo(-100)
        }


        
    }
    
    func setupLargeView(){
        self.bgView.backgroundColor = UIColor(red: 80/255, green: 181/255, blue: 236/255, alpha: 1)
        self.bgView.layer.cornerRadius = 10
        self.bgView.layer.masksToBounds = true
        self.bgView.snp.remakeConstraints { (make) in
            make.leading.equalTo(12)
            make.top.equalTo(5)
            make.trailing.equalTo(-12)
            make.height.equalTo(160)
            make.bottom.equalTo(-5)
        }
        
        self.authorLable.snp.remakeConstraints { (make) in
            make.top.equalTo(bgView).offset(12)
            make.leading.equalTo(16)
            make.height.equalTo(7)
            make.width.greaterThanOrEqualTo(15)
        }
        
        self.deadlineLable.snp.remakeConstraints { (make) in
            make.trailing.equalTo(-18)
            make.top.bottom.height.equalTo(self.authorLable)
        }
        
        self.titleLable.snp.remakeConstraints { (make) in
            make.top.equalTo(authorLable.snp.bottom)
            make.leading.equalTo(self.authorLable)
            make.width.greaterThanOrEqualTo(10)
            make.height.equalTo(50)
        }
        
        self.publicHouseLable.snp.remakeConstraints { (make) in
            make.top.equalTo(titleLable.snp.bottom).offset(2)
            make.leading.equalTo(titleLable)
            make.height.greaterThanOrEqualTo(10)
            make.width.greaterThanOrEqualTo(15)
        }
        
        self.numberLabe.snp.remakeConstraints { (make) in
            make.top.equalTo(publicHouseLable.snp.bottom).offset(3)
            make.leading.equalTo(titleLable)
            make.height.greaterThanOrEqualTo(10)
            make.width.greaterThanOrEqualTo(15)
        }
        
        renewButton.snp.remakeConstraints { (make) in
            make.top.equalTo(numberLabe.snp.bottom).offset(20)
            make.leading.equalTo(8)
            make.height.equalTo(35)
            make.width.equalTo(220)
        }
        
        residueNumberLable.snp.remakeConstraints { (make) in
            make.trailing.equalTo(deadlineLable)
            make.height.greaterThanOrEqualTo(5)
            make.top.equalTo(numberLabe.snp.bottom).offset(8)
            make.width.greaterThanOrEqualTo(8)
        }
        
        self.residueLable.text = "剩余 :"
        self.residueLable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(renewButton.snp.bottom)
            make.trailing.equalTo(-58)
            make.height.greaterThanOrEqualTo(10)
        }
        
        self.residueNumberLable.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.residueLable.snp.trailing).offset(3)
            make.height.greaterThanOrEqualTo(15)
            make.trailing.equalTo(-12)
            make.centerY.equalTo(residueLable)
        }
        
        self.renewNumberLable.snp.remakeConstraints { (make) in
            make.bottom.equalTo(residueNumberLable.snp.top).offset(-20)
            make.trailing.equalTo(residueNumberLable.snp.trailing).offset(-2)
            make.height.greaterThanOrEqualTo(5)
            make.width.greaterThanOrEqualTo(5)
        }


    }
    
    func didSelected(){
        if showDetail{
            setupLargeView()
            showDetail = false
        }else{
            setupSmallView()
            showDetail = true
        }
    }
}
