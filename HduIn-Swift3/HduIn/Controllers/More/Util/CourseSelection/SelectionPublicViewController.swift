//
//  SelectionPublicViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import RealmSwift

class SelectionPublicViewController: SelectionCoursesViewController {

    enum PublicQueryType: String {
        case All = "全部"
        case Available = "有余量"
        static let availabeType = [All, Available]
    }

    let contentView = SelectionPublicView()
    let titleSegmentedControl = UISegmentedControl(
        items: PublicQueryType.availabeType.map({ $0.rawValue })
    )

    var currentQueryType = PublicQueryType.All {
        didSet {
            updateQuery()
        }
    }
    fileprivate var realm: Realm?
    var courseQuery: Results<SelectionCourse>? {
        get {
            return _courseQuery
        }
        set {
            switch currentQueryType {
            case .Available:
                _courseQuery = newValue?.filter("selectedCount < total")
            default:
                _courseQuery = newValue
            }
            contentView.reloadData()
            selectedCourses = [SelectionCourse]()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self._contentView = contentView
        setupTitleView()
        fetchData()

        self.view.addSubview(contentView)
        contentView.dataSource = self
        contentView.delegate = self
        contentView.cellDelegate = self
        contentView.searchBar.delegate = self
        contentView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
    }

    override func setupTabBarItem() {
        let item = UITabBarItem(
            title: "公选课",
            image: UIImage(named: "Selection-Public"),
            selectedImage: UIImage(named: "Selection-PublicHL")
        )
        self.tabBarItem = item
    }

    func setupTitleView() {
        titleSegmentedControl.selectedSegmentIndex = 0
        titleSegmentedControl.addTarget(
            self,
            action: #selector(SelectionPublicViewController.segmentedControlValueChanged(_:)),
            for: .valueChanged
        )
        self.navigationItem.titleView = titleSegmentedControl
    }

    func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.currentQueryType = PublicQueryType.availabeType[index]
    }

    override func fetchData(_ isRefresh: Bool = false) {
        _ = provider.getCourses(.Public).subscribe { event in
            switch event {
            case .next(let results):
                self.courseQuery = results
                super.fetchData()
            case .error(let error):
                log.error("Request Public Courses Failed with error: \(error)")
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
            }
        }
        courseQuery = realm?.objects(SelectionCourse.self)
            .filter("category = %@", category.rawValue).sorted(byKeyPath: "selectCode")
    }
}

// MARK: - UISearchBarDelegate

extension SelectionPublicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateQuery()
        courseQuery = courseQuery?
            .filter("name CONTAINS %@ OR teacher CONTAINS %@ OR time CONTAINS %@",
                searchText,
                searchText,
                searchText
        )
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - SelectionPublicViewDataSource

extension SelectionPublicViewController: SelectionPublicViewDataSource {
}

// MARK: - SelectionPublicViewDelegate

extension SelectionPublicViewController: SelectionPublicViewDelegate {
}
