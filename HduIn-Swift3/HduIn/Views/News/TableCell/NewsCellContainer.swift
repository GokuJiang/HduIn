////
////  NewsCellContainer.swift
////  HduIn
////
////  Created by Lucas Woo on 3/21/16.
////  Copyright © 2016 Redhome. All rights reserved.
////
//
//import UIKit
//
//class NewsCellContainer: UITableViewCell {
//
//    static let selectionAnimationDuration = 0.3 as NSTimeInterval
//
//    let cardView = UIView()
//
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        func setSelected(selected: Bool) {
//            if selected {
//                self.cardView.backgroundColor = UIColor.lightGrayColor()
//            } else {
//                self.cardView.backgroundColor = NewsDefinitions.CardBackgroundColor
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
//    func setupView() {
//        self.backgroundColor = UIColor.clearColor()
//
//        cardView.layer.cornerRadius = 3
//        cardView.layer.masksToBounds = true
//        cardView.backgroundColor = NewsDefinitions.CardBackgroundColor
//        self.addSubview(cardView)
//        cardView.snp.makeConstraints { (make) -> Void in
//            make.leading.equalTo(self).offset(6)
//            make.trailing.equalTo(self).offset(-6)
//            make.top.equalTo(self).offset(3)
//            make.bottom.equalTo(self).offset(-3)
//        }
//    }
//
//}
