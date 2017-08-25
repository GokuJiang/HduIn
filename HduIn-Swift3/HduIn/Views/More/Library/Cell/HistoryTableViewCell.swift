//
//  HistoryTableViewCell.swift
//  HduIn
//
//  Created by Kevin on 2017/1/16.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    var imageview = UIImageView()
    var title = LabelFactroy.createLabel(fontSize: 13, fontColor: UIColor.gray)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        self.addSubview(imageview)
        self.addSubview(title)
        
        imageview.image = UIImage(named: "Selection-Search")
        imageview.contentMode = .scaleAspectFit
        imageview.snp.makeConstraints { (make) in
            make.leading.equalTo(38)
            make.width.height.equalTo(13)
            make.top.equalTo(15)
        }
        
        title.textAlignment = .left
        title.textColor = UIColor.gray
        title.font = UIFont.systemFont(ofSize: 13)
        title.snp.makeConstraints { (make) in
            make.leading.equalTo(imageview.snp.trailing).offset(8)
            make.centerY.equalTo(imageview)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
