//
//  SelectionSelectedViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import SnapKit

class SelectionSelectedViewController: SelectionBaseViewController {

    typealias CourseData = SelectedCourseModel.CourseData
    var contentView = SelectionSelectedView()
    var course = SelectedCourseModel()
    var courseDatas = [CourseData]()
    let editButton = UIButton()

    var edit: Bool = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        contentView.dataSource = self
        contentView.delegate = self
        contentView.cellDelegate = self
        course.delegate = self
        course.fetchdata()
        self.title = "已选课程"
        showBackActionButton()
        // setupSubmitBarButtonItem()
        contentView.contentTableView.mj_header.beginRefreshing()
    }

    var selectionSelectedView = SelectionSelectedView()
    let screenWidth =
        UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var buttonFlag = false

    func setupSubmitBarButtonItem() {
        let tintColor = UIColor(hex: "3498db")
        editButton.setTitle("编辑", for: .normal)
        editButton.setTitle("完成", for: .selected)
        editButton.frame = CGRect(x: 0, y: 0, width: 72, height: 18)
        editButton.tintColor = tintColor
        editButton.titleLabel?.font =
            UIFont.systemFont(ofSize: 17)
        editButton.setTitleColor(tintColor, for: .normal)
        editButton.setTitleColor(UIColor(hex: "676767"), for: .disabled)
        editButton.layer.masksToBounds = false
        editButton.addTarget(self,
            action: #selector(SelectionSelectedViewController.editSelected(_ :)),
            for: .touchUpInside
        )

        let editBarItem = UIBarButtonItem(customView: editButton)
        editBarItem.tintColor = tintColor
        self.navigationItem.rightBarButtonItem = editBarItem
    }

    func editSelected(_ sender: UIButton) {
        if sender.isSelected {
            editButton.isSelected = false
            self.edit = false
            self.contentView.height = 123
        } else {
            editButton.isSelected = true
            self.edit = true
            self.contentView.height = 132
        }
        self.contentView.contentTableView.reloadData()
    }

    override func setupTabBarItem() {
        let item = UITabBarItem(
            title: "已选课程",
            image: UIImage(named: "Selection-Selected"),
            selectedImage: UIImage(named: "Selection-SelectedHL")
        )
        self.tabBarItem = item
    }

//    class finish
}

extension SelectionSelectedViewController: SelectionSelectedViewDataSource {
    func selectionSelectedView(
        _ selectionSelectedView: SelectionSelectedView,
        numberOfSectionInTableView tableView: UITableView
    ) -> Int {
        return courseDatas.count
    }

    func selectionSelectedView(
        _ selectionSelectedView: SelectionSelectedView,
        cellForRowAtIndexPath indexPath: IndexPath
    ) -> (CourseData?, Bool?) {
        return (courseDatas[indexPath.section], self.edit)
    }
}

extension SelectionSelectedViewController: SelectionSelectedViewDelegate {
    func selectionSelectedView(
        _ selectionSelectedView: SelectionSelectedView,
        willRefresg header: MJRefreshHeader
    ) {
        self.course.fetchdata()
    }
}

extension SelectionSelectedViewController: selectedCourseModleHttpRequest {
    func selectedCourseModel(_ model: SelectedCourseModel, result: AnyObject) {
        courseDatas.removeAll()
        let json = JSON(result)
        for (_, subJSON): (String, JSON) in json {
            let courseDataFromJSON = CourseData(fromJSON: subJSON)
            courseDatas.append(courseDataFromJSON)
        }
        self.contentView.contentTableView.reloadData()
        self.contentView.contentTableView.mj_header.endRefreshing()
    }
}

extension SelectionSelectedViewController: selectionSelectedCellDelegate {
    func selectionSelectedCell(didSelected sender: UIButton) {
        let alert = UIAlertController(
            title: "你确定要退选这门课么",
            message: "",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil
        )
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.destructive) {
            (ok) -> Void in
            self.courseDatas.remove(at: sender.tag)
            let indexPath = IndexSet(integer: sender.tag)
            self.contentView.contentTableView.deleteSections(
                indexPath,
                with: UITableViewRowAnimation.fade
            )
            self.contentView.contentTableView.reloadData()
            self.course.deleteCourse(self.courseDatas[sender.tag].selectCode)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
