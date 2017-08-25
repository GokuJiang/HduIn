//
//  SelectionStarsViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import RealmSwift

class SelectionStarsViewController: SelectionCoursesViewController {

    let contentView = SelectionStarsView()

    fileprivate var realm: Realm? = nil
    var courseQuery: Results<SelectionCourse>? {
        get {
            return _courseQuery
        }
        set {
            _courseQuery = newValue
            contentView.reloadData()
            selectedCourses = [SelectionCourse]()
        }
    }

    var starsQuery: Results<SelectionStar>? {
        didSet {
            guard let starsQuery = starsQuery else {
                return
            }
            self.courseQuery = realm?.objects(SelectionCourse.self)
                .filter("selectCode IN %@", starsQuery.map { $0.selectCode })
        }
    }

    override func viewDidLoad() {
        _contentView = contentView
        super.viewDidLoad()
        fetchData()

        self.title = "收藏夹"

        self.view.addSubview(contentView)
        contentView.dataSource = self
        contentView.delegate = self
        contentView.cellDelegate = self
        contentView.snp.makeConstraints {
            (make) -> Void in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
    }

    override func fetchData(_ isRefresh: Bool = false) {
        _ = provider.getStars().subscribe { event in
            switch event {
            case .next(let results):
                self.starsQuery = results.sorted(byKeyPath: "selectCode")
                super.fetchData()
            case .error(let error):
                log.error("Request Stared Courses Failed with error: \(error)")
            case .completed:
                break
            }
        }
    }

    override func updateQuery() {
        if realm == nil {
            do {
                realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
            } catch {
                log.error("Open Realm failed with error: \(error)")
                return
            }
        }
        starsQuery = realm?.objects(SelectionStar.self).sorted(byKeyPath: "selectCode")
    }

    override func setupTabBarItem() {
        let item = UITabBarItem(
            title: "收藏夹",
            image: UIImage(named: "Selection-Stars"),
            selectedImage: UIImage(named: "Selection-StarsHL")
        )
        self.tabBarItem = item
    }

    override func updateSubmitBadge() {
        if selectedCourses.count == 0 {
            badgeView.isHidden = true
            if let query = courseQuery {
                if query.count > 0 {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    submitButton.setTitle("全部提交", for: UIControlState())
                }
            } else {
                submitButton.setTitle("提交", for: UIControlState())
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            submitButton.setTitle("提交", for: UIControlState())
            badgeView.isHidden = false
            submitBadgeLabel.text = String(selectedCourses.count)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    override func submitAction(_ popController: SelectionRequestViewController) {
        if selectedCourses.count == 0 {
            _ = provider.submitStars()
                .map { results in
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    results.forEach { result in
                        guard let course = realm.objects(SelectionCourse.self)
                            .filter("selectCode = %@", result.selectCode).first else {
                                return
                        }
                        popController.addResultRow(course.name, result: result.message)
                    }
                }
                .subscribe { event in
                    switch event {
                    case .next:
                        break
                    case .error(let error):
                        popController.setError()
                        log.error("Action Failed with error: \(error)")
                    case .completed:
                        popController.setSucceed()
                    }
                }
        } else {
            super.submitAction(popController)
        }
    }
}

// MARK: - SelectionStarsViewDelegate
extension SelectionStarsViewController: SelectionStarsViewDelegate {
    override func courseCellStarAction(
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
          _ =  provider.unstar(course).subscribe({ (event) in
                switch event {
                case .next:
                    courseCell.stared = false
                    self.updateQuery()
                default:
                    break
                }
            })
        } else {
           _ = provider.unstar(course).subscribe({ (event) in
                switch event {
                case .next:
                    courseCell.stared = true
                    self.updateQuery()
                default:
                    break
                }
            })
        }
    }
}

// MARK: - SelectionStarsViewDataSource
extension SelectionStarsViewController: SelectionStarsViewDataSource {
}
