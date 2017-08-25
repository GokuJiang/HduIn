//
//  SelectionSelectedCell.swift
//  HduIn
//
//  Created by 姜永铭 on 15/12/12.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit

class SelectionSelectedCell: UITableViewCell {

    var courseNameLabel = UILabel()
    var courseIDLabel = UILabel()
    var line = UIView()
    var placeLabel = UILabel()
    var teacherLabel = UILabel()
    var creditLabel = UILabel()
    var timeLabel = UILabel()
    var selecteButton = UIButton(type: UIButtonType.custom)
    var _isEditing: Bool = false

    weak var delegate: selectionSelectedCellDelegate?

    // color
    let hduInBlue = UIColor(
        red: 52.0 / 255.0,
        green: 152.0 / 255.0,
        blue: 219.0 / 255.0,
        alpha: 1
    )
    let hduInLightGray = UIColor(
        red: 171.0 / 255.0,
        green: 171.0 / 255.0,
        blue: 171.0 / 255.0,
        alpha: 1
    )
    let hduInGray = UIColor(
        red: 112.0 / 255.0,
        green: 112.0 / 255.0,
        blue: 112.0 / 255.0,
        alpha: 1
    )
    let hduLineGray = UIColor(
        red: 219.0 / 255.0,
        green: 219.0 / 255.0,
        blue: 219.0 / 255.0,
        alpha: 1
    )
    let hduInRed = UIColor(
        red: 231.0 / 255.0,
        green: 76.0 / 255.0,
        blue: 60.0 / 255.0,
        alpha: 1
    )

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    fileprivate func setupView() {
        self.addSubview(courseNameLabel)
        self.addSubview(courseIDLabel)
        self.addSubview(line)
        self.addSubview(placeLabel)
        self.addSubview(teacherLabel)
        self.addSubview(creditLabel)
        self.addSubview(timeLabel)
        self.addSubview(selecteButton)

        selecteButton.addTarget(
            self,
            action: #selector(SelectionSelectedCell.deleteCourse(sender:)),
            for: .touchUpInside
        )
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor.white

        courseNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(19)
            make.leading.equalTo(self).offset(16)
            self.courseNameLabel.textColor = hduInBlue
            self.courseNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        }
        courseIDLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(22)
            make.right.equalTo(self).offset(-15)
            self.courseIDLabel.textColor = hduInLightGray
            self.courseIDLabel.font = UIFont.boldSystemFont(ofSize: 10)
        }
        line.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.courseNameLabel).offset(20)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.height.equalTo(1)
            self.line.backgroundColor = hduLineGray
        }
        placeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.line).offset(13)
            make.left.equalTo(self).offset(33)
            self.placeLabel.font = UIFont.boldSystemFont(ofSize: 11)
            self.placeLabel.textColor = hduInGray
        }

        creditLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.line).offset(13)
            make.trailing.equalTo(-15)
            self.creditLabel.font = UIFont.boldSystemFont(ofSize: 11)
            self.creditLabel.textColor = hduInGray
        }

        teacherLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.placeLabel).offset(20)
            make.leading.equalTo(self).offset(33)
            self.teacherLabel.font = UIFont.boldSystemFont(ofSize: 11)
            self.teacherLabel.textColor = hduInGray
        }

        timeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.creditLabel).offset(20)
            make.trailing.equalTo(-15)
            self.timeLabel.font = UIFont.boldSystemFont(ofSize: 11)
            self.timeLabel.textColor = hduInGray
        }

        selecteButton.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(-10)
            make.trailing.equalTo(-15)
            make.height.equalTo(24)
            make.width.equalTo(38)
            selecteButton.setTitle("退选", for: UIControlState.normal)
            selecteButton.setTitleColor(UIColor.white, for: .normal)
            selecteButton.setTitleColor(hduInRed, for: .selected)
            selecteButton.tintColor = UIColor.white
            selecteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 11)
            selecteButton.backgroundColor = hduInRed
            selecteButton.layer.borderColor = hduInRed.cgColor
            selecteButton.layer.cornerRadius = 5.0
        }
        log.debug("\(self.selecteButton.frame)")
    }

    func deleteCourse(sender:UIButton) {
        if sender.isSelected {
            selecteButton.isSelected = false
            selecteButton.backgroundColor = hduInRed
        } else {
            selecteButton.isSelected = true
            selecteButton.backgroundColor = UIColor.white
        }
        self.delegate?.selectionSelectedCell(didSelected: sender)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
    }
}

protocol selectionSelectedCellDelegate: class {
    func selectionSelectedCell(didSelected sender: UIButton)
}
