//
//  LostInfoCollectionViewCell.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/26.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class LostInfoCollectionViewCell: UICollectionViewCell {
    
    var lostLabel = UILabel()
    var lostContentLabel = UILabel()
    var numLabel = UILabel()
    var numContentLabel = UILabel()
    var timeLabel = UILabel()
    var timeContentLabel = UILabel()
    var addressLabel = UILabel()
    var addressContentLabel = UILabel()
    var imageView = UIImageView()
    var attrImageView = UIImageView()
    var bgLayer = CAShapeLayer()
    var infoButton = UIButton()
    var infoView = UIView()
    enum Mode {
        case display
        case changeState
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(mode:Mode) {
        super.init(frame: CGRect.zero)
        setView(mode: mode)
    }
    
    func setBezierPath(){
        //let height = 26
        let startPoint = CGPoint(x: self.contentView.frame.size.width, y: 14)
        let endPoint = CGPoint(x: self.contentView.frame.size.width, y: 40)
        
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: CGPoint(x: startPoint.x - 25, y: startPoint.y))
        path.addQuadCurve(to: CGPoint(x: startPoint.x-38, y: startPoint.y+13), controlPoint: CGPoint(x:startPoint.x-38,y:startPoint.y))
        path.addQuadCurve(to: CGPoint(x: startPoint.x - 25, y: startPoint.y + 26), controlPoint: CGPoint(x:startPoint.x-38,y:startPoint.y+26))
        path.addLine(to: endPoint)
        
        
        path.lineJoinStyle = .round
        path.lineCapStyle = .butt
        
        self.bgLayer.path = path.cgPath
        self.contentView.layer.insertSublayer(self.bgLayer, at: 1)
        
    }
    
    func setView(mode: Mode){

        let view = UIView()
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(0)
            
        }
        
        let shdowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 12).cgPath
        self.layer.shadowPath = shdowPath
        self.layer.shadowColor = UIColor(hex: "000000").alpha(0.8).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false

        
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        
        view.addSubview(self.imageView)
        view.addSubview(self.lostLabel)
        view.addSubview(self.lostContentLabel)
        view.addSubview(self.numLabel)
        view.addSubview(self.numContentLabel)
        view.addSubview(self.timeLabel)
        view.addSubview(self.timeContentLabel)
        view.addSubview(self.addressLabel)
        view.addSubview(self.addressContentLabel)
        view.addSubview(self.attrImageView)
        
        
        //font
        self.lostLabel.font = UIFont(name: ".PingFangSC-Regular", size: 13)
        self.numLabel.font = UIFont(name: ".PingFangSC-Regular", size: 13)
        self.timeLabel.font = UIFont(name: ".PingFangSC-Regular", size: 13)
        self.addressLabel.font = UIFont(name: ".PingFangSC-Regular", size: 13)
        self.lostContentLabel.font = UIFont(name: ".PingFangSC-Regular", size: 13)
        self.numContentLabel.font = UIFont(name: ".PingFangSC-Regular", size: 13)
        self.timeContentLabel.font = UIFont(name: ".PingFangSC-Regular", size: 13)
        self.addressContentLabel.font  = UIFont(name: ".PingFangSC-Regular", size: 13)
        
        //color
        let gray = UIColor(hex: "6d6d6d")
        let blue = UIColor(hex: "3397db")
        self.lostLabel.textColor = gray
        self.numLabel.textColor = gray
        self.timeLabel.textColor = gray
        self.timeContentLabel.textColor = gray
        self.addressLabel.textColor = gray
        self.addressContentLabel.textColor = gray
        self.numContentLabel.textColor = blue
        self.lostContentLabel.textColor = blue
        
        self.contentView.backgroundColor = UIColor.white
        
        
        
        self.imageView.snp.makeConstraints { (make) in
            make.leading.top.equalTo(10)
            make.width.equalTo(103)
            make.height.equalTo(96)
        }
        
        self.lostLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
        }
        
        self.lostContentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(76)
            make.top.equalTo(self.imageView.snp.bottom).offset(12)
        }
        switch mode {
        case .display:
            self.numLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.top.equalTo(self.imageView.snp.bottom).offset(34)
            }
            
            self.numContentLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(50)
                make.top.equalTo(self.imageView.snp.bottom).offset(34)
            }
            
            self.timeLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.top.equalTo(self.imageView.snp.bottom).offset(56)
            }
            
            self.timeContentLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(50)
                make.top.equalTo(self.imageView.snp.bottom).offset(56)
            }
            
            self.addressLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(10)
                make.top.equalTo(self.imageView.snp.bottom).offset(78)
            }
            
            self.addressContentLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(76)
                make.top.equalTo(self.imageView.snp.bottom).offset(78)
            }
            self.lostLabel.text = "物品名称："
            self.numLabel.text = "学号："
            self.timeLabel.text = "时间："
            self.addressLabel.text = "丢失地点："
            
        case .changeState:
            self.contentView.addSubview(self.infoButton)
            
            self.lostLabel.text = "物品名称："
            self.infoButton.backgroundColor = UIColor(hex: "28bcd2")
            self.infoButton.snp.makeConstraints({ (make) in
                make.leading.equalTo(32)
                make.top.equalTo(158)
                make.trailing.equalTo(-31)
                make.bottom.equalTo(-29)
                self.infoButton.layer.cornerRadius = 13
                self.infoButton.layer.masksToBounds = true
            })
//            self.infoView.addSubview(self.infoButton)
//            self.infoButton.snp.makeConstraints({ (make) in
//                make.centerX.equalTo(self.infoView.snp.centerX)
//                make.top.equalTo(6)
//            })
            self.infoButton.titleLabel?.font = UIFont(name: ".PingFangSC-Regular", size: 13)
            self.infoButton.setTitleColor(UIColor(hex: "ffffff"), for: .normal)
        }
        self.attrImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-7)
            make.top.equalTo(19)
            make.width.equalTo(22)
            make.height.equalTo(13)
        }
        
        
    }
}

