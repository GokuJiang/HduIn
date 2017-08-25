////
////  NewsCommonCell.swift
////  HduIn
////
////  Created by Lucas on 3/16/16.
////  Copyright © 2016 Redhome. All rights reserved.
////
//
//import UIKit
//
//class NewsCommonCell: NewsCellContainer {
//
//    static let reuseIdentifier = "NewsCommonCell"
//    static let cellHeight = 100 as CGFloat
//
//    let dateLabel = UILabel()
//    let sideImageView = UIImageView()
//    let titleLabel = UILabel()
//    let briefLabel = UILabel()
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        func setSelected(selected: Bool) {
//            if selected {
//                self.titleLabel.textColor = UIColor.whiteColor()
//                self.briefLabel.textColor = UIColor.whiteColor()
//                self.dateLabel.textColor = UIColor.whiteColor()
//            } else {
//                self.titleLabel.textColor = NewsDefinitions.NewsTitleColor
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
//
//        cardView.addSubview(dateLabel)
//        cardView.addSubview(titleLabel)
//        cardView.addSubview(sideImageView)
//        cardView.addSubview(briefLabel)
//
//        dateLabel.font = NewsDefinitions.textFont
//        dateLabel.textColor = NewsDefinitions.NewsTextColor
//        dateLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(titleLabel)
//            make.trailing.equalTo(cardView).offset(NewsDefinitions.CardContentTrailingInsect)
//            make.width.greaterThanOrEqualTo(50)
//        }
//
//        sideImageView.contentMode = .ScaleAspectFill
//        sideImageView.snp.makeConstraints { (make) -> Void in
//            make.size.equalTo(CGSize(width: 50, height: 50))
//            make.bottom.equalTo(cardView).offset(NewsDefinitions.CardContentBottomInsect)
//            make.trailing.equalTo(dateLabel)
//        }
//
//        titleLabel.numberOfLines = 2
//        titleLabel.font = NewsDefinitions.titleFont
//        titleLabel.textColor = NewsDefinitions.NewsTitleColor
//        titleLabel.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(cardView).offset(15)
//            make.leading.equalTo(cardView).offset(NewsDefinitions.CardContentLeadingInsect)
//            make.trailing.equalTo(cardView).offset(-125)
//        }
//
//        briefLabel.font = NewsDefinitions.textFont
//        briefLabel.textColor = NewsDefinitions.NewsTextColor
//        briefLabel.numberOfLines = 2
//        briefLabel.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(titleLabel)
//            make.top.equalTo(titleLabel.snp.bottom).offset(18)
//            make.bottom.equalTo(cardView.snp.bottom).offset(NewsDefinitions.CardContentBottomInsect)
//            make.trailing.equalTo(titleLabel)
//        }
//    }
//
//    func fillData(object: NewsPost) {
//        dateLabel.text = object.publishedDate.formatWithStyle(.ShortStyle)
//        if let imageURLString = object.imageURLString {
//            sideImageView.yy_setImageWithURL(NSURL(string: imageURLString), placeholder: nil)
//        }
//        let titleAttributed = NSMutableAttributedString(string: object.title)
//        titleAttributed.addAttribute(NSParagraphStyleAttributeName,
//            value: NewsDefinitions.paragraphStyle,
//            range: NSRange(location: 0, length: titleAttributed.length)
//        )
//        titleLabel.attributedText = titleAttributed
//        let briefAttributed = NSMutableAttributedString(string: object.brief)
//        briefAttributed.addAttribute(NSParagraphStyleAttributeName,
//            value: NewsDefinitions.paragraphStyle,
//            range: NSRange(location: 0, length: briefAttributed.length)
//        )
//        briefLabel.attributedText = briefAttributed
//    }
//
//}
