//
//  FeedbackView.swift
//  HduIn
//
//  Created by Lucas Woo on 3/10/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import UIKit
import SnapKit
import AVOSCloud

class FeedbackView: UIView {

    let TAG_TABLEView_Header = 1
    let TAG_InputFiled = 2

    let kInputViewHeight = 48 as CGFloat
    let kContactHeaderHeight = 48 as CGFloat
    let kAddImageButtonWidth = 40 as CGFloat
    let kSendButtonWidth = 60 as CGFloat
    let kTabBarHeight = 49 as CGFloat

    let feedbackCellFont = UIFont.systemFont(ofSize: 16)
    let kInputViewColor = UIColor(red: 247.0/255, green: 248.0/255, blue: 248.0/255, alpha:1)

    var bottomFieldsConstraint: Constraint? = nil

    weak var delegate: FeedbackViewDelegate?
    weak var dataSource: FeedbackViewDataSource?

    let tableViewHeader = UITextField()
    let refreshControl = UIRefreshControl()
    let tableView = UITableView()
    let inputTextField = UITextField()
    let addImageButton = UIButton()
    let sendButton = UIButton(type: .system)

    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setupView() {
        self.addSubview(self.tableView)
        self.addSubview(self.addImageButton)
        self.addSubview(self.sendButton)
        self.addSubview(self.inputTextField)
        LCUserFeedbackReplyCell.appearance().cellFont = self.feedbackCellFont

        self.tableView.addSubview(self.refreshControl)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(FeedbackView.closeKeyboard(sender:))
        )
        tap.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tap)

        refreshControl.addTarget(delegate,
            action: #selector(FeedbackViewDelegate.handleRefresh(_:)),
            for: .valueChanged
        )

        tableView.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.bottom.equalTo(inputTextField.snp.top)
        }
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self

        inputTextField.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(addImageButton)
            make.left.equalTo(addImageButton.snp.right)
            make.right.equalTo(sendButton.snp.left)
            make.height.equalTo(kInputViewHeight)
        }
        inputTextField.tag = TAG_InputFiled
        inputTextField.font = UIFont.systemFont(ofSize: 12)
        inputTextField.backgroundColor = kInputViewColor
        inputTextField.placeholder = "feedback_placeholder_text_input".localized()
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 30))
        inputTextField.leftView = paddingView
        inputTextField.leftViewMode = .always
        inputTextField.returnKeyType = .done
        NotificationCenter.default.addObserver(self,
            selector: #selector(FeedbackView.keyboardWillShow(notification:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(self,
            selector: #selector(FeedbackView.keyboardWillHide(notification:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
        inputTextField.delegate = self

        addImageButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self)
            self.bottomFieldsConstraint = make.bottom.equalTo(self)
                .offset(-self.kTabBarHeight).constraint
            make.width.equalTo(kAddImageButtonWidth)
            make.height.equalTo(kInputViewHeight)
        }
        addImageButton.backgroundColor = kInputViewColor
        addImageButton.setImage(UIImage(named: "feedback_add_image"), for: .normal)
        addImageButton.contentMode = .scaleAspectFill
        addImageButton.addTarget(delegate,
            action: #selector(FeedbackViewDelegate.addImageButtonClicked(_ :)),
            for: .touchUpInside
        )

        sendButton.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self)
            make.bottom.equalTo(addImageButton)
            make.width.equalTo(kSendButtonWidth)
            make.height.equalTo(kInputViewHeight)
        }
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sendButton.setTitleColor(UIColor(
            red: 137.0 / 255,
            green: 137.0 / 255,
            blue: 137.0 / 255,
            alpha: 1
            ), for: .normal
        )
        sendButton.setTitle("feedback_label_send".localized(), for: .normal)
        sendButton.backgroundColor = kInputViewColor
        sendButton.addTarget(delegate,
            action: #selector(FeedbackViewDelegate.sendButtonClicked(_:)),
            for: .touchUpInside
        )
    }

    // MARK: - Methods
    func currentContact() -> String {
        let contact = self.tableViewHeader.text
        return contact ?? dataSource?.contact ?? ""
    }

    func scrollToBottom() {
        if self.tableView.numberOfRows(inSection: 0) > 1 {
            let lastRowNumber = self.tableView.numberOfRows(inSection: 0) - 1
            let indexPath = IndexPath(row: lastRowNumber, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        if self.tableViewHeader.isFirstResponder {

            return
        }
        guard let animationDuration = notification
            .userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        guard let keyboardFrame = notification
            .userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: animationDuration,
            delay: 0,
            options: .curveEaseInOut,
            animations: { self.updateHeightWhenKeyboardShow(keyboardHeight: keyboardHeight) }) { _ in
                self.scrollToBottom()
        }
    }

    func closeKeyboard(sender: AnyObject) {
        self.inputTextField.resignFirstResponder()
    }

    func keyboardWillHide(notification: NSNotification) {
        if self.tableViewHeader.isFirstResponder {
            return
        }
        UIView.beginAnimations("bottomBarDown", context: nil)
        UIView.setAnimationCurve(.easeInOut)
        self.updateHeightWhenKeyboardHide()
        UIView.commitAnimations()
    }

    func updateHeightWhenKeyboardHide() {
        bottomFieldsConstraint?.update(offset: -kTabBarHeight)
    }

    func updateHeightWhenKeyboardShow(keyboardHeight: CGFloat) {
        bottomFieldsConstraint?.update(offset: -keyboardHeight)
    }
}

