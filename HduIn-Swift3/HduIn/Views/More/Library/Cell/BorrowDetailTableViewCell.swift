//
//  BorrowDetailTableViewCell.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/14.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class BorrowDetailTableViewCell: UITableViewCell {

    var bgView = UIView()
    var campusLabel = UILabel()
    var detialLabel = UILabel()
    var statusLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }
    
    func setView() {
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.campusLabel)
        self.bgView.addSubview(self.detialLabel)
        self.bgView.addSubview(self.statusLabel)
        
        //set color
        self.campusLabel.textColor = UIColor(hex: "6c6c6c")
        self.detialLabel.textColor = UIColor(hex: "6c6c6c")
        self.statusLabel.textColor = UIColor(hex: "6c6c6c")
        self.bgView.backgroundColor = UIColor(red: 240.0 / 255, green: 240.0 / 255, blue: 240.0 / 255, alpha: 1.0)
        
        //set font
//        self.campusLabel.font = UIFont.systemFont(ofSize: 12)
        self.campusLabel.font = UIFont.systemFont(ofSize: 12, weight: 10)
        self.detialLabel.font = UIFont.systemFont(ofSize: 12, weight: 10)
        self.statusLabel.font = UIFont.systemFont(ofSize: 12, weight: 10)
        
        //layout
        self.bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(22)
            make.trailing.equalTo(-22)
            make.top.equalTo(0)
            make.bottom.equalTo(-14)
            self.bgView.layer.cornerRadius = 10.0
            self.bgView.layer.masksToBounds = true
        }
        
        self.campusLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.bgView.snp.leading).offset(15)
            make.top.equalTo(self.bgView.snp.top).offset(27)
        }
        
        self.detialLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp.top).offset(17)
            make.leading.equalTo(self.bgView.snp.leading).offset(123)
            make.bottom.equalTo(self.bgView.snp.bottom).offset(-12)
        }
        
        self.statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.bgView.snp.top).offset(27)
            make.trailing.equalTo(self.bgView.snp.trailing).offset(-28)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
