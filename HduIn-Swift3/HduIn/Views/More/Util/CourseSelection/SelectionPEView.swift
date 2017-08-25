//
//  SelectionPEView.swift
//  HduIn
//
//  Created by Lucas Woo on 12/6/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionPEView: SelectionCoursesView {

    var typeCollectionView: UICollectionView!

    weak var delegate: SelectionPEViewDelegate? {
        didSet {
            _delegate = delegate
        }
    }
    weak var dataSource: SelectionPEViewDataSource? {
        didSet {
            _dataSource = dataSource
        }
    }

    fileprivate var selectedTypeIndexPath = IndexPath(row: 0, section: 0)

    override func setupView() {
        super.setupView()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        flowLayout.itemSize = CGSize(width: 48, height: 48)
        typeCollectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)

        typeCollectionView.register(
            SelectionPETypeCell.self,
            forCellWithReuseIdentifier: "SelectionPETypeCell"
        )
        typeCollectionView.backgroundColor = UIColor.clear
        typeCollectionView.showsVerticalScrollIndicator = false
        typeCollectionView.showsHorizontalScrollIndicator = false
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self

        typeCollectionView.layer.borderWidth = 1
        typeCollectionView.layer.borderColor = UIColor(hex: "ededed").cgColor
    }

    override func reloadData() {
        super.reloadData()
        self.courseTableView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension SelectionPEView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let dataSource = dataSource else {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionPETypeCell",for: indexPath) as? SelectionPETypeCell else {
                return UICollectionViewCell()
        }
        
        let type = dataSource.peView(self, typeAtIndexPath: indexPath)
        cell.imageView.image = UIImage(named: "Selection-PE-\(String(describing: type))")
        cell.imageView.highlightedImage = UIImage(named: "Selection-PE-\(String(describing: type))HL")
        cell.textLabel.text = type.rawValue
        
        cell.performDeselectionAnimation()
        if indexPath.item == selectedTypeIndexPath.item {
            cell.performSelectionAnimation()
        }
        
        return cell

    }

    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.peView(self, numberOfTypeInCollection: collectionView)
    }
}

// MARK: - UICollectionViewDelegate

extension SelectionPEView: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionView.deselectItem(at: selectedTypeIndexPath, animated: true)
        guard let previousCell = collectionView
            .cellForItem(at: selectedTypeIndexPath) as? SelectionPETypeCell else {
                return
        }
        previousCell.performDeselectionAnimation()

        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectionPETypeCell else {
                return
        }
        cell.performSelectionAnimation()
        self.selectedTypeIndexPath = indexPath

        delegate?.peView(
            self,
            typeCollectionView: collectionView,
            didSelectedAtIndexPath: selectedTypeIndexPath
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SelectionPEView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 70, height: 70)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
}

// MARK: - UITableViewDataSource

extension SelectionPEView {

    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 140
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 25
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return typeCollectionView
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 2:
            let imageFooter = UIImageView(image: UIImage(named: "Selection-PEFooter"))
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
        case 1:
            return dataSource.coursesView(self, numberOfCourseInTableView: tableView)
        default:
            return 0
        }
    }
}

// MARK: - Protocol SelectionPEViewDataSource

protocol SelectionPEViewDataSource: SelectionCoursesViewDataSource {
    func peView(_ peView: SelectionPEView, numberOfTypeInCollection: UICollectionView) -> Int

    func peView(
        _ peView: SelectionPEView,
        typeAtIndexPath: IndexPath
    ) -> SelectionPEViewController.PEType
}

// MARK: - Protocol SelectionPEViewDelegate

protocol SelectionPEViewDelegate: SelectionCoursesViewDelegate {
    func peView(
        _ peView: SelectionPEView,
        typeCollectionView: UICollectionView,
        didSelectedAtIndexPath indexPath: IndexPath
    )
}
