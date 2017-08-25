//
//  SelectionRequestViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 12/9/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class SelectionRequestViewController: UIViewController {

    let actionView = SelectionRequestView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        self.view.layer.masksToBounds = false
        self.view.addSubview(actionView)
        actionView.delegate = self
        actionView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(view)
            make.center.equalTo(view)
        }
    }

    func setSucceed() {
        actionView.loadingImageView.image = UIImage(named: "Selection-Succeed")
        actionView.loadingLabel.text = "操作成功"
        setDone()
    }

    func setError() {
        actionView.loadingImageView.image = UIImage(named: "Selection-Succeed")
        actionView.loadingLabel.text = "我们好像遇到了一些问题，请坐和放宽"
        setDone()
    }

    func setDone() {
        actionView.addDoneButton()
    }

    func addResultRow(_ courseName: String, result: String) {
        let resultCell = SelectionRequestView.ResultCell()
        resultCell.nameLabel.text = courseName
        resultCell.resultLabel.text = result
        actionView.stackView.addArrangedSubview(resultCell)
        resultCell.makeConstraints(toParent: actionView.stackView)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension SelectionRequestViewController: SelectionRequestViewDelegate {
    func requestView(_ requestView: SelectionRequestView, didTapDoneButton: UIButton) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
}
