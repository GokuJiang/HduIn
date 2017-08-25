//
//  SelectionPEViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import RealmSwift

class SelectionPEViewController: SelectionCoursesViewController {

    enum PEType: String {
        case Badminton = "羽毛球"
        case Basketball = "篮球"
        case Dance = "体育舞蹈"
        case Football = "足球"
        case Outdoor = "户外拓展"
        case Radio = "无线电"
        case TableTennis = "乒乓球"
        case Tennis = "网球"
        case Volleyball = "排球"
        case Wushu = "武术"

        static let availableType = [
            Badminton,
            Basketball,
            Dance,
            Football,
            Outdoor,
            Radio,
            TableTennis,
            Tennis,
            Volleyball,
            Wushu
        ]
    }

    let contentView = SelectionPEView()
    var selectedType = PEType.Badminton {
        didSet {
            self.navigationItem.title = selectedType.rawValue
            updateQuery()
        }
    }

    var fobbidenCount = 0

    override var category: SelectionCourse.Category {
        return .PE
    }
    fileprivate var realm: Realm? = nil
    var courseQuery: Results<SelectionCourse>? {
        get {
            return _courseQuery
        }
        set {
            _courseQuery = newValue?.filter("name CONTAINS %@", selectedType.rawValue)
            contentView.reloadData()
            selectedCourses = [SelectionCourse]()
        }
    }

    override func viewDidLoad() {
        _contentView = contentView
        super.viewDidLoad()
        fetchData()

        self.navigationItem.title = selectedType.rawValue

        self.view.addSubview(contentView)
        contentView.dataSource = self
        contentView.delegate = self
        contentView.cellDelegate = self
        contentView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
    }

    override func fetchData(_ isRefresh: Bool = false) {
        _ = provider.getCourses(.PE).subscribe { (event) in
            switch event {
            case .next(let results):
                self.courseQuery = results.sorted(byKeyPath: "selectCode")
//                self.courseQuery = results.sorted(byProperty: "selectCode")
                super.fetchData()
            case .error(let error):
                log.error("Request PE Courses Failed with error: \(error)")
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
        courseQuery = realm?.objects(SelectionCourse.self)
            .filter("category = %@", category.rawValue).sorted(byKeyPath: "selectCode")
    }

    override func setupTabBarItem() {
        let item = UITabBarItem(
            title: "体育课",
            image: UIImage(named: "Selection-PE"),
            selectedImage: UIImage(named: "Selection-PEHL")
        )
        self.tabBarItem = item
    }

    override func submitActionValidation() -> Bool {
        switch category {
        case .PE:
            guard selectedCourses.count == 1 else {
                showPEUniqueAlert(false)
                return false
            }
            return true
        default:
            return false
        }
    }

    override func submitAction(_ popController: SelectionRequestViewController) {
        _ = provider.selectPE(selectedCourses[0])
            .map { result in
                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                guard let course = realm.objects(SelectionCourse.self)
                    .filter("selectCode = %@", result.selectCode).first else {
                        throw SelectionError.courseNotFound
                }
                popController.addResultRow(course.name, result: result.message)
            }.subscribe { event in
                switch event {
                case .next():
                    break
                case .error(let error):
                    popController.setError()
                    log.error("Action failed with error: \(error)")
                case .completed:
                    popController.setSucceed()
                }
            }
    }

    func showPEUniqueAlert(_ isStar: Bool) {
        var action = ""
        if isStar {
            action = "收藏"
        } else {
            action = "选择"
        }
        var message = ""
        switch self.fobbidenCount {
        case 0:
            message = "体育课只能\(action)一门哦~"
        case 1:
            message = "真的只能\(action)一门哦..."
        case 2:
            message = "你再这样我要生气啦~"
        default:
            message = "......"
            self.fobbidenCount = 0
        }
        self.fobbidenCount += 1
        let alertController = UIAlertController(
            title: "\(action)失败",
            message: message,
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "我知道啦", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - SelectionPEViewDelegate

extension SelectionPEViewController: SelectionPEViewDelegate {
     func peView(_ peView: SelectionPEView, typeCollectionView: UICollectionView, didSelectedAtIndexPath indexPath: IndexPath) {
        self.selectedType = PEType.availableType[indexPath.item]

    }
}

// MARK: - SelectionPEViewDataSource

extension SelectionPEViewController: SelectionPEViewDataSource {
     func peView(_ peView: SelectionPEView, typeAtIndexPath: IndexPath) -> SelectionPEViewController.PEType {
        return PEType.availableType[typeAtIndexPath.item]
    }

    func peView(_ peView: SelectionPEView, numberOfTypeInCollection: UICollectionView) -> Int {
        return PEType.availableType.count
    }

}

// MARK: - SelectionCourseCellDelegate

extension SelectionPEViewController {
    override func courseCellStarAction(
        _ courseCell: SelectionCourseCell,
        actionView: SelectionPopActionViewController,
        starButton: UIButton
    ) {
        actionView.dismiss(animated: true, completion: nil)
        guard let indexPath = _contentView?.courseTableView.indexPath(for: courseCell) else {
            return
        }
        guard let course = courseQuery?[indexPath.item] else {
            return
        }

        if course.star != nil {
            _ = provider.unstar(course).subscribe({ (event) in
                switch event {
                case .next(_):
                    courseCell.stared = false
                default:
                    break
                }
            })
//            _ = provider.unstar(course: course).subscribeNext { courseCell.stared = false }
        } else {
            _ = provider.star(course).subscribe { event in
                switch event {
                case .next():
                    courseCell.stared = true
                case .error(let error):
                    if error is SelectionError {
                        self.showPEUniqueAlert(true)
                    }
                case .completed:
                    break
                }
            }
        }
    }
}
