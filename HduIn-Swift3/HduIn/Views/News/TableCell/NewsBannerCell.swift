////
////  NewsBannerCell.swift
////  HduIn
////
////  Created by Lucas on 3/16/16.
////  Copyright © 2016 Redhome. All rights reserved.
////
//
//import UIKit
//
//class NewsBannerCell: NewsCellContainer {
//
//    static let reuseIdentifier = "NewsBannerCell"
//    static func cellHeightForWidth(width: CGFloat) -> CGFloat {
//        return width / NewsDefinitions.BannerImageAspectRatio + 61
//    }
//
//    let dateLabel = UILabel()
//    let titleImageView = UIImageView()
//    let titleLabel = UILabel()
//    let briefLabel = UILabel()
//
//    let downUpGradient = [
//        UIColor.clearColor(),
//        UIColor.clearColor(),
//        UIColor.blackColor().alpha(0.38)
//    ].gradient()
//
//    let upDownGradient = [
//        UIColor.blackColor().alpha(0.2),
//        UIColor.clearColor()
//    ].gradient()
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.downUpGradient.frame = titleImageView.frame
//        self.upDownGradient.frame = titleImageView.frame
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        func setSelected(selected: Bool) {
//            if selected {
//                self.briefLabel.textColor = UIColor.whiteColor()
//                self.dateLabel.textColor = UIColor.whiteColor()
//            } else {
//                self.briefLabel.textColor = NewsDefinitions.NewsTextColor
//                self.dateLabel.textColor = NewsDefinitions.NewsTextColor
//            }
//        }
//
//        if animated {
//            UIView.animateWithDuration(NewsCellContainer.selectionAnimationDuration) {
//                setSelected(selected)
//            }
//        } else {
//            setSelected(selected)
//        }
//    }
//
//    override func setupView() {
//        super.setupView()
//        cardView.addSubview(titleImageView)
//        cardView.layer.addSublayer(downUpGradient)
//        cardView.layer.addSublayer(upDownGradient)
//
//        cardView.addSubview(dateLabel)
//        cardView.addSubview(titleLabel)
//        cardView.addSubview(briefLabel)
//
//        titleImageView.contentMode = .ScaleAspectFill
//        titleImageView.layer.masksToBounds = true
//        titleImageView.snp.makeConstraints { (make) -> Void in
//            make.width.equalTo(cardView)
//            make.height.equalTo(cardView.snp.width)
//                .dividedBy(NewsDefinitions.BannerImageAspectRatio)
//            make.top.equalTo(cardView)
//            make.leading.equalTo(cardView)
//        }
//
//        dateLabel.font = NewsDefinitions.textFont
//        dateLabel.textColor = NewsDefinitions.NewsTextColor
//        dateLabel.snp.makeConstraints { (make) -> Void in
//            make.trailing.equalTo(cardView).offset(NewsDefinitions.CardContentTrailingInsect)
//            make.top.equalTo(briefLabel)
//            make.width.greaterThanOrEqualTo(50)
//        }
//
//        titleLabel.font = NewsDefinitions.titleFont
//        titleLabel.textColor = NewsDefinitions.BannerTitleColor
//        titleLabel.snp.makeConstraints { (make) -> Void in
//            make.bottom.equalTo(titleImageView.snp.bottom).offset(-10)
//            make.leading.equalTo(cardView).offset(NewsDefinitions.CardContentLeadingInsect)
//            make.trailing.equalTo(cardView).offset(-125)
//        }
//
//        briefLabel.numberOfLines = 2
//        briefLabel.font = NewsDefinitions.textFont
//        briefLabel.textColor = NewsDefinitions.BannerTextColor
//        briefLabel.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(titleLabel)
//            make.top.equalTo(titleImageView.snp.bottom).offset(12)
//            make.trailing.equalTo(titleLabel).offset(-10)
//        }
//    }
//
//    func fillData(object: NewsPost) {
//        dateLabel.text = object.publishedDate.formatWithStyle(.ShortStyle)
//        if let imageURLString = object.imageURLString {
//            titleImageView.yy_setImageWithURL(NSURL(string: imageURLString), placeholder: nil)
//        }
//        titleLabel.text = object.title
//        briefLabel.text = object.brief
//    }
//
//}
