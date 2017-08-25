//
//  HduRadioProgramHeadView.swift
//  HduIn
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class HduRadioProgramHeadView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var imageView = UIImageView()
    var backButton = UIButton()
    var contenLabel = UILabel()
    var titleLable = UILabel()
    var timeLable = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.insertSubview(imageView, at: 0)
        self.addSubview(self.backButton)
        self.addSubview(contenLabel)
        self.addSubview(self.timeLable)
        self.addSubview(self.titleLable)
        
        self.backButton.setImage(UIImage(named: "Radio-Back"), for: .normal)
        
        self.contenLabel.numberOfLines = 5
        self.contenLabel.textColor = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        self.contenLabel.text = "我们需要一次奋不顾身的恋爱，一场说走就走的旅行。\n\n带你走遍祖国的山河秀美，领略国内国外的人文风光。\n\n  在行走中品味生活的真谛。用心感受旅途的意义。"
        self.contenLabel.font = UIFont.boldSystemFont(ofSize: 12)
        
        self.titleLable.textColor = UIColor.white
        self.titleLable.text = "人在旅途"
        
        self.timeLable.textColor = UIColor.white
        self.timeLable.text = "播出时间：周一下午"
        self.timeLable.font = UIFont.boldSystemFont(ofSize: 14)
        
        self.titleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(28)
            self.titleLable.textAlignment = .center
        }
        
        self.timeLable.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(167)
            self.timeLable.textAlignment  = .center
        }
        
        self.contenLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(75)
            self.contenLabel.textAlignment = .center
        }
        
        self.backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.top.equalTo(28)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(0)
        }
        imageView.image = UIImage(named: "Radio-Banner")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
