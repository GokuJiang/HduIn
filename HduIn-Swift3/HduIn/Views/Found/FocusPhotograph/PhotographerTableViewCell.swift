//
//  PhotographerTableViewCell.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit


let PhotographerCellIdentifier = "PhotographerCell"
class PhotographerTableViewCell: UITableViewCell {
    
    var nameLable = UILabel()
    var contentImages : [String]
    var avaterImage = UIImageView()
    var contentImageView = [UIImageView]()
    var tempImageView:UIImageView?
    
    init(images:[String]) {
        self.contentImages = images
        super.init(style: .default,reuseIdentifier: PhotographerCellIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        contentImages = []
        super.init(coder: aDecoder)
        
    }
    
    func setupView() {
        //add view
        self.contentView.addSubview(self.nameLable)
        self.contentView.addSubview(self.avaterImage)
        
        if contentImages.count != 0 {
            for i in 0..<contentImages.count {
                
                self.contentImageView.append(UIImageView())
                
                self.contentView.addSubview(contentImageView[i])
                
//                self.contentImageView[i].image = self.contentImages[i]
                self.contentImageView[i].yy_imageURL = URL(string: self.contentImages[i])
                
                contentImageView[i].snp.makeConstraints({ (make) in
                    make.top.equalTo(self.avaterImage.snp.bottom).offset(12)
                    let width = (UIScreen.main.bounds.size.width - 4 * 12) / 3
                    make.leading.equalTo(CGFloat(i) * width + CGFloat(12 * (i+1)))
                    make.width.equalTo(width)
                    make.height.equalTo(90)
                })
                
            }
        }
        self.nameLable.textColor = HIColor.hduBlack86
        
        
        
        //layout
        self.avaterImage.snp.makeConstraints { (make) in
            make.leading.equalTo(14)
            make.height.width.equalTo(50)
            make.top.equalTo(12)
            self.avaterImage.layer.cornerRadius = 25.0
            self.avaterImage.layer.masksToBounds = true
        }
        
        self.nameLable.snp.makeConstraints { (make) in
            make.leading.equalTo(self.avaterImage.snp.trailing).offset(10)
            make.top.equalTo(26)
            make.height.equalTo(16)
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
