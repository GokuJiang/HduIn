//
//  MineExamScheduleView.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/10/7.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit


class MineExamScheduleView: MineCardContentView {
    var courses: [MineExam.Schedule]? = nil

    let coursesTable = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)

    let courseCellIdentity = "CourseCell"

    func setData(_ results: [MineExam.Schedule]) {
        courses = results
        coursesTable.reloadData()
        self.setNeedsUpdateConstraints()
        self.coursesTable.alpha = 0.24
        UIView.animate(withDuration: 0.42) { () -> Void in
            self.coursesTable.alpha = 1
        }
    }

    override func setupView() {
        super.setupView()

        coursesTable.register(CourseCell.self, forCellReuseIdentifier: courseCellIdentity)
        coursesTable.dataSource = self
        coursesTable.delegate = self
        coursesTable.rowHeight = 65
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

extension MineExamScheduleView: UITableViewDataSource {

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
            label.text = "今天并没有考试安排"
            label.textColor = HIColor.MineCardTextColor
            label.font = UIFont.systemFont(ofSize: 16)
            cell.addSubview(label)
            label.snp.makeConstraints({ (make) -> Void in
                make.center.equalTo(cell)
            })
            return cell
        } else {
            guard let tar = tableView
                .dequeueReusableCell(withIdentifier:
                    courseCellIdentity) as? CourseCell else {
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
extension MineExamScheduleView {

    class CourseCell: UITableViewCell {

        let timeBackgroundColor = UIColor(hex: "#3D9DDC")

        let timeFont = UIFont.systemFont(ofSize: 12)
        let textFont = UIFont.systemFont(ofSize: 13)
        let dayNumberFont = UIFont.systemFont(ofSize: 30)

        let title = UILabel()
        let seatNumber = UILabel()
        let place = UILabel()
        let time = UILabel()

        let dayNumber = UILabel()

        fileprivate func constructView() {
            self.backgroundColor = UIColor.clear

            self.addSubview(dayNumber)
            self.addSubview(title)
            self.addSubview(seatNumber)
            self.addSubview(place)

            let timeBackground = UIView()
            self.addSubview(timeBackground)
            self.addSubview(time)

            dayNumber.textColor = HIColor.MineCardH3Color
            dayNumber.font = dayNumberFont
            dayNumber.snp.makeConstraints { (make) -> Void in
                make.leading.equalTo(self.snp.leading).offset(18)
                make.top.equalTo(self).offset(10)
            }

            timeBackground.backgroundColor = timeBackgroundColor
            timeBackground.layer.cornerRadius = 8
            timeBackground.snp.makeConstraints { (make) -> Void in
                make.center.equalTo(time)
                make.width.equalTo(time).offset(8)
                make.height.equalTo(time)
            }

            time.font = timeFont
            time.textColor = HIColor.MineCardBackground
            time.textAlignment = .center
            time.snp.makeConstraints { (make) -> Void in
                make.trailing.equalTo(self).offset(-17)
                make.top.equalTo(self).offset(7)
                make.width.equalTo(48)
            }

            title.textColor = HIColor.MineCardTextColor
            title.font = textFont
            title.numberOfLines = 2
            title.snp.makeConstraints { (make) -> Void in
                make.leading.equalTo(self).offset(56)
                make.top.equalTo(self).offset(10)
                make.trailing.lessThanOrEqualTo(time.snp.leading).offset(-32)
            }

            seatNumber.font = textFont
            seatNumber.textColor = HIColor.MineCardTextColor
            seatNumber.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(place)
                make.trailing.equalTo(time)
            }

            place.font = textFont
            place.textColor = HIColor.MineCardTextColor
            place.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(self).offset(-8)
                make.leading.equalTo(title)
            }
        }

        func setData(_ course: MineExam.Schedule) {
            title.text = course.examCourse
            place.text = course.examPlace
            
            time.text = course.startTime.toString(format: .Custom("HH:mm"))
            dayNumber.text = "\(course.startTime.day)"
            seatNumber.text = "座位号: \(course.seatNumber)"
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
extension MineExamScheduleView: UITableViewDelegate {
}
