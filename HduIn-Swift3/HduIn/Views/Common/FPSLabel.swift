//
//  FPSLabel.swift
//  HduIn
//
//  Created by huangfeng on 1/15/16.
//  Copyright © 2016 Fin. All rights reserved.
//

import UIKit

//重写自 YYFPSLabel
//https://github.com/ibireme/YYText/blob/master/Demo/YYTextDemo/YYFPSLabel.m

class FPSLabel: UILabel {
    fileprivate var link: CADisplayLink?
    fileprivate var count: Int = 0
    fileprivate var lastTime: TimeInterval = 0

    fileprivate let defaultSize = CGSize(width: 55, height: 20)

    static let sharedInstance = FPSLabel()

    override init(frame: CGRect) {
        var _frame = frame
        if _frame.size.width == 0 && _frame.size.height == 0 {
            _frame.size = defaultSize
        }
        super.init(frame: _frame)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = .center
        self.isUserInteractionEnabled = false
        self.textColor = UIColor.white
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.font = UIFont(name: "Menlo", size: 14)
        weak var weakSelf = self
        link = CADisplayLink(target: weakSelf!, selector: #selector(FPSLabel.tick(_:)))
        link!.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func tick(_ link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }

        count = (count + 1)
        let delta = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0

        let progress = fps / 60.0
        self.textColor = UIColor(
            hue: CGFloat(0.27 * (progress - 0.2)),
            saturation: 1,
            brightness: 0.9,
            alpha: 1
        )
        self.text = "\(Int(fps + 0.5))FPS"
    }
}
