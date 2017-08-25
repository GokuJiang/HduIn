//
//  SelectionStarsView.swift
//  HduIn
//
//  Created by Lucas Woo on 12/9/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionStarsView: SelectionCoursesView {

    weak var delegate: SelectionStarsViewDelegate? {
        didSet {
            _delegate = delegate
        }
    }
    weak var dataSource: SelectionStarsViewDataSource? {
        didSet {
            _dataSource = dataSource
        }
    }
}

// MARK: - Protocol SelectionStarsViewDataSource

protocol SelectionStarsViewDataSource: SelectionCoursesViewDataSource {

}

// MARK: - Protocol SelectionStarsViewDelegate

protocol SelectionStarsViewDelegate: SelectionCoursesViewDelegate {

}
