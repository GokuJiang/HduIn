//
//  SelectionCoursesView.swift
//  HduIn
//
//  Created by Lucas Woo on 12/8/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import MJRefresh

class SelectionCoursesView: UIView {

    let courseTableView = UITableView()

    weak var _delegate: SelectionCoursesViewDelegate?
    weak var _dataSource: SelectionCoursesViewDataSource?
    weak var cellDelegate: SelectionCourseCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        courseTableView.mj_header = MJRefreshNormalHeader {
            self._dataSource?.coursesViewRequestRefresh(self, tableView: self.courseTableView)
        }

        courseTableView.isEditing = true
        courseTableView.allowsMultipleSelectionDuringEditing = true
        courseTableView.separatorStyle = .none
        courseTableView.register(
            SelectionCourseCell.self,
            forCellReuseIdentifier: "SelectionCourseCell"
        )
        courseTableView.backgroundColor = UIColor.clear
        courseTableView.dataSource = self
        courseTableView.delegate = self
        self.addSubview(courseTableView)
        courseTableView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
    }

    func reloadData() {
        self.courseTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension SelectionCoursesView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _delegate?.coursesViewSelectionUpdated(self, courseTableView: tableView)
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        _delegate?.coursesViewSelectionUpdated(self, courseTableView: tableView)
    }
}

// MARK: - UITableViewDataSource

extension SelectionCoursesView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = _dataSource else {
            return 0
        }
        return dataSource.coursesView(self, numberOfCourseInTableView: tableView)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 90
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "SelectionCourseCell"
        ) as? SelectionCourseCell else {
            return UITableViewCell()
        }
        guard let dataSource = _dataSource else {
            return cell
        }
        guard let course = dataSource.coursesView(self, courseAtIndexPath: indexPath) else {
            return cell
        }
        cell.delegate = cellDelegate
        cell.nameLabel.text = course.name
        cell.teacherLabel.text = course.teacher
        cell.timeLabel.text = course.time
        cell.totalLabel.text = String(course.total)
        cell.remainingLabel.text = String(
            course.selectedCount < course.total ?
            course.total - course.selectedCount :
                0
        )
        cell.stared = course.star == nil ? false : true
        switch Double(course.selectedCount / course.total) {
        case 0 ..< 0.5:
            cell.remainingLabel.textColor = UIColor(hex: "39B8B4")
        case 0.6 ..< 0.85:
            cell.remainingLabel.textColor = UIColor.orange
        default:
            cell.remainingLabel.textColor = UIColor.red
        }

        return cell
    }
}

// MARK: - Protocol SelectionPEViewDataSource

protocol SelectionCoursesViewDataSource: class {
    func coursesView(
        _ coursesView: SelectionCoursesView,
        numberOfCourseInTableView: UITableView
    ) -> Int

    func coursesView(
        _ coursesView: SelectionCoursesView,
        courseAtIndexPath: IndexPath
    ) -> SelectionCourse?

    func coursesViewRequestRefresh(_ coursesView: SelectionCoursesView, tableView: UITableView)
}

// MARK: - Protocol SelectionPEViewDelegate

protocol SelectionCoursesViewDelegate: class {
    func coursesViewSelectionUpdated(
        _ coursesView: SelectionCoursesView,
        courseTableView: UITableView
    )
}
