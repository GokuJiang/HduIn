//
//  CyclePictureCell.swift
//  HduIn
//
//  Created by Goku on 16/01/2017.
//  Copyright © 2017 姜永铭. All rights reserved.
//

import UIKit
import UIKit

class CyclePictureCell: UICollectionViewCell {
    
    var imageSource: ImageSource = ImageSource.Local(name: ""){
        didSet {
            switch imageSource {
            case let .Local(name):
                self.imageView.image = UIImage(named: name)
            case let .Network(urlStr):
                if let encodeString = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    self.imageView.yy_setImage(with: URL(string: encodeString), placeholder: nil)
                }
            }
        }
    }
    
    var placeholderImage: UIImage?
    
    var imageDetail: NSAttributedString? {
        didSet {
            detailLable.isHidden = false
            detailLable.attributedText = imageDetail
        }
    }
    
    var timeDetail:String? {
        didSet{
            timeLabel.text = timeDetail
        }
    }
    
    var detailLableTextFont: UIFont = UIFont(name: RegularFontName, size: 18)! {
        didSet {
            detailLable.font = detailLableTextFont
        }
    }
    
    var detailLableTextColor: UIColor = UIColor.black.alpha(0.84) {
        didSet {
            detailLable.textColor = detailLableTextColor
        }
    }
    
    var detailLableBackgroundColor: UIColor = UIColor.clear {
        didSet {
            detailLable.backgroundColor = detailLableBackgroundColor
        }
    }
    
    var detailLableHeight: CGFloat = 60 {
        didSet {
            detailLable.frame.size.height = detailLableHeight
        }
    }
    
    var detailLableAlpha: CGFloat = 1 {
        didSet {
            detailLable.alpha = detailLableAlpha
        }
    }
    
    var pictureContentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            imageView.contentMode = pictureContentMode
        }
    }
    
    private var imageView =  UIImageView()
    private var detailLable =  UILabel()
    private var timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
    
        self.setupImageView()
        self.setupDetailLable()
    }
    
    private func setupImageView() {
        imageView.contentMode = pictureContentMode
        imageView.clipsToBounds = true
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.left.equalTo(8)
            make.trailing.equalTo(-8)
            make.height.equalTo(112*(SCREEN_WIDTH / 374.0))
        
        }
    }
    
    private func setupDetailLable() {
        detailLable.textColor = detailLableTextColor
        detailLable.numberOfLines = 0
        detailLable.backgroundColor = detailLableBackgroundColor
        self.addSubview(detailLable)
        detailLable.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(imageView)
        }
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.equalTo(imageView)
            timeLabel.font = UIFont(name: RegularFontName, size: 12)
            timeLabel.textColor = UIColor(hex: "000000").alpha(0.4)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
