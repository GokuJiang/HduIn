//
//  SelectionPETypeCell.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionPETypeCell: UICollectionViewCell {

    let imageView = UIImageView()
    let textLabel = UILabel()
    let shadowView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {

        shadowView.layer.cornerRadius = 6
        shadowView.backgroundColor = UIColor(hex: "f6f6f6")
        self.addSubview(shadowView)
        shadowView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 48, height: 37))
            make.top.equalTo(self).offset(6)
            make.centerX.equalTo(self)
        }
        shadowView.isHidden = true

        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 22, height: 22))
            make.center.equalTo(shadowView)
        }

        textLabel.textColor = UIColor(hex: "929292")
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(shadowView.snp.bottom).offset(3)
        }

        self.isUserInteractionEnabled = true
    }

    func performSelectionAnimation() {
        UIView.animate(withDuration: 0.18, animations: {
            self.imageView.isHighlighted = true
            self.shadowView.isHidden = false
        }) 
    }

    func performDeselectionAnimation() {
        UIView.animate(withDuration: 0.18, animations: {
            self.imageView.isHighlighted = false
            self.shadowView.isHidden = true
        }) 
    }
}
