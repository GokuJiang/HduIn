////
////  NewsHybridCell.swift
////  HduIn
////
////  Created by Lucas on 3/16/16.
////  Copyright © 2016 Redhome. All rights reserved.
////
//
//import UIKit
//
//class NewsHybridCell: NewsCellContainer {
//
//    static let reuseIdentifier = "NewsHybridCell"
//    static func cellHeightForWidth(width: CGFloat) -> CGFloat {
//        return width / NewsDefinitions.HybridImageAspectRatio
//    }
//
//    let backgroundImage = UIImageView()
//
//    override func setupView() {
//        super.setupView()
//
//        cardView.addSubview(backgroundImage)
//
//        backgroundImage.contentMode = .ScaleAspectFill
//        backgroundImage.layer.masksToBounds = true
//        backgroundImage.snp.makeConstraints { (make) -> Void in
//            make.size.equalTo(cardView)
//            make.center.equalTo(cardView)
//        }
//    }
//
//    func fillData(object: NewsPost) {
//        if let imageURLString = object.imageURLString {
//            backgroundImage.yy_setImageWithURL(NSURL(string: imageURLString), placeholder: nil)
//        }
//    }
//
//}
