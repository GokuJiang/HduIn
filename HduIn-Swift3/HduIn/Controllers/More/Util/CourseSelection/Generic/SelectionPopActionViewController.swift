//
//  SelectionPopActionViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/8/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionPopActionViewController: UIViewController {

    weak var delegate: SelectionPopActionViewControllerDelegate?

    let actionView = SelectionPopActionView()
    var stared = false {
        didSet {
            actionView.stared = stared
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        self.view.layer.masksToBounds = false
        self.view.addSubview(actionView)
        actionView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }

        actionView.starButton.addTarget(
            self,
            action: #selector(SelectionPopActionViewController.tappedStarButton(sender:)),
            for: .touchUpInside
        )
        actionView.detailsButton.addTarget(
            self,
            action: #selector(SelectionPopActionViewController.tappedDetailsButton(sender:)),
            for: .touchUpInside
        )
    }

    func tappedDetailsButton(sender: UIButton) {
        delegate?.actionViewDetailsAction(self, detailsButton: sender)
    }

    func tappedStarButton(sender: UIButton) {
        delegate?.actionViewStarAction(self, starButton: sender)
    }
}

// MARK: - Protocol SelectionPopActionViewDelegate

protocol SelectionPopActionViewControllerDelegate: class {
    func actionViewDetailsAction(
        _ actionView: SelectionPopActionViewController,
        detailsButton button: UIButton
    )

    func actionViewStarAction(
        _ actionView: SelectionPopActionViewController,
        starButton button: UIButton
    )
}
