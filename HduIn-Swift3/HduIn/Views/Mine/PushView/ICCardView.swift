//
//  ICCardView.swift
//  HduIn
//
//  Created by Lucas on 10/2/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class ICCardView: UIView {

    fileprivate let cardView = UIView()
    let remainingLabel = UILabel()
    let consumeTable = UITableView()
//    let lossReporting = UIButton()

    var delegate: ICCardViewDelegate?
    var dataSource: ICCardViewDataSource? {
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
        cardView.snp.makeConstraints {
            make in
            make.top.equalTo(self).offset(17 + 64)
            make.height.equalTo(63)
            make.left.equalTo(self).offset(22)
            make.right.equalTo(self).offset(-22)
        }

        let yourRemainingLabel = UILabel()
        yourRemainingLabel.text = "你的一卡通余额:"
        yourRemainingLabel.textColor = UIColor.black
        yourRemainingLabel.font = UIFont.systemFont(ofSize: 15)
        cardView.addSubview(yourRemainingLabel)
        yourRemainingLabel.snp.makeConstraints {
            make in
            make.top.equalTo(cardView).offset(10)
            make.left.equalTo(cardView).offset(10)
        }

        let yuanLabel = UILabel()
        yuanLabel.text = "元"
        yuanLabel.textColor = UIColor.black
        yuanLabel.font = UIFont.systemFont(ofSize: 15)
        cardView.addSubview(yuanLabel)
        yuanLabel.snp.makeConstraints {
            make in
            make.bottom.equalTo(cardView).offset(-10)
            make.right.equalTo(cardView).offset(-10)
        }

        remainingLabel.textColor = UIColor(hex: "0099cc")
        remainingLabel.font = UIFont.systemFont(ofSize: 24)
        remainingLabel.text = "加载中"
        cardView.addSubview(remainingLabel)
        remainingLabel.snp.makeConstraints {
            make in
            make.right.equalTo(yuanLabel).offset(-40)
            make.lastBaseline.equalTo(yuanLabel)
        }

        //
        let recordingLabel = UILabel()
        recordingLabel.text = "近期收支情况:"
        recordingLabel.textColor = UIColor.black
        recordingLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(recordingLabel)
        recordingLabel.snp.makeConstraints {
            make in
            make.top.equalTo(cardView.snp.bottom).offset(30)
            make.left.equalTo(self).offset(25)
        }

        consumeTable.delegate = self
        consumeTable.dataSource = self
        consumeTable.backgroundColor = UIColor.clear
        consumeTable.isScrollEnabled = false
        consumeTable.separatorStyle = UITableViewCellSeparatorStyle.none
        self.addSubview(consumeTable)
        consumeTable.snp.makeConstraints {
            make in
            make.top.equalTo(recordingLabel).offset(18)
            make.left.equalTo(self).offset(21)
            make.right.equalTo(self).offset(-27)
            make.bottom.equalTo(self)
        }

        let connectionLine = UIView()
        connectionLine.backgroundColor = UIColor(hex: "dcdcdc")
        connectionLine.layer.zPosition = -100
        self.addSubview(connectionLine)
        connectionLine.snp.makeConstraints {
            make in
            make.width.equalTo(1)
            make.top.equalTo(consumeTable.snp.top).offset(10)
            make.left.equalTo(28)
            make.bottom.equalTo(consumeTable)
        }
    }

    func reloadData() {
        if let dataSource = dataSource {
            remainingLabel.text = String(dataSource.iccardViewRemaining(self))
            consumeTable.reloadData()
        }
    }
}

// MARK: - UITableView Delegate

extension ICCardView: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        shouldHighlightRowAt indexPath: IndexPath
    ) -> Bool {
        return false
    }
}

// MARK: - UITableView DataSource

extension ICCardView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.iccardView(self, numberOfItemInTableView: tableView)
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

        let yuanLabel = UILabel()
        yuanLabel.textColor = textColor
        yuanLabel.font = textFont
        yuanLabel.text = "元"
        cell.addSubview(yuanLabel)
        yuanLabel.snp.makeConstraints { make in
            make.lastBaseline.equalTo(typeImage)
            make.trailing.equalTo(cell.snp.trailing)
        }

        let typeLabel = UILabel()
        typeLabel.textColor = textColor
        typeLabel.font = textFont
        cell.addSubview(typeLabel)
        typeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(yuanLabel.snp.leading).offset(-60)
            make.lastBaseline.equalTo(yuanLabel)
        }

        let amountLabel = UILabel()
        amountLabel.textColor = textColor
        amountLabel.font = textFont
        cell.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.lastBaseline.equalTo(typeLabel)
            make.trailing.equalTo(yuanLabel.snp.trailing).offset(-20)
        }

        if let record = dataSource?.iccardView(self, itemAtIndexPath: indexPath) {
            let amount = record.amount
            amountLabel.text = String(abs(amount))
            if amount > 0 {
                typeLabel.text = "充值:"
                typeImage.image = UIImage(named: "RightMenu-Recharge")
            } else {
                typeLabel.text = "消费:"
                typeImage.image = UIImage(named: "RightMenu-Consume")
            }

            dateLabel.text = record.date.toString(format: .Custom("yyyy-MM-dd, HH:mm"))
//            dateLabel.text = record.date.formatWithFormat("yyyy-MM-dd, HH:mm")
        }

        return cell
    }
}

// MARK: - ICCardViewDelegate

protocol ICCardViewDelegate {
    func iccardView(_ iccardView: ICCardView, didSelectLossReporting button: UIButton)
}

// MARK: - ICCardViewDataSource

protocol ICCardViewDataSource {
    func iccardViewRemaining(_ iccardView: ICCardView) -> Double

    func iccardView(
        _ iccardView: ICCardView,
        itemAtIndexPath indexPath: IndexPath
    ) -> MineICCard.ConsumeRecord

    func iccardView(_ iccardView: ICCardView, numberOfItemInTableView tableView: UITableView) -> Int
}
