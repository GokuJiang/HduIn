//
//  MineWholeWeekCoursesController.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/10/12.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh

class MineWholeWeekCoursesController: BaseViewController {

    typealias Timeline = MineCourseSchedule.Timeline

    // MARK:- properties
    let scrollView = UIScrollView()
    var wholeWeekCoursesView: MineWholeWeekCoursesView!

    let courseSchedule: MineCourseSchedule = MineCourseSchedule()

    // MARK:- response functions
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "我的整周课表"

        wholeWeekCoursesView = MineWholeWeekCoursesView(frame: view.frame)

        scrollView.frame = self.view.frame
        scrollView.backgroundColor = UIColor.white
        scrollView.mj_header = MJRefreshNormalHeader {
            self.courseSchedule.useCache = false
            self.loadData()
        }

        self.view = scrollView

        // Should init with frame otherwise drawing strangely
        self.view.addSubview(wholeWeekCoursesView)
        wholeWeekCoursesView.delegate = self

        loadData()
    }

    func loadData() {
        _ = courseSchedule.weekCoursesObservable()
            .flatMap { [weak wholeWeekCoursesView](results) -> Observable<Timeline> in
                if let wwcv = wholeWeekCoursesView {
                    wwcv.setData(results)
                }
                return self.courseSchedule.timelineObservable()
            }.subscribe { (event) -> Void in
                switch event {
                case .next(let timeline):
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                        title: "第\(timeline.week)周",
                        style: .plain,
                        target: nil,
                        action: nil
                    )
                case .error(let error):
                    log.error("Failed to fetch courses with error: \(error)")
                default:
                    self.scrollView.mj_header?.endRefreshing()
                }
            }
    }
}

// MARK: - MineWholeWeekCoursesViewProtocol

extension MineWholeWeekCoursesController: MineWholeWeekCoursesViewDelegate {
    func showDetail(_ course: Course) {
        var constructStr = ""
        constructStr += "课程名称: \(course.name)"
        constructStr += "\n课程地点: \(course.classroom)"
        if let startTime = course.startTime, let endTime = course.endTime {
            constructStr += "\n上课时间: \(startTime) ~ \(endTime) (\(course.distribute)周)"
        }
        constructStr += "\n上课老师: \(course.teacher)"
        let alertController = UIAlertController(
            title: "具体课程",
            message: constructStr,
            preferredStyle: .alert
        )
        let actionOK = UIAlertAction(title: "朕知道了", style: .default, handler: nil)

        alertController.addAction(actionOK)

        self.present(alertController, animated: true, completion: nil)
    }
}
