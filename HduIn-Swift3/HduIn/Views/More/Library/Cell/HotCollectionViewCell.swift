//
//  HotTableViewCell.swift
//  HduIn
//
//  Created by Kevin on 2017/1/17.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class HotCollectionViewCell: UICollectionViewCell {

    var number = LabelFactroy.createLabel(fontSize: 13, fontColor: UIColor.gray)
    var title = LabelFactroy.createLabel(fontSize: 13, fontColor: UIColor.darkGray)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        self.addSubview(title)
        self.addSubview(number)
        
        
        number.textAlignment = .left
        number.snp.makeConstraints { (make) in
            make.leading.equalTo(30)
            make.bottom.equalTo(-5)
            make.width.equalTo(16)
            make.top.equalTo(5)
        }
        
        title.textAlignment = .left
        title.snp.makeConstraints { (make) in
            make.leading.equalTo(number.snp.trailing).offset(5)
            make.bottom.equalTo(number)
            make.trailing.equalTo(-15)
            make.top.equalTo(number)
        }
        
    }
    
    
}
