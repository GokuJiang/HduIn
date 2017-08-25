//
//  HduRaioPlayView.swift
//  HduIn
//
//  Created by 姜永铭 on 11/7/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import UIKit
import SnapKit

class HduRaioPlayView: UIView {
    
    //Header
    var backButton = UIButton()
    var menuButton = UIButton()
    var titleLabel = LabelFactroy.createLabel(fontSize: 16,fontColor: UIColor.white)

    //play
    var preButton = UIButton()
    var nextButton = UIButton()
    var playButton = UIButton()
    var startLabel = LabelFactroy.createLabel(fontSize: 10, fontColor: HIColor.PlayerTimeGrey)
    var endLabel = LabelFactroy.createLabel(fontSize: 10, fontColor: HIColor.PlayerTimeGrey)
    let progressSlider = UISlider()
   
    
    var backgroundImageView = UIImageView()
    
    //cover
    var coverBackgroundView = UIView()
    var coverImageView = UIImageView()
    var songNameLabel = LabelFactroy.createLabel(fontSize: 24, fontColor: UIColor.black)
    var hostLabel = LabelFactroy.createLabel(fontSize: 14, fontColor: UIColor.black)
    var directorLabel = LabelFactroy.createLabel(fontSize: 14, fontColor: UIColor.black)
    var producerLabel = LabelFactroy.createLabel(fontSize: 14, fontColor: UIColor.black)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addSubViews(){
        self.addSubview(backgroundImageView)
        self.addSubview(backButton)
        self.addSubview(preButton)
        self.addSubview(nextButton)
        self.addSubview(playButton)
        self.addSubview(progressSlider)
        self.addSubview(songNameLabel)
        self.addSubview(titleLabel)
        self.addSubview(menuButton)
        self.addSubview(hostLabel)
        self.addSubview(directorLabel)
        self.addSubview(producerLabel)
        self.addSubview(startLabel)
        self.addSubview(endLabel)
        self.addSubview(coverBackgroundView)
        coverBackgroundView.addSubview(coverImageView)

    }
    
    func setupView(){
        addSubViews()
        
        //Play
        startLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(progressSlider.snp.leading).offset(-12)
            make.center.equalTo(progressSlider)
            make.width.equalTo(36)
        }
        
        progressSlider.snp.makeConstraints { (make) in
            make.bottom.equalTo(playButton.snp.top).offset(-37 * ratioHeight)
            make.width.equalTo(250 * ratioWidth)
            make.centerX.equalTo(self)
            make.height.equalTo(4)
            progressSlider.setThumbImage(UIImage(named: "Radio-Oval"), for: .normal)
            progressSlider.minimumTrackTintColor = UIColor.HISapphire
            progressSlider.maximumTrackTintColor = UIColor.HICornflower
//            progressSlider.setThumbImage(UIImage(named: "PK-point"), forState: UIControlState.Normal)
        }
        
        endLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(progressSlider.snp.trailing).offset(12)
            make.bottom.equalTo(startLabel)
        }
        
        preButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playButton)
            make.trailing.equalTo(playButton.snp.leading).offset(-34)
            make.height.width.equalTo(20)
            preButton.setImage(UIImage(named: "Radio-Pre"), for: UIControlState.normal)
        }
        playButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-53 * ratioHeight)
            make.centerX.equalTo(self)
            make.width.height.equalTo(60)
            playButton.setImage(UIImage(named: "Radio-Play"), for: .normal)
            playButton.setImage(UIImage(named: "Radio-Pause"), for: .selected)
        }
        nextButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(playButton)
            make.leading.equalTo(playButton.snp.trailing).offset(34)
            make.height.width.equalTo(20)
            nextButton.setImage(UIImage(named: "Radio-Next"), for: .normal)
        }
        
        //bg
        backgroundImageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(songNameLabel.snp.top).offset(-54 * ratioHeight)
        }
        
        
        //header
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(29)
        }
        backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.top.equalTo(32)
            make.width.height.equalTo(20)
            backButton.setImage(UIImage(named: "Radio-back"), for: UIControlState.normal)
            
        }
        
        menuButton.snp.makeConstraints { (make) in
            make.top.equalTo(backButton)
            make.trailing.equalTo(-18)
            make.width.equalTo(20)
            make.height.equalTo(14)
            menuButton.setImage(UIImage(named: "Radio-Menu"), for: UIControlState.normal)
        }
        
        
        coverBackgroundView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.width.height.equalTo(168)
            make.top.equalTo(self).offset(161 * ratioHeight)
            coverBackgroundView.backgroundColor = UIColor(hex: "000000").alpha(0.5)
            coverBackgroundView.layer.cornerRadius = 84
            coverBackgroundView.layer.masksToBounds = true
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        songNameLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(directorLabel.snp.top).offset(-38)
            make.centerX.equalTo(coverBackgroundView)
        }
        
        
        hostLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(directorLabel.snp.top).offset(-8)
            make.centerX.equalTo(self)
        }
        directorLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(producerLabel.snp.top).offset(-8)
        }
        producerLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(progressSlider.snp.top).offset(-41)
        }
        
    }

}
