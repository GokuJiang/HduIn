//
//  MineExamScoreView.swift
//  HduIn
//
//  Created by Lucas Woo on 5/26/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import UIKit
import RealmSwift

class MineExamScoreView: MineCardContentView {
    var courses: [MineExam.ScoreRecord]? = nil

    let coursesTable = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)

    let courseCellIdentity = "CourseCell"

    // MARK:- out use
    func setData(_ results: [MineExam.ScoreRecord]) {
        courses = results
        coursesTable.reloadData()
        self.setNeedsUpdateConstraints()
        self.coursesTable.alpha = 0.24
        UIView.animate(withDuration: 0.42) { () -> Void in
            self.coursesTable.alpha = 1
        }
    }

    // MARK:- parivate functions
    override func setupView() {
        super.setupView()

        coursesTable.register(CourseCell.self, forCellReuseIdentifier: courseCellIdentity)
        coursesTable.dataSource = self
        coursesTable.delegate = self
        coursesTable.rowHeight = 34
        coursesTable.allowsSelection = false
        coursesTable.showsVerticalScrollIndicator = false
        coursesTable.separatorColor = HIColor.HduInBlue

        coursesTable.backgroundColor = UIColor.clear
        coursesTable.isScrollEnabled = false
        self.addSubview(coursesTable)
        coursesTable.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.height.greaterThanOrEqualTo(coursesTable.contentSize.height)
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(coursesTable)
        }
    }

    override func updateConstraints() {
        super.updateConstraints()
        coursesTable.snp.updateConstraints { (make) -> Void in
            make.height.greaterThanOrEqualTo(coursesTable.contentSize.height)
        }
    }
}

// MARK: - UITableViewDataSource
extension MineExamScoreView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let courses = courses else {
            return 0
        }

        let count = courses.count

        return count == 0 ? 1 : count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        guard let courses = courses else {
            return UITableViewCell()
        }

        let count = courses.count

        if count == 0 {
            let cell = UITableViewCell()
            let label = UILabel()
            cell.backgroundColor = UIColor.clear
            label.text = "还没有成绩出炉哦"
            label.textColor = HIColor.MineCardTextColor
            label.font = UIFont.systemFont(ofSize: 12)
            cell.addSubview(label)
            label.snp.makeConstraints({ (make) -> Void in
                make.center.equalTo(cell)
            })
            return cell
        } else {
            guard let tar = tableView
                .dequeueReusableCell(withIdentifier: courseCellIdentity) as? CourseCell else {
                    return UITableViewCell()
            }
            if indexPath.row < count {
                let course = courses[indexPath.row]
                tar.setData(course)
            }
            return tar
        }
    }
}

// MARK:- TableCell
extension MineExamScoreView {

    class CourseCell: UITableViewCell {

        let textFont = UIFont.systemFont(ofSize: 14)

        let title = UILabel()
        let score = UILabel()

        fileprivate func constructView() {
            self.backgroundColor = UIColor.clear

            self.addSubview(title)
            self.addSubview(score)

            score.textColor = HIColor.MineCardTextColor
            score.font = textFont
            score.snp.makeConstraints { (make) in
                make.centerY.equalTo(self)
                make.trailing.equalTo(self).offset(-32)
            }

            title.textColor = HIColor.MineCardTextColor
            title.font = textFont
            title.snp.makeConstraints { (make) -> Void in
                make.leading.equalTo(self).offset(28)
                make.centerY.equalTo(self)
                make.trailing.lessThanOrEqualTo(score.snp.leading).offset(-32)
            }
        }

        func setData(_ course: MineExam.ScoreRecord) {
            title.text = course.courseName
            score.text = course.score
        }

        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            constructView()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
    }
}

// MARK: - UITableViewDelegate
extension MineExamScoreView: UITableViewDelegate {
}
