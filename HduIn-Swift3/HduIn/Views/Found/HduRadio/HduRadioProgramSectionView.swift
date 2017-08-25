//
//  HduRadioProgramSectionView.swift
//  HduIn
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class HduRadioProgramSectionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var title = UILabel()
    var totalIssue = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.title)
        self.addSubview(self.totalIssue)
        
        //set color
        self.totalIssue.textColor = UIColor(white: 57.0 / 255.0, alpha: 0.6)
        self.title.textColor = HIColor.MidBlue
        
        self.backgroundColor = UIColor(red: 243.0 / 255.0, green: 243.0 / 255.0, blue: 243.0 / 255.0, alpha: 1)
        
        self.totalIssue.font = UIFont.boldSystemFont(ofSize: 12)
        
        //layout
        self.title.snp.makeConstraints{(make) in
            make.leading.equalTo(16)
            make.top.trailing.bottom.equalTo(0)
        }
        
        self.totalIssue.snp.makeConstraints { (make) in
            make.leading.equalTo(314)
            make.trailing.top.bottom.equalTo(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
