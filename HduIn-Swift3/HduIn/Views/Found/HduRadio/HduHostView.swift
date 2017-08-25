//
//  HduHostView.swift
//  HduIn
//
//  Created by Kevin on 2017/1/14.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class HduHostView: UIView {
    var titleLable = UILabel()
    var mainView = UIView()
    var contentLable = UILabel()
    var nameLable = UILabel()
    var hostImage = UIImageView()
    var bottomView = UIView()
    var bottomTitle = UILabel()
    var phoneLable = UILabel()
    var phoneImage = UIImageView()
    var playBtn = UIButton()


    override init(frame:CGRect){
        super.init(frame: frame)
        self.addViews()
        self.setTitle()
        self.setMainView()
        self.setBottomView()
    }
    
    func addViews(){
        self.addSubview(mainView)
        self.addSubview(titleLable)
        self.addSubview(bottomView)
        self.mainView.addSubview(nameLable)
        self.mainView.addSubview(hostImage)
        self.mainView.addSubview(contentLable)
        self.mainView.addSubview(playBtn)
        self.bottomView.addSubview(bottomTitle)
        self.bottomView.addSubview(phoneImage)
        self.bottomView.addSubview(phoneLable)
    }
    
    func setTitle() {
        titleLable.textColor = UIColor.white
        titleLable.backgroundColor = UIColor(colorLiteralRed: 93/255, green: 195/255, blue: 252/255, alpha: 1)
        titleLable.text = "预约主持"
        titleLable.font = UIFont.systemFont(ofSize: 18)
        titleLable.textAlignment = .center
        titleLable.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(28)
            make.height.greaterThanOrEqualTo(25)
        }
    }

    func setMainView(){
        
        mainView.backgroundColor = UIColor.white
        mainView.snp.makeConstraints{(make) in
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.bottom.equalTo(-140)
            make.top.equalTo(80)
        }
        mainView.layer.cornerRadius = 8
        mainView.layer.masksToBounds = true
        
        setName()
        setHostImage()
        showContent()
        setPalyBtn()
    }
    
    func setName(){
        nameLable.textColor = UIColor(red: 127/255, green: 177/255, blue: 236/255, alpha: 1)
        nameLable.text = "梁咏琪"
        nameLable.font = UIFont.systemFont(ofSize: 20)
        nameLable.textAlignment = .center
        nameLable.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.mainView)
            make.top.equalTo(self.mainView).offset(14)
            make.height.greaterThanOrEqualTo(28)
        }
        
    }
    
 

    
    func setHostImage(){
        hostImage.image = UIImage(named: "nuomi")
        hostImage.layer.cornerRadius = 8
        hostImage.layer.masksToBounds = true
        hostImage.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(65)
            make.bottom.equalTo(-210)
        }
    }
    
    func showContent(){
        self.contentLable.numberOfLines = 0
        self.contentLable.textAlignment = .center
        self.contentLable.textColor = UIColor.gray
        self.contentLable.font = UIFont.systemFont(ofSize: 14)
        let contentString = "现任广播台台长\n来自数艺学院\n擅长轻松欢快活泼的主持风格\n也可以优雅大方，主持一些严肃的节目"
        let contentStr:NSMutableAttributedString = NSMutableAttributedString(string: contentString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        
        contentStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, contentString.characters.count))
        self.contentLable.attributedText = contentStr
        self.contentLable.snp.makeConstraints { (make) in
            make.leading.equalTo(1)
            make.trailing.equalTo(-1)
            make.top.equalTo(hostImage.snp.bottom).offset(10)
            make.bottom.equalTo(-90)
        }
    }

        
    func setBottomView(){
        self.bottomView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-30)
            make.leading.equalTo(30)
            make.bottom.equalTo(-30)
            make.top.equalTo(self.mainView.snp.bottom).offset(30)
        }
        self.bottomView.backgroundColor = UIColor.white
        self.bottomView.layer.cornerRadius = 8
        self.bottomView.layer.masksToBounds = true
        
        self.bottomTitle.textAlignment = .center
        let bottomString = "预约主持人请联系队长"
        self.bottomTitle.text = bottomString
        self.bottomTitle.textColor = UIColor.gray
        self.bottomTitle.font = UIFont.systemFont(ofSize: 14)
        self.bottomTitle.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(16)
            make.height.greaterThanOrEqualTo(17)
        }
        
        self.phoneImage.image = UIImage(named: "Play-Blue")
        self.phoneImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.leading.equalTo(65)
            make.top.equalTo(50)
        }
        setPhoneNumber()
    }
    
    func setPhoneNumber(){
        self.phoneLable.text = "15957146603|666603"
        self.phoneLable.textColor = UIColor(red: 52/255, green: 153/255, blue: 218/255, alpha: 1)
        self.phoneLable.font = UIFont.systemFont(ofSize: 18)
        self.phoneLable.snp.makeConstraints { (make) in
            make.leading.equalTo(self.phoneImage.snp.trailing).offset(5)
            make.centerY.equalTo(self.phoneImage)
            make.width.greaterThanOrEqualTo(200)
        }
    }
    
    func setPalyBtn(){
        self.playBtn.setImage(UIImage(named: "Radio-Play"), for: .normal)
        self.playBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.mainView)
            make.width.height.equalTo(40)
            make.centerY.equalTo(self.mainView).offset(202)
        }
        
    }



    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
