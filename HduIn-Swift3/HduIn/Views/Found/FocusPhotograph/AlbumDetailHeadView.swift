//
//  AlbumDetailHeadView.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class AlbumDetailHeadView: UIView {
    var bgImage = UIImageView()
    var titalLable = UILabel()
    var subTitalLable = UILabel()
    var timeLable = UILabel()
    var bgView = UIView()
    
    var iconImageView = UIImageView()
    var countLable = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    
    init(){
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(bgImage)
        self.bgImage.addSubview(titalLable)
        self.bgImage.addSubview(subTitalLable)
        self.bgImage.addSubview(timeLable)
        self.bgImage.addSubview(bgView)
//        self.detailView.addSubview(imageLogo)
//        self.detailView.addSubview(imageNumber)
        self.bgView.addSubview(iconImageView)
        self.bgView.addSubview(countLable)
        
        
        bgImage.image = (UIImage(named: "Radio-Banner")?.withRenderingMode(.automatic))!
        bgImage.contentMode = .scaleToFill
        //bgImage.tintColor = UIColor(red: 75/255, green: 72/255, blue: 72/255, alpha: 0.1)
        
        bgImage.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(0)
        }
        
//        titalLable.text = "《最忆是杭电》"
        titalLable.backgroundColor = UIColor.clear
        titalLable.textColor = UIColor.white
        titalLable.textAlignment = .center
        titalLable.font = UIFont.systemFont(ofSize: 20)
        titalLable.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(109)
            make.height.greaterThanOrEqualTo(17)
        }
        
//        subTitalLable.text = "杭州电子科技大学60周年校庆晚会"
        subTitalLable.backgroundColor = UIColor.clear
        subTitalLable.textColor = UIColor.white
        subTitalLable.textAlignment = .center
        subTitalLable.font = UIFont.systemFont(ofSize: 14)
        subTitalLable.snp.makeConstraints { (make) in
            make.top.equalTo(titalLable.snp.bottom).offset(38)
            make.leading.trailing.equalTo(0)
            make.height.greaterThanOrEqualTo(12)
        }
        
        
        
//        detailView.backgroundColor = UIColor.black.alpha(0.5)
//        bgView.snp.makeConstraints { (make) in
//            make.leading.trailing.bottom.equalTo(0)
//            make.height.equalTo(65)
//        }
        
//        timeLable.text = "2016-11-11"
        timeLable.backgroundColor = UIColor.clear
        timeLable.textColor = UIColor.white
        timeLable.textAlignment = .center
        timeLable.font = UIFont.systemFont(ofSize: 10)
        timeLable.snp.makeConstraints { (make) in
            make.trailing.equalTo(-13)
            make.bottom.equalTo(bgView.snp.top).offset(-10)
            make.width.greaterThanOrEqualTo(40)
            make.height.greaterThanOrEqualTo(20)
        }

        
//        imageLogo.image = UIImage(named: "Radio-Next")
//        imageLogo.backgroundColor = UIColor.clear
//        imageLogo.snp.makeConstraints { (make) in
//            make.leading.equalTo(80)
//            make.top.equalTo(18)
//            make.size.equalTo(CGSize(width: 15, height: 12.5))
//        }
//        
//        imageNumber.textAlignment = .center
//        imageNumber.textColor = UIColor.white.alpha(0.6)
//        imageNumber.text = "12"
//        imageNumber.font = UIFont.systemFont(ofSize: 15)
//        imageNumber.snp.makeConstraints { (make) in
//            make.centerX.equalTo(imageLogo)
//            make.top.equalTo(imageLogo.snp.bottom).offset(11)
//            make.height.greaterThanOrEqualTo(10)
//            make.width.greaterThanOrEqualTo(13)
//        }
        
        bgView.snp.makeConstraints { (make) in
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(22)
            make.width.greaterThanOrEqualTo(35)
            make.bottom.equalTo(-3)
            bgView.backgroundColor = UIColor(hex: "000000").alpha(0.5)
        }
        
        iconImageView.snp.makeConstraints{(make) in
            make.bottom.equalTo(bgView)
            make.leading.equalTo(bgView.snp.leading).offset(4)
            make.height.width.equalTo(14)
            iconImageView.image = UIImage(named: "imageicon")
        }
        countLable.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImageView)
            make.leading.equalTo(iconImageView.snp.trailing).offset(1)
        }

        
//        likeLogo.image = UIImage(named: "Fource-Logo")
//        likeLogo.backgroundColor = UIColor.clear
//        likeLogo.snp.makeConstraints { (make) in
//            make.trailing.equalTo(-30)
//            make.top.equalTo(18)
//            make.size.equalTo(CGSize(width: 15, height: 12.5))
//        }
//        
//        likeNumber.textAlignment = .center
//        likeNumber.textColor = UIColor.white.alpha(0.6)
//        likeNumber.font = UIFont.systemFont(ofSize: 15)
//        likeNumber.snp.makeConstraints { (make) in
//            make.centerX.equalTo(likeLogo)
//            make.top.equalTo(likeLogo.snp.bottom).offset(11)
//            make.height.greaterThanOrEqualTo(10)
//            make.width.greaterThanOrEqualTo(13)
//        }
        
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
