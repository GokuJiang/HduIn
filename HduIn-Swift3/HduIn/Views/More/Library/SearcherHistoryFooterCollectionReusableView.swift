//
//  SearcherHistoryFooterCollectionReusableView.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/18.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class SearcherHistoryFooterCollectionReusableView: UICollectionReusableView {
    var lineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setView(){
        self.addSubview(self.lineView)
        
        self.lineView.backgroundColor = UIColor(red: 238.0 / 255, green: 238.0 / 255, blue: 238.0 / 255, alpha: 1.0)

        self.backgroundColor = UIColor.white
        
        self.lineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.height.equalTo(18)
        }
    }
}
