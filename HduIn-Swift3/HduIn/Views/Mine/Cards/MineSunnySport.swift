//
//  MineSunnySport.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/10/3.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit

class MineSunnySportView: MineCardContentView {

    let times = UILabel()
    let remainging = UILabel()
    let avgSpeed = UILabel()

    let viewHeight = 80

    let fontSize = 14 as CGFloat
    let textSize = 20 as CGFloat

    override func setupView() {
        super.setupView()
        self.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(viewHeight)
        }

        let sportRecordsLabel = UILabel()
        let remainingLabel = UILabel()
        let avgSpeedLabel = UILabel()


        self.addSubview(sportRecordsLabel)
        self.addSubview(times)
        self.addSubview(remainingLabel)
        self.addSubview(remainging)
        self.addSubview(avgSpeedLabel)
        self.addSubview(avgSpeed)

        sportRecordsLabel.font = UIFont.systemFont(ofSize: fontSize)
        sportRecordsLabel.textColor = HIColor.MineCardH2Color
        sportRecordsLabel.text = "mine_label_sunny_sport_records".localized()
        sportRecordsLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(self).offset(42)
            make.top.equalTo(self).offset(14)
        }

        remainingLabel.font = UIFont.systemFont(ofSize: fontSize)
        remainingLabel.textColor = HIColor.MineCardH2Color
        remainingLabel.text = "mine_label_sunny_sport_remaining".localized()
        remainingLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(sportRecordsLabel)
        }

        avgSpeedLabel.font = UIFont.systemFont(ofSize:
            fontSize)
        avgSpeedLabel.textColor = HIColor.MineCardH2Color
        avgSpeedLabel.text = "mine_label_sunny_sport_avg_speed".localized()
        avgSpeedLabel.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(self).offset(-42)
            make.top.equalTo(sportRecordsLabel)
        }

        times.font = UIFont.systemFont(ofSize: textSize)
        times.textColor = HIColor.MineCardTextColor
        times.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(sportRecordsLabel)
            make.top.equalTo(sportRecordsLabel.snp.bottom).offset(14)
        }

        remainging.font = UIFont.systemFont(ofSize: textSize)
        remainging.textColor = HIColor.MineCardTextColor
        remainging.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(remainingLabel)
            make.top.equalTo(times)
        }
        remainingLabel.isHidden = true

        avgSpeed.font = UIFont.systemFont(ofSize: textSize)
        avgSpeed.textColor = HIColor.MineCardTextColor
        avgSpeed.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(avgSpeedLabel)
            make.top.equalTo(times)
        }
    }

    //MARK:- out use
    func setData(_ info: MineRunning.RunningInfo) {
        times.text = String(info.times)
        var speedString = String(info.speed)
        if speedString.characters.count > 3 {
            speedString = speedString[speedString.startIndex...speedString.characters.index(speedString.startIndex, offsetBy: 3)]
        }
        avgSpeed.text = "\(speedString) m/s"
    }
}
