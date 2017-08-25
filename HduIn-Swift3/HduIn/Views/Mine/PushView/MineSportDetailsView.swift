//
//  MineSportDetailsView.swift
//  HduIn
//
//  Created by Lucas Woo on 11/14/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class MineSportDetailsView: UIView {
    fileprivate let cardView = UIView()
    let totalLabel = UILabel()
    let recordsTable = UITableView()

    var dataSource: MineSportDetailsViewDataSource? {
        didSet {
            reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        self.backgroundColor = UIColor(hex: "f2f2f2")

        //
        cardView.backgroundColor = UIColor.white
        cardView.layer.cornerRadius = 3
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowRadius = 3
        cardView.layer.shadowOpacity = 0.25
        self.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(17 + 64)
            make.height.equalTo(63)
            make.left.equalTo(self).offset(22)
            make.right.equalTo(self).offset(-22)
        }

        let yourCountLabel = UILabel()
        yourCountLabel.text = "你已经跑了:"
        yourCountLabel.textColor = UIColor.black
        yourCountLabel.font = UIFont.systemFont(ofSize: 15)
        cardView.addSubview(yourCountLabel)
        yourCountLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView).offset(10)
            make.left.equalTo(cardView).offset(10)
        }

        let countLabel = UILabel()
        countLabel.text = "次"
        countLabel.textColor = UIColor.black
        countLabel.font = UIFont.systemFont(ofSize: 15)
        cardView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cardView).offset(-10)
            make.right.equalTo(cardView).offset(-10)
        }

        totalLabel.textColor = UIColor(hex: "0099cc")
        totalLabel.font = UIFont.systemFont(ofSize: 24)
        totalLabel.text = "加载中"
        cardView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.right.equalTo(countLabel).offset(-40)
            make.lastBaseline.equalTo(countLabel)
        }

        //
        let recordingLabel = UILabel()
        recordingLabel.text = "近期跑步情况🏃:"
        recordingLabel.textColor = UIColor.black
        recordingLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(recordingLabel)
        recordingLabel.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(30)
            make.left.equalTo(self).offset(25)
        }

        recordsTable.delegate = self
        recordsTable.dataSource = self
        recordsTable.backgroundColor = UIColor.clear
        recordsTable.isScrollEnabled = false
        recordsTable.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(recordsTable)
        recordsTable.snp.makeConstraints { make in
            make.top.equalTo(recordingLabel).offset(18)
            make.left.equalTo(self).offset(21)
            make.right.equalTo(self).offset(-27)
            make.bottom.equalTo(self)
        }

        let connectionLine = UIView()
        connectionLine.backgroundColor = UIColor(hex: "dcdcdc")
        connectionLine.layer.zPosition = -100
        self.addSubview(connectionLine)
        connectionLine.snp.makeConstraints { make in
            make.width.equalTo(1)
            make.top.equalTo(recordsTable.snp.top).offset(10)
            make.left.equalTo(28)
            make.bottom.equalTo(recordsTable)
        }
    }

    func reloadData() {
        if let dataSource = dataSource {
            totalLabel.text = String(dataSource.sportDetailsViewTotalCount(self))
            recordsTable.reloadData()
        }
    }
}

// MARK: - UITableView Delegate

extension MineSportDetailsView: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        return false
    }
}

// MARK: - UITableView DataSource

extension MineSportDetailsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.sportDetailsView(self, numberOfItemInTableView: tableView)
        } else {
            return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear

        let textColor = UIColor(hex: "4e4e4e")
        let textFont = UIFont.systemFont(ofSize: 14)

        let typeImage = UIImageView()
        cell.addSubview(typeImage)
        typeImage.snp.makeConstraints { make in
            make.top.equalTo(cell).offset(9)
            make.left.equalTo(cell).offset(4)
        }

        let dateLabel = UILabel()
        dateLabel.textColor = textColor
        dateLabel.font = textFont
        cell.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.lastBaseline.equalTo(typeImage)
            make.left.equalTo(typeImage.snp.right).offset(19)
        }

        let domainLabel = UILabel()
        domainLabel.textColor = textColor
        domainLabel.font = textFont
        cell.addSubview(domainLabel)
        domainLabel.snp.makeConstraints { (make) -> Void in
            make.lastBaseline.equalTo(dateLabel)
            make.leading.equalTo(dateLabel.snp.trailing).offset(2)
        }

        let speedLabel = UILabel()
        speedLabel.textColor = textColor
        speedLabel.font = textFont
        cell.addSubview(speedLabel)
        speedLabel.snp.makeConstraints { (make) -> Void in
            make.lastBaseline.equalTo(dateLabel)
            make.leading.equalTo(domainLabel.snp.trailing).offset(2)
        }

        let mileageLabel = UILabel()
        mileageLabel.textColor = textColor
        mileageLabel.font = textFont
        cell.addSubview(mileageLabel)
        mileageLabel.snp.makeConstraints { (make) -> Void in
            make.lastBaseline.equalTo(dateLabel)
            make.leading.equalTo(speedLabel.snp.trailing).offset(2)
        }

        if let record = dataSource?.sportDetailsView(self, itemAtIndexPath: indexPath) {
            if record.isValid {
                typeImage.image = UIImage(named: "Mine-RunningValid")
            } else {
                typeImage.image = UIImage(named: "Mine-RunningInvalid")
            }
            dateLabel.text = record.date.toString(format: .Custom("MM月dd日"))
            domainLabel.text = record.domain
            var speedString = String(record.speed)
            if speedString.characters.count > 3 {
                speedString = speedString[speedString.startIndex...speedString.characters.index(speedString
                    .startIndex, offsetBy: 3)]
            }
            speedLabel.text = "以 \(speedString) m/s"
            mileageLabel.text = "跑了 \(record.mileage) 米"
        }

        return cell
    }
}

// MARK: - MineSportDetailsViewDataSource

protocol MineSportDetailsViewDataSource {
    func sportDetailsViewTotalCount(_ sportDetailsView: MineSportDetailsView) -> Int

    func sportDetailsView(
        _ sportDetailsView: MineSportDetailsView,
        itemAtIndexPath indexPath: IndexPath
    ) -> MineRunning.RunningAchievement

    func sportDetailsView(
        _ sportDetailsView: MineSportDetailsView,
        numberOfItemInTableView tableView: UITableView
    ) -> Int
}
