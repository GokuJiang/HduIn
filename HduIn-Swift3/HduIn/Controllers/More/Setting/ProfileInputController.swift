//
//  ProfileInputController.swift
//  HduIn
//
//  Created by Lucas Woo on 10/20/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import AVOSCloud
class ProfileInputController: BaseViewController {

    enum InputType: String {
        case Email = "邮箱"
    }

    var delegate: ProfileInputControllerDelegate?

    fileprivate var _inputType: InputType?
    var inputType: InputType? {
        get {
            return _inputType
        }
        set {
            _inputType = newValue
            if let type = _inputType {
                self.title = type.rawValue
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    barButtonSystemItem: .done,
                    target: self,
                    action: #selector(ProfileInputController.doneTapped(sender:))
                )
                self.navigationItem.rightBarButtonItem?.isEnabled = false

                switch type {
                case .Email:
                    profileInputView.inputField.keyboardType = .emailAddress
                    profileInputView.promptLabel.text = "请输入您的邮箱地址:"
                }
            }
        }
    }

    let profileInputView = ProfileInputView()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(ProfileInputController.cancelTapped(sender:))
        )

        NotificationCenter.default.addObserver(self,
            selector: #selector(ProfileInputController.textFieldChanged(notification:)),
            name: NSNotification.Name.UITextFieldTextDidChange,
            object: profileInputView.inputField
        )

        self.view = profileInputView
    }

    func textFieldChanged(notification: NSNotification) {
        guard let field = notification.object as? UITextField else {
            return
        }
        if let type = inputType {
            if let text = field.text {
                var status = false
                switch type {
                case .Email:
                    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
                    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
                    status = emailTest.evaluate(with: text)
                }
                if status {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }
            }
        }
    }

    func doneTapped(sender: UIBarButtonItem) {
        if let type = inputType {
            switch type {
            case .Email:
                let email = profileInputView.inputField.text!
                delegate?.profileDismissed()
                let user = AVUser.current()
                user?.setObject(email, forKey: "email")
                user?.saveInBackground { [weak self](result, error) -> Void in
                    if result {
                        let transition = CATransition()
                        transition.duration = 0.3
                        transition.type = kCATransitionFade
                        self?.view.window?.layer.add(transition, forKey: kCATransition)
                        self?.dismiss(animated: false, completion: nil)
                        log.warning("Saved User successfully")
                    } else {
                        log.error("Save user failed with error: \(error.debugDescription))")
                    }
                }
            }
        }
    }

    func cancelTapped(sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: kCATransition)

        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - ProfileInputController Delegate

protocol ProfileInputControllerDelegate {
    func profileDismissed()
}
