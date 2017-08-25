//
//  SelectionRequestView.swift
//  HduIn
//
//  Created by Lucas Woo on 12/9/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
//import TZStackView
import YYWebImage

class SelectionRequestView: UIView {

    class ResultCell: UIView {
        let nameLabel = UILabel()
        let resultLabel = UILabel()

        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupView()
        }

        func setupView() {
            nameLabel.textColor = UIColor(hex: "0d0d0d")
            nameLabel.font = UIFont.systemFont(ofSize: 11)
            nameLabel.textAlignment = .center
            self.addSubview(nameLabel)
            nameLabel.snp.makeConstraints {
                (make) -> Void in
                make.height.equalTo(self)
                make.width.equalTo(self).dividedBy(2).offset(-10)
                make.leading.equalTo(self).offset(4)
                make.centerY.equalTo(self).offset(-4)
            }

            resultLabel.textColor = UIColor(hex: "0d0d0d")
            resultLabel.font = UIFont.systemFont(ofSize: 11)
            resultLabel.textAlignment = .center
            self.addSubview(resultLabel)
            resultLabel.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(self)
                make.width.equalTo(self).dividedBy(2).offset(-10)
                make.trailing.equalTo(self).offset(-4)
                make.centerY.equalTo(nameLabel)
            }
        }

        func makeConstraints(toParent parent: UIView) {
            self.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(parent)
                make.height.equalTo(24)
            }
        }
    }

    weak var delegate: SelectionRequestViewDelegate?

    let stackView = UIStackView()

    let loadingView = UIView()
    let loadingLabel = UILabel()

    let loadingImageView = YYAnimatedImageView()

    let doneButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        // Background
        self.backgroundColor = UIColor.clear
        let effect = UIBlurEffect(style: .dark)
        let bluredView = UIVisualEffectView(effect: effect)
        self.addSubview(bluredView)
        bluredView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }

        // StackView Properties
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        stackView.axis = .vertical
        stackView.backgroundColor = UIColor.white
        stackView.layer.cornerRadius = 16
        stackView.layer.masksToBounds = true
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.width.equalTo(200)
        }

        // Loading View
        stackView.addArrangedSubview(loadingView)
        loadingView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(stackView)
            make.height.equalTo(150)
        }

        let animatedImage = YYImage(named: "Selection-Loading.gif")
        loadingImageView.image = animatedImage
        loadingView.addSubview(loadingImageView)
        loadingImageView.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(loadingView)
            make.size.equalTo(CGSize(width: 80, height: 90))
            make.top.equalTo(loadingView).offset(18)
        }

        loadingLabel.text = "选课中，请耐心等待..."
        loadingLabel.font = UIFont.systemFont(ofSize: 11)
        loadingLabel.textColor = UIColor(hex: "00263c")
        loadingView.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(loadingView)
            make.top.equalTo(loadingImageView.snp.bottom).offset(10)
        }

        // Seperator
        let seperator = UIView()
        seperator.backgroundColor = UIColor(hex: "DFDFDF")
        stackView.addArrangedSubview(seperator)
        seperator.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.width.equalTo(stackView)
        }

        doneButton.setTitle("好", for: .normal)
        doneButton.setTitleColor(UIColor(hex: "3498db"), for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        doneButton.addTarget(self,
            action: #selector(SelectionRequestView.doneButtonTouchUpInside(_ :)),
            for: .touchUpInside
        )
    }

    func addDoneButton() {
        stackView.addArrangedSubview(doneButton)
        doneButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(stackView)
            make.height.equalTo(35)
        }
    }

    func doneButtonTouchUpInside(_ sender: UIButton) {
        delegate?.requestView(self, didTapDoneButton: sender)
    }
}

protocol SelectionRequestViewDelegate: class {
    func requestView(_ requestView: SelectionRequestView, didTapDoneButton: UIButton)
}
