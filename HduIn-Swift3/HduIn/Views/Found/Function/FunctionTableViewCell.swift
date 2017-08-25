//
//  FunctionTableViewCell.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/3/8.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class FunctionTableViewCell: UITableViewCell {

    var bgView = UIView()
    var funLabel = UILabel()
    var explainLabel = UILabel()
    var myImageView = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLabel() {
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.funLabel)
        self.bgView.addSubview(self.explainLabel)
        self.bgView.addSubview(self.myImageView)
        
        
        self.funLabel.textColor = UIColor.white
        self.explainLabel.textColor = UIColor.white
        
        self.funLabel.font = UIFont(name: ".PingFangSC-Medium", size: 17)
        self.explainLabel.font = UIFont(name: ".PingFangSC-Medium", size: 12)
    
        self.bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
            make.bottom.equalTo(0)
            make.top.equalTo(19)
//            self.bgView.layer.cornerRadius = 7.0
//            self.bgView.layer.masksToBounds = true
        }
        
        self.myImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(21)
            make.width.height.equalTo(38)
        }
        
        self.funLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.bgView.snp.leading).offset(80)
            make.top.equalTo(self.bgView.snp.top).offset(19)
        }
        
        self.explainLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.funLabel.snp.leading).offset(0)
            make.bottom.equalTo(self.bgView.snp.bottom).offset(-14)
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
