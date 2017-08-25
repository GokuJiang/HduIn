//
//  SearchResultCell.swift
//  HduIn
//
//  Created by Kevin on 2017/1/21.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    var imageview = UIImageView()
    var title = LabelFactroy.createLabel(fontSize: 17, fontColor: UIColor.black)
    var author = LabelFactroy.createLabel(fontSize: 10, fontColor: UIColor.gray)
    
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
        self.addSubview(author)
        
        imageview.image = UIImage(named: "Selection-Search")
        imageview.contentMode = .scaleAspectFit
        imageview.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.width.height.equalTo(18)
            make.top.equalTo(20)
        }
        
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 13)
        title.snp.makeConstraints { (make) in
            make.leading.equalTo(imageview.snp.trailing).offset(12)
            make.centerY.equalTo(imageview)
            make.trailing.equalTo(-30)
        }
        
        //author.font = UIFont(name: ".PingFangSC-Regular", size: 10)
        author.textAlignment = .left
        author.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.equalTo(title).offset(1)
            make.height.equalTo(20)
            make.trailing.equalTo(-50)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
