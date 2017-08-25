//
//  MineCardContainer.swift
//  HduIn
//
//  Created by Lucas Woo on 1/2/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import UIKit

class MineCardContainer: UIView {

    var title: String? {
        get { return titleView.titleLabel.text }
        set { titleView.titleLabel.text = newValue }
    }
    var image: UIImage? {
        get { return titleView.imageView.image }
        set { titleView.imageView.image = newValue }
    }
    var action: (String, () ->())? = nil {
        didSet {
            guard let action = action else {
                titleView.action = nil
                return
            }
            let (title, closure) = action
            titleView.addDisclosure(title, closure: closure)
        }
    }

    var titleView = MineCardTitleView()
    var contentView = MineCardContentView() {
        willSet {
            contentView.removeFromSuperview()
        }
        didSet {
            self.addSubview(contentView)
            contentView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(self)
                make.top.equalTo(titleView.snp.bottom).offset(1)
                make.centerX.equalTo(self)
                make.bottom.equalTo(self)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        self.backgroundColor = UIColor.clear

        self.layer.cornerRadius = Size.cornerRadius
        self.layer.masksToBounds = true

        self.addSubview(titleView)
        titleView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
        }
    }

}

class  MineCardTitleView: UIView {
     let titleLabel = UILabel()
     let imageView = UIImageView()
     let disclosure = UIButton()
    var action: (() -> ())? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        self.backgroundColor = HIColor.MineCardBackground

        self.addSubview(titleLabel)
        self.addSubview(imageView)

        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.leading.equalTo(self).offset(14)
            make.top.equalTo(self).offset(18)
            make.bottom.equalTo(self).offset(-18)
        }

        titleLabel.textColor = HIColor.MineCardTitleColor
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.centerY.equalTo(imageView)
        }
    }

    func addDisclosure(_ title: String, closure: @escaping () -> ()) {
        self.addSubview(disclosure)
        disclosure.addTarget(self,
                             action: #selector(MineCardTitleView.disclosureClicked(_ :)),
                             for: .touchUpInside
        )
        disclosure.setImage(UIImage(named: "Mine-Disclosure"), for: .normal)
        disclosure.imageView?.snp.makeConstraints({ (make) -> Void in
            make.leading.equalTo(disclosure.snp.trailing).offset(8)
            make.centerY.equalTo(disclosure)
        })
        disclosure.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        disclosure.setTitleColor(HIColor.MineCardH2Color, for: .normal)
        disclosure.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(self).offset(-24)
            make.centerY.equalTo(self)
        }

        disclosure.setTitle(title, for: .normal)
        action = closure
    }

    func disclosureClicked(_ sender: UIButton) {
        action?()
    }
}

class MineCardContentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        self.backgroundColor = HIColor.MineCardBackground
    }
}


extension MineCardContainer {
    struct Size {
        static let cornerRadius = 8 as CGFloat

        static let titleViewHeight = 48
    }
}
