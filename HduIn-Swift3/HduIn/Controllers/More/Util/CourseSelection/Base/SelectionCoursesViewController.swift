
//
//  SelectionCoursesViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/8/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class SelectionCoursesViewController: SelectionBaseViewController {

    let provider = SelectionNetworking()

    var selectedCourses = [SelectionCourse]() {
        didSet {
            updateSubmitBadge()
        }
    }
    var _courseQuery: Results<SelectionCourse>?
    var category: SelectionCourse.Category {
        return .Public
    }

    let submitButton = UIButton()
    let badgeView = UIView()
    let submitBadgeLabel = UILabel()

    weak var _contentView: SelectionCoursesView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubmitBarButtonItem()
        updateSubmitBadge()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateQuery()
    }

    func setupSubmitBarButtonItem() {
        let tintColor = UIColor(hex: "3498db")

        submitButton.setTitle("提交", for: .normal)
        submitButton.frame = CGRect(x: 0, y: 0, width: 72, height: 18)
        submitButton.tintColor = tintColor
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        submitButton.setTitleColor(tintColor, for: .normal)
        submitButton.setTitleColor(UIColor(hex: "676767"), for: .disabled)
        submitButton.layer.masksToBounds = false
        submitButton.addTarget(self,
            action: #selector(SelectionCoursesViewController.submitSelected(sender:)),
            for: .touchUpInside
        )

        badgeView.layer.cornerRadius = 7
        badgeView.backgroundColor = UIColor(hex: "E84D3D")
        submitButton.addSubview(badgeView)
        badgeView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.top.equalTo(submitButton).offset(-7)
            make.trailing.equalTo(submitButton).offset(-7)
        }

        submitBadgeLabel.textColor = UIColor.white
        submitBadgeLabel.font = UIFont.systemFont(ofSize: 10)
        badgeView.addSubview(submitBadgeLabel)
        submitBadgeLabel.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(badgeView)
        }

        let submitBarItem = UIBarButtonItem(customView: submitButton)
        submitBarItem.tintColor = tintColor
        self.navigationItem.rightBarButtonItem = submitBarItem
    }

    func updateSubmitBadge() {
        if selectedCourses.count == 0 {
            badgeView.isHidden = true
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            badgeView.isHidden = false
            submitBadgeLabel.text = String(selectedCourses.count)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    func submitSelected(sender: AnyObject) {
        let popController = SelectionRequestViewController()
        popController.modalPresentationStyle = .overFullScreen

        if submitActionValidation() {
            submitAction(popController)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = kCATransitionFade
            self.view.window?.layer.add(transition, forKey: kCATransition)
            self.present(popController, animated: false, completion: nil)
        }
    }

    func submitActionValidation() -> Bool {
        switch category {
        case .Public:
            return true
        default:
            return false
        }
    }

    func submitAction(_ popController: SelectionRequestViewController) {
        switch category {
        case .Public:
            _ = provider.selectPublics(selectedCourses)
                .map { result in
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    guard let course = realm.objects(SelectionCourse.self)
                        .filter("selectCode = %@", result.selectCode)
                        .first else {
                            return
                    }
                    popController.addResultRow(course.name, result: result.message)
                }.subscribe { event in
                    switch event {
                    case .next():
                        break
                    case .error(let error):
                        popController.setError()
                        log.error("Action Failed with error: \(error)")
                    case .completed:
                        popController.setSucceed()
                    }
                }
        default:
            break
        }
    }

    /**
     Needs to be overriden

     - parameter isRefresh: <#isRefresh description#>
     */
    func fetchData(_ isRefresh: Bool = false) {
        self._contentView?.courseTableView.mj_header.endRefreshing()
    }

    /**
     Needs to be overriden
     */
    func updateQuery() {
    }
}

// MARK: - SelectionCoursesViewDelegate
extension SelectionCoursesViewController: SelectionCoursesViewDelegate {
    func coursesViewSelectionUpdated(
        _ coursesView: SelectionCoursesView,
        courseTableView: UITableView
    ) {
        selectedCourses = [SelectionCourse]()
        guard let indexes = courseTableView.indexPathsForSelectedRows else {
            return
        }
        guard let query = _courseQuery else {
            return
        }
        selectedCourses = indexes.map { return query[$0.item] }
    }
}

// MARK: - SelectionCoursesViewDataSource
extension SelectionCoursesViewController: SelectionCoursesViewDataSource {
    func coursesView(
        _ coursesView: SelectionCoursesView,
        numberOfCourseInTableView: UITableView
    ) -> Int {
        guard let query = _courseQuery else {
            return 0
        }
        return query.count
    }

    func coursesView(
        _ coursesView: SelectionCoursesView,
        courseAtIndexPath: IndexPath
    ) -> SelectionCourse? {
        return _courseQuery?[courseAtIndexPath.item]
    }

    func coursesViewRequestRefresh(_ coursesView: SelectionCoursesView, tableView: UITableView) {
        fetchData(true)
    }
}

// MARK: - SelectionCourseCellDelegate
extension SelectionCoursesViewController: SelectionCourseCellDelegate {
    func courseCell(_ courseCell: SelectionCourseCell, actionButtonTapped button: UIButton) {
        let popController = SelectionPopActionViewController()
        popController.stared = courseCell.stared
        popController.delegate = courseCell
        popController.modalPresentationStyle = .popover
        popController.preferredContentSize = CGSize(width: 81, height: 48)

        let popoverPresentationController = popController.popoverPresentationController
        popoverPresentationController?.delegate = self
        popoverPresentationController?.permittedArrowDirections = .right
        popoverPresentationController?.sourceView = courseCell
        popoverPresentationController?.sourceRect = CGRect(
            x: button.frame.origin.x,
            y: button.frame.origin.y,
            width: 1,
            height: 1
        )

        self.present(popController, animated: true, completion: nil)
    }

    func courseCellStarAction(
        _ courseCell: SelectionCourseCell,
        actionView: SelectionPopActionViewController,
        starButton: UIButton
    ) {
        actionView.dismiss(animated: true, completion: nil)
        guard let indexPath = _contentView?.courseTableView.indexPath(for: courseCell) else {
            return
        }
        guard let course = _courseQuery?[indexPath.item] else {
            return
        }

        if course.star != nil {
            _ =  provider.unstar(course).subscribe(onNext: { (_) in
                courseCell.stared = false
            }, onError: nil, onCompleted: nil, onDisposed: nil)
        } else {
            _ =  provider.unstar(course).subscribe(onNext: { (_) in
                courseCell.stared = true
            }, onError: nil, onCompleted: nil, onDisposed: nil)        }
    }

    func courseCellShowDetailsAction(
        _ courseCell: SelectionCourseCell,
        actionView: SelectionPopActionViewController,
        detailsButton: UIButton
    ) {
        actionView.dismiss(animated: true, completion: nil)
        actionView.dismiss(animated: true, completion: nil)
        guard let indexPath = _contentView?.courseTableView.indexPath(for: courseCell) else {
            return
        }
        guard let course = _courseQuery?[indexPath.item] else {
            return
        }
        let alertController = UIAlertController(
            title: "课程详情",
            message: "课程名称: \(course.name)\n" +
                "任课教师: \(course.teacher)\n" +
                "上课地点: \(course.place)\n" +
                "上课时间: \(course.time)",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "我知道啦", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension SelectionCoursesViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(
        for controller: UIPresentationController
    ) -> UIModalPresentationStyle {
        return .none
    }
}
