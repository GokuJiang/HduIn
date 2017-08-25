//
//  PhotographerHeadView.swift
//  HduIn
//
//  Created by Kevin on 2016/12/14.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class PhotographerHeadView: UIView {
    
    var bgImage = UIImageView()
    var headImage = UIImageView()
    var maskbg = UIView()
    var nameLable = UILabel()
    var schoolLable = UILabel()
    var bookBtn = UIButton()
    var bgView = UIView()
    var iconImageView = UIImageView()
    var countLable = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
//    var detailView = UIView()
//    var imageLogo = UIImageView()
//    var imageNumber = UILabel()
//    var likeBtn = UIButton()
//    var likeNumber = UILabel()
    
    init(){
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(bgImage)
        self.bgImage.addSubview(maskbg)
        self.bgImage.addSubview(headImage)
        self.bgImage.addSubview(nameLable)
        self.bgImage.addSubview(schoolLable)
        self.bgImage.addSubview(bookBtn)
        self.bgImage.addSubview(bgView)
        self.bgView.addSubview(iconImageView)
        self.bgView.addSubview(countLable)
        
        bgImage.image = (UIImage(named: "Radio-Banner")?.withRenderingMode(.automatic))!
        bgImage.contentMode = .scaleToFill
        
        //bgImage.tintColor = UIColor(red: 75/255, green: 72/255, blue: 72/255, alpha: 0.1)
        
        bgImage.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(0)
        }
        maskbg.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(0)
            maskbg.backgroundColor = UIColor.black.alpha(0.2)
        }
        
//        headImage.image = UIImage(named: "headimage")
        headImage.contentMode = .scaleAspectFill
        headImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgImage)
            make.top.equalTo(bgImage).offset(50)
            make.size.equalTo(CGSize(width: 92, height: 92 * 2 / sqrt(3)))
        }
        
        let path = UIBezierPath()
        let imageWidth:CGFloat = 92
        let elineLength:CGFloat = imageWidth / (2 * sqrt(3)) //单位长度
        let imageHeight:CGFloat = 92 * 2 / sqrt(3)
        let lineHeight:CGFloat = imageHeight - 2 * elineLength
        
        path.lineWidth = 2
        path.move(to: CGPoint(x: 0, y: elineLength))
        path.addLine(to: CGPoint(x: 0, y: elineLength + lineHeight))
        path.addLine(to: CGPoint(x: imageWidth / 2, y: imageHeight))
        path.addLine(to: CGPoint(x: imageWidth, y: elineLength + lineHeight))
        path.addLine(to: CGPoint(x: imageWidth, y: elineLength))
        path.addLine(to: CGPoint(x: imageWidth / 2, y: 0))
        path.close()
        
        let sharpLayer = CAShapeLayer()
        sharpLayer.lineWidth = 2
        sharpLayer.strokeColor = UIColor.clear.cgColor
        sharpLayer.path = path.cgPath
        headImage.layer.mask = sharpLayer
        
//        nameLable.text = "陈曼"
        nameLable.backgroundColor = UIColor.clear
        nameLable.textColor = UIColor.white
        nameLable.textAlignment = .center
        nameLable.font = UIFont.systemFont(ofSize: 18)
        nameLable.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(headImage.snp.bottom).offset(22)
            make.height.greaterThanOrEqualTo(17)
        }
        
//        schoolLable.text = "毕业于中央音乐学院"
        schoolLable.backgroundColor = UIColor.clear
        schoolLable.textColor = UIColor.white
        schoolLable.textAlignment = .center
        schoolLable.font = UIFont.systemFont(ofSize: 12)
        schoolLable.snp.makeConstraints { (make) in
            make.top.equalTo(nameLable.snp.bottom).offset(18)
            make.leading.trailing.equalTo(0)
            make.height.greaterThanOrEqualTo(12)
        }
        
        bookBtn.setTitle(" 约    片    ", for: .normal)
        bookBtn.titleLabel?.textAlignment = .center
        bookBtn.backgroundColor = UIColor.clear
        bookBtn.layer.cornerRadius = 16
        bookBtn.layer.borderColor = UIColor.white.cgColor
        bookBtn.layer.borderWidth = 1.5
        bookBtn.layer.masksToBounds = true
        bookBtn.snp.makeConstraints { (make) in
            make.top.equalTo(schoolLable.snp.bottom).offset(28)
            make.centerX.equalTo(bgImage)
            make.width.greaterThanOrEqualTo(118)
            make.height.greaterThanOrEqualTo(27)
        }
        
//        detailView.backgroundColor = UIColor.black.alpha(0.5)
//        detailView.snp.makeConstraints { (make) in
//            make.leading.trailing.bottom.equalTo(0)
//            make.height.equalTo(65)
//        }
//        
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
//        
//        likeBtn.setImage(UIImage(named:"Focus-Heart"), for: .normal)
//        likeBtn.backgroundColor = UIColor.clear
//        likeBtn.snp.makeConstraints { (make) in
//            make.trailing.equalTo(-80)
//            make.top.equalTo(18)
//            make.size.equalTo(CGSize(width: 15, height: 12.5))
//        }
//        
//        likeNumber.textAlignment = .center
//        likeNumber.textColor = UIColor.white.alpha(0.6)
//        likeNumber.text = "100"
//        likeNumber.font = UIFont.systemFont(ofSize: 15)
//        likeNumber.snp.makeConstraints { (make) in
//            make.centerX.equalTo(likeBtn)
//            make.top.equalTo(likeBtn.snp.bottom).offset(11)
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


    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
