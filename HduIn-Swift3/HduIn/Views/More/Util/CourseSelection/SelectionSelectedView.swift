//
//  SelectionSelectedView.swift
//  HduIn
//
//  Created by 姜永铭 on 15/12/12.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class SelectionSelectedView: UIView {
    typealias CourseData = SelectedCourseModel.CourseData

    var isEditing = false
    var height: CGFloat? = 132

    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

    var dataSource: SelectionSelectedViewDataSource?
    var delegate: SelectionSelectedViewDelegate?
    weak var cellDelegate: selectionSelectedCellDelegate?

    var contentTableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    fileprivate func setupView() {
        contentTableView.register(
            SelectionSelectedCell.self,
            forCellReuseIdentifier: "SelectionSelectedCell"
        )
        contentTableView.backgroundColor = HIColor.BackgroundGrey
        contentTableView.isEditing = false
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.delegate!.selectionSelectedView(self, willRefresg: self.contentTableView.mj_header)
        })
        self.addSubview(contentTableView)
        contentTableView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
    }
}

extension SelectionSelectedView: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "SelectionSelectedCell",
            for: indexPath
        ) as? SelectionSelectedCell else {
            return UITableViewCell()
        }
        guard let _dataSource = dataSource else {
            return cell
        }
        
        let (course, edit):(CourseData?, Bool?) = _dataSource.selectionSelectedView(self, cellForRowAtIndexPath: indexPath)
        
        self.isEditing = edit ?? false
        if self.isEditing {
            cell.selecteButton.alpha = 1
        } else {
            cell.selecteButton.alpha = 0
        }

        cell.delegate = cellDelegate
        cell._isEditing = isEditing
        cell.selecteButton.tag = indexPath.section
        cell.courseNameLabel.text = course!.name
        let indexStart = course?.selectCode.index((course?.selectCode.startIndex)!, offsetBy: 14)
        let indexEnd = course?.selectCode.index((course?.selectCode.startIndex)!, offsetBy: 22)
//        let indexStart = course!.selectCode.startIndex.advancedBy(14) // swift 2.0+
//        let indexEnd = course!.selectCode.startIndex.advancedBy(22) // swift 2.0+
        
        let courseID = course!.selectCode[indexStart!...indexEnd!]
        cell.courseIDLabel.text = courseID
        cell.placeLabel.text = course!.place
        cell.teacherLabel.text = course!.teacher
        cell.timeLabel.text = course!.time
        cell.creditLabel.text = "学分 3.0"

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource!.selectionSelectedView(self, numberOfSectionInTableView: tableView)
    }
}

extension SelectionSelectedView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.height ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "F0F0F0")
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
}

protocol SelectionSelectedViewDataSource {
    func selectionSelectedView(
        _ selectionSelectedView: SelectionSelectedView,
        numberOfSectionInTableView tableView: UITableView
    ) -> Int

    func selectionSelectedView(
        _ selectionSelectedView: SelectionSelectedView,
        cellForRowAtIndexPath indexPath: IndexPath
    ) -> (SelectedCourseModel.CourseData?, Bool?)
}

protocol SelectionSelectedViewDelegate {
    func selectionSelectedView(
        _ selectionSelectedView: SelectionSelectedView,
        willRefresg header: MJRefreshHeader
    )
}
