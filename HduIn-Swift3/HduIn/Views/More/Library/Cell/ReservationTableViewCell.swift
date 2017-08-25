//
//  ReservationTableViewCell.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/26.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {

    var bgView = UIView()
    var bookNameLabel = LabelFactroy.createLabel(fontSize: 22, fontColor: UIColor.white)
    var authorNameLabel = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    var status = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(){
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.bookNameLabel)
        self.bgView.addSubview(self.authorNameLabel)
        self.bgView.addSubview(self.status)
        
        self.bgView.backgroundColor = UIColor(hex: "50b5ed")
        self.bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(11)
            make.bottom.equalTo(0)
            make.top.equalTo(10)
            make.trailing.equalTo(-11)
            self.bgView.layer.masksToBounds = true
            self.bgView.layer.cornerRadius = 10.0
        }
        
        self.authorNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.bgView.snp.leading).offset(16)
            make.top.equalTo(self.bgView.snp.top).offset(12)
            make.width.equalTo(150)
        }
        
        self.bookNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.authorNameLabel.snp.leading)
            make.bottom.equalTo(-33)
            make.width.equalTo(230)
            self.bookNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }

        self.status.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bgView.snp.bottom).offset(-12)
            make.trailing.equalTo(self.bgView.snp.trailing).offset(-18)
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