// MARK: - UITextFieldDelegate
extension FeedbackView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == TAG_TABLEView_Header &&
            (textField.text?.characters.count)! > 0,
            let userFeedback = dataSource?.userFeedback {
                userFeedback.contact = textField.text
                LCUserFeedbackThread.updateFeedback(userFeedback, with: { (object, error) in
                    _ = self.delegate?.filterError(error)
                })

        }
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension FeedbackView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.feedbackReplies.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kContactHeaderHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        self.tableViewHeader.frame = CGRect(
            x: 0,
            y: 0,
            width: 320,
            height: CGFloat(kContactHeaderHeight)
        )
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
        self.tableViewHeader.leftView = paddingView
        self.tableViewHeader.leftViewMode = .always
        self.tableViewHeader.delegate = self
        self.tableViewHeader.tag = TAG_TABLEView_Header
        self.tableViewHeader.backgroundColor = UIColor(
            red: 247.0 / 255,
            green: 248.0 / 255,
            blue: 248.0 / 255,
            alpha: 1
        )
        self.tableViewHeader.textAlignment = .left
        self.tableViewHeader.placeholder = "feedback_placeholder_contact".localized()
        self.tableViewHeader.font = UIFont.systemFont(ofSize: 12.0)
        if let contact = dataSource?.contact {
            self.tableViewHeader.text = contact
        }
        return tableViewHeader
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath ) -> CGFloat {
        return LCUserFeedbackReplyCell.height(for: dataSource?.feedbackReplies[indexPath.row])
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
            let feedbackReply = dataSource?.feedbackReplies[indexPath.row]
            let cellIdentifier = "feedbackReplyCell"
            var cell = tableView
                .dequeueReusableCell(withIdentifier: cellIdentifier) as? LCUserFeedbackReplyCell
            if cell == nil {
                cell = LCUserFeedbackReplyCell(
                    feedbackReply: feedbackReply,
                    reuseIdentifier: cellIdentifier
                )
                cell!.delegate = delegate
            }
            cell!.configuareCell(with: feedbackReply)
            return cell!
    }
}

@objc
protocol FeedbackViewDelegate: class, LCUserFeedbackReplyCellDelegate {
    func filterError(_ error: Error?) -> Bool
    func handleRefresh(_ sender: UIRefreshControl)
    func sendButtonClicked(_ sender: UIButton)
    func addImageButtonClicked(_ sender: UIButton)

    var navigationController: UINavigationController? { get }
}

protocol FeedbackViewDataSource: class {
    var feedbackReplies: [LCUserFeedbackReply] { get }
    var userFeedback: LCUserFeedbackThread? { get }
    var contact: String? { get }
}
