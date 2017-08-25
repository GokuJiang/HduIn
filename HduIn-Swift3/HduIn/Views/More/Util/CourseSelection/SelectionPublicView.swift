//
//  SelectionPublicView.swift
//  HduIn
//
//  Created by Lucas Woo on 12/9/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionPublicView: SelectionCoursesView {

    let searchBar = UISearchBar()

    weak var delegate: SelectionPublicViewDelegate? {
        didSet {
            _delegate = delegate
        }
    }
    weak var dataSource: SelectionPublicViewDataSource? {
        didSet {
            _dataSource = dataSource
        }
    }

    override func setupView() {
        super.setupView()
        searchBar.placeholder = "搜索课程"
    }

}

// MARK: - UITableViewDataSource

extension SelectionPublicView {

    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 40
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 25
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return searchBar
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let imageFooter = UIImageView(image: UIImage(named: "Selection-PublicFooter"))
            imageFooter.contentMode = .scaleAspectFit
            return imageFooter
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        switch section {
        case 0:
            return dataSource.coursesView(self, numberOfCourseInTableView: tableView)
        default:
            return 0
        }
    }
}

// MARK: - Protocol SelectionPublicViewDataSource

protocol SelectionPublicViewDataSource: SelectionCoursesViewDataSource {

}

// MARK: - Protocol SelectionPublicViewDelegate

protocol SelectionPublicViewDelegate: SelectionCoursesViewDelegate {

}
