//
//  BookViewTableViewCell.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/23.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class BookViewTableViewCell: UITableViewCell {

    var bgView = UIView()
    var bookNameLabel = LabelFactroy.createLabel(fontSize: 18, fontColor: UIColor.white)
    var authorNameLabel = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    var lentDateLabel = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)    
    var deadLineLabel = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    var dateLabel = LabelFactroy.createLabel(fontSize: 12, fontColor: UIColor.white)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setLabel(){
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.bookNameLabel)
        self.bgView.addSubview(self.authorNameLabel)
        self.bgView.addSubview(self.lentDateLabel)
        self.bgView.addSubview(self.deadLineLabel)
        self.bgView.addSubview(self.dateLabel)
        
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
        }
        
        self.bookNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.authorNameLabel.snp.leading)
            make.bottom.equalTo(-33)
        }
        
        self.deadLineLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.bgView.snp.trailing).offset(-18)
            make.top.equalTo(self.bgView.snp.top).offset(12)
        }
        
        self.lentDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.deadLineLabel.snp.top)
            make.trailing.equalTo(self.deadLineLabel.snp.leading).offset(-2)
        }
        
        self.dateLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.bgView.snp.trailing).offset(-18)
            make.bottom.equalTo(self.bgView.snp.bottom).offset(-12)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
