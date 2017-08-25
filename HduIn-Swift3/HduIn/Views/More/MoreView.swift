//
//  MoreView.swift
//  HduIn
//
//  Created by Lucas Woo on 3/9/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import UIKit
import Static

class MoreView: UITableView {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        self.backgroundColor = HIColor.MoreBackground
        self.bounces = false
        self.separatorStyle = .none
    }

}


class ProfileCell: UIImageView {

    var selection: (() -> ())? = nil

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let staffTypeLabel = UILabel()
    let staffIdLabel = UILabel()

    let disclosure = UIButton()

    let textColor = UIColor.black

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    convenience init(frame: CGRect, selection: @escaping () ->()) {
        self.init(frame: frame)
        self.selection = selection
    }

    func setupView() {
        self.image = UIImage(named: "More-ProfileBackground")
        self.isUserInteractionEnabled = true

        let avatarImageBorder = UIView()

        self.addSubview(avatarImageBorder)
        self.addSubview(avatarImageView)
        self.addSubview(nameLabel)
        self.addSubview(staffTypeLabel)
        self.addSubview(staffIdLabel)
        self.addSubview(disclosure)

        avatarImageBorder.backgroundColor = UIColor.white
        avatarImageBorder.layer.cornerRadius = 32
        avatarImageBorder.snp.makeConstraints { make in
            
            make.size.equalTo(CGSize(width: 64, height: 64))
            make.leading.equalTo(self).offset(22)
            make.top.equalTo(self).offset(22)
        }

        avatarImageView.image = UIImage(named: "More-Avatar")
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.layer.masksToBounds = true
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 60, height: 60))
            make.center.equalTo(avatarImageBorder)
        }

        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = textColor.alpha(0.87)
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(avatarImageBorder.snp.trailing).offset(12)
            make.top.equalTo(self).offset(36)
        }

        staffTypeLabel.font = UIFont.systemFont(ofSize: 14)
        staffTypeLabel.textColor = textColor.alpha(0.54)
        staffTypeLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel.snp.trailing).offset(12)
            make.top.equalTo(nameLabel)
        }

        staffIdLabel.font = UIFont.systemFont(ofSize: 14)
        staffIdLabel.textColor = textColor.alpha(0.54)
        staffIdLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        disclosure.setImage(UIImage(named: "More-Disclosure"), for: .normal)
        disclosure.addTarget(self,
            action: #selector(ProfileCell.viewTap(gesture:)),
            for: .touchUpInside
        )
        disclosure.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(42)
            make.trailing.equalTo(self).offset(-17)
        }


        nameLabel.text = UserModel.staffName
        staffIdLabel.text = UserModel.staffId
        if let staffType = UserModel.staffType {
            staffTypeLabel.text = "label_\(staffType.rawValue.lowercased())".localized()
        }
    }

    func viewTap(gesture: UITapGestureRecognizer) {
        selection?()
    }
}
extension MoreView {
    class CommonCell: UITableViewCell,Cell {

        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        func setupView() {
            let seperator = UIView()
            seperator.backgroundColor = HIColor.LightGrey
            seperator.alpha = 0.28
            self.addSubview(seperator)
            seperator.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(self)
                make.height.equalTo(1)
                make.bottom.equalTo(self)
                make.centerX.equalTo(self)
            }

            self.imageView?.contentMode = .scaleAspectFit
        }

        func configure(_ row: Row) {
            textLabel?.text = row.text
            detailTextLabel?.text = row.detailText
            imageView?.image = row.image
            accessoryType = Row.Accessory.disclosureIndicator.type
            accessoryView = Row.Accessory.disclosureIndicator.view
            if row.selection == nil {
                self.setUnselectable()
            }
        }

        func setUnselectable() {
            textLabel?.textColor = HIColor.LightGrey
        }
    }

    class CellSpacingView: UIView {
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.frame = CGRect(x: 0, y: 0, width: 0, height: 20)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }

}
