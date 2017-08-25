//
//  PostTableViewCell.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/14.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    var titleLable = UILabel()
    var icon = UILabel()
    var textView = UITextView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier:reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView(){
        self.addSubview(titleLable)
        self.addSubview(icon)
        self.addSubview(textView)
        titleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.top.equalTo(20)
            make.width.greaterThanOrEqualTo(73)
            make.height.greaterThanOrEqualTo(20)
            make.bottom.equalTo(-15)
            titleLable.textColor = UIColor(red: 162/255, green: 162/255, blue: 162/255, alpha: 1)
            titleLable.font = UIFont.systemFont(ofSize: 16)
        }
        
        icon.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLable.snp.trailing).offset(8)
            make.centerY.equalTo(titleLable)
            make.height.width.greaterThanOrEqualTo(3)
            icon.textColor = UIColor.red
            icon.text = "*"
            icon.font = UIFont.systemFont(ofSize: 15)
        }
        
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(icon.snp.trailing).offset(20)
            make.centerY.equalTo(titleLable)
            make.width.equalTo(100)
            make.height.greaterThanOrEqualTo(30)
            textView.font = UIFont.systemFont(ofSize: 15)
            textView.textAlignment = .left
            textView.isEditable = true
        }
       
    }

}
