//
//  FoundTableViewCell.swift
//  HduIn
//
//  Created by Goku on 16/01/2017.
//  Copyright © 2017 姜永铭. All rights reserved.
//

import UIKit


public let foundcellIdnetifier = "FountTableViewCell"
class FoundTableViewCell: UITableViewCell {

    var titleLabel = UILabel()
    var detailLabel = UILabel()
    var timeLabel = UILabel()
    var contentImageView = UIImageView()
    
    init(){
        super.init(style: .default, reuseIdentifier: foundcellIdnetifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 16, y: rect.size.height - 1))
        path.addLine(to: CGPoint(x: rect.size.width  - 16, y: rect.size.height - 1))
        path.lineWidth = 0.5
        path.close()
        UIColor(hex: "d6d6d6").set()
        path.stroke()
        path.fill()
    }
    
    
    private func setupView() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(detailLabel)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(contentImageView)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.leading.equalTo(16)
            make.width.equalTo(178)
            titleLabel.numberOfLines = 0
        }
        detailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.bottom.equalTo(-12)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(243 * ratioWidth)
            detailLabel.font = UIFont(name: RegularFontName, size: 14)
            detailLabel.textColor = UIColor(hex: "090909").alpha(0.6)
            detailLabel.numberOfLines = 0
        }
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(13)
            make.trailing.equalTo(-15)
            timeLabel.font = UIFont(name: RegularFontName, size: 12)
            timeLabel.textColor = UIColor(hex: "000000").alpha(0.5)
        }
        contentImageView.snp.makeConstraints { (make) in
            make.bottom.equalTo(detailLabel)
            make.trailing.equalTo(timeLabel)
            make.width.height.equalTo(50)
            make.top.greaterThanOrEqualTo(timeLabel.snp.bottom).offset(6)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
