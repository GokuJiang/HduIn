//
//  SelectionCourseCell.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionCourseCell: UITableViewCell {

    weak var delegate: SelectionCourseCellDelegate?

    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let teacherLabel = UILabel()
    let remainingLabel = UILabel()
    let totalLabel = UILabel()

    let actionButton = UIButton(type: UIButtonType.system)

    fileprivate let staredImageView = UIImageView()
    var stared = false {
        didSet {
            if stared {
                staredImageView.isHidden = false
            } else {
                staredImageView.isHidden = true
            }
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        let normalColor = UIColor(hex: "555555")
        let textFont = UIFont.systemFont(ofSize: 14)

        actionButton.tintColor = UIColor(hex: "929292")
        actionButton.setImage(UIImage(named: "Selection-Action"), for: .normal)
        actionButton.addTarget(
            self,
            action: #selector(SelectionCourseCell.actionButtonTapped(_ :)),
            for: .touchUpInside
        )
        self.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(13)
            make.trailing.equalTo(self).offset(-12)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }

        nameLabel.textColor = UIColor(hex: "3498db")
        nameLabel.font = textFont
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(actionButton)
            make.trailing.lessThanOrEqualTo(actionButton.snp.leading).offset(5)
            make.leading.equalTo(self).offset(47)
        }

        timeLabel.textColor = normalColor
        timeLabel.font = textFont
        self.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp.bottom).offset(11)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(actionButton)
        }

        totalLabel.textColor = normalColor
        totalLabel.font = textFont
        self.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(timeLabel.snp.bottom).offset(9)
            make.trailing.equalTo(self).offset(-22)
        }

        let slashLabel = UILabel()
        slashLabel.textColor = normalColor
        slashLabel.font = textFont
        slashLabel.text = "/"
        self.addSubview(slashLabel)
        slashLabel.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(totalLabel.snp.leading)
            make.top.equalTo(totalLabel)
        }

        remainingLabel.textColor = normalColor
        remainingLabel.font = textFont
        self.addSubview(remainingLabel)
        remainingLabel.snp.makeConstraints { (make) -> Void in
            make.trailing.equalTo(slashLabel.snp.leading)
            make.top.equalTo(totalLabel)
        }

        teacherLabel.textColor = normalColor
        teacherLabel.font = textFont
        self.addSubview(teacherLabel)
        teacherLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(totalLabel)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(remainingLabel).offset(5)
        }

        staredImageView.image = UIImage(named: "Selection-Stared")
        self.addSubview(staredImageView)
        staredImageView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(nameLabel.snp.trailing)
            make.top.equalTo(nameLabel)
        }
        staredImageView.isHidden = true

        let seperator = UIView()
        seperator.backgroundColor = UIColor(hex: "ededed")
        self.addSubview(seperator)
        seperator.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(self).offset(-47)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
            make.leading.equalTo(nameLabel)
        }
    }

    func actionButtonTapped(_ sender: UIButton) {
        delegate?.courseCell(self, actionButtonTapped: sender)
    }
}

extension SelectionCourseCell: SelectionPopActionViewControllerDelegate {
    func actionViewStarAction(
        _ actionView: SelectionPopActionViewController,
        starButton button: UIButton
    ) {
        delegate?.courseCellStarAction(self, actionView: actionView, starButton: button)
    }

    func actionViewDetailsAction(
        _ actionView: SelectionPopActionViewController,
        detailsButton button: UIButton
    ) {
        delegate?.courseCellShowDetailsAction(self, actionView: actionView, detailsButton: button)
    }
}

protocol SelectionCourseCellDelegate: class {
    func courseCell(_ courseCell: SelectionCourseCell, actionButtonTapped button: UIButton)

    func courseCellShowDetailsAction(
        _ courseCell: SelectionCourseCell,
        actionView: SelectionPopActionViewController,
        detailsButton: UIButton
    )

    func courseCellStarAction(
        _ courseCell: SelectionCourseCell,
        actionView: SelectionPopActionViewController,
        starButton: UIButton
    )
}
