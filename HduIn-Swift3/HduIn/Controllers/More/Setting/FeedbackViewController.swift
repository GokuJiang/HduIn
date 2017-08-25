//
//  FeedbackViewController.swift
//  HduIn
//
//  Created by Lucas on 10/9/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import UIKit
import AVOSCloud

class FeedbackViewController: UIViewController, FeedbackViewDelegate, FeedbackViewDataSource {
    var feedbackReplies = [LCUserFeedbackReply]()
    var userFeedback: LCUserFeedbackThread?

    var feedbackCellFont: UIFont = UIFont.systemFont(ofSize: 16)
    var feedbackTitle: String!
    var presented: Bool = true

    var contact: String? = nil

    let feedbackView = FeedbackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackView.frame = self.view.frame
        feedbackView.bounds = self.view.bounds
        feedbackView.delegate = self
        feedbackView.dataSource = self
        self.view = feedbackView
        self.loadFeedbackThreads()
        self.title = "more_title_feedback".localized()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if userFeedback != nil && feedbackReplies.count > 0 {
            let localKey = "feedback_\(userFeedback!.objectId)"
            UserDefaults.standard.set(feedbackReplies.count,
                forKey: localKey
            )
        }
    }

    func fetchRepliesWithBlock(_ block: @escaping AVArrayResultBlock) {
        LCUserFeedbackThread.fetchFeedback({ (feedback, error) in
            if let error = error {
                block(nil, error)
            } else if let feedback = feedback {
                self.userFeedback = feedback
                self.contact = feedback.contact
                self.userFeedback?.fetchFeedbackRepliesInBackground(block)
            } else {
                block([AnyObject](), nil)
            }
        })
    }

    func loadFeedbackThreads() {
        if !feedbackView.refreshControl.isRefreshing {
            feedbackView.refreshControl.beginRefreshing()
        }
        self.fetchRepliesWithBlock({ (objects, error) in
            self.feedbackView.refreshControl.endRefreshing()
            if self.filterError(error as NSError?) {
                if let objects = objects as? [LCUserFeedbackReply] {
                    self.feedbackReplies = []
                    self.feedbackReplies.append(contentsOf: objects)
                    self.feedbackView.tableView.reloadData()
                    self.feedbackView.scrollToBottom()
                }
            }
        })
    }

    func handleRefresh(_ sender: UIRefreshControl) {
        self.loadFeedbackThreads()
    }

    func alertWithTitle(_ title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "label_ok".localized(), style: UIAlertActionStyle.default, handler: { (action) in
            
        }))
        self.present(alertViewController, animated: true, completion: nil)
    }

    func filterError(_ error: Error?) -> Bool {
        if let error = error {
            self.alertWithTitle("title_error_encountered".localized(), message: error.localizedDescription)
            return false
        } else {
            return true
        }
    }

    func addImageButtonClicked(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.isEditing = false
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion: nil)
    }

    func prepareFeedbackWithBlock(_ block: @escaping AVBooleanResultBlock) {
        let contact = feedbackView.currentContact()
        let content = feedbackView.inputTextField.text
        if userFeedback != nil {
            block(true, nil)
        } else {
            self.contact = contact
            var title = feedbackTitle ?? content
            if title?.characters.count == 0 {
                title = "????"
            }
            LCUserFeedbackThread.feedback(withContent: title,
                contact: contact,
                create: true) { (object, error) in
                    if let error = error {
                        block(false, error)
                    } else {
                        self.userFeedback = object as? LCUserFeedbackThread
                        block(true, nil)
                    }
                }
        }
    }

    func sendButtonClicked(_ sender: UIButton) {
        guard let userFeedback = userFeedback else {
            return
        }

        let content = feedbackView.inputTextField.text
        if (content?.characters.count)! > 0 {
            feedbackView.sendButton.isEnabled = false
            self.prepareFeedbackWithBlock({ (succeeded, error) in
                if self.filterError(error as NSError?) {
                    let feedbackReply = LCUserFeedbackReply(content: content, type: LCReplyTypeUser)
                    self.saveFeedbackReply(feedbackReply!, AtFeedback: userFeedback)
                } else {
                    self.feedbackView.sendButton.isEnabled = true
                }
            })
        }
    }

    func saveFeedbackReply(
        _ feedbackReply: LCUserFeedbackReply,
        AtFeedback feedback: LCUserFeedbackThread
    ) {
        userFeedback?.saveFeedbackReply(inBackground: feedbackReply, with: { (object, error) in
            if self.filterError(error as NSError?) {
                self.feedbackReplies.append(feedbackReply)
                self.feedbackView.tableView.reloadData()
                self.feedbackView.scrollToBottom()
                if (self.feedbackView.inputTextField.text?.characters.count)! > 0 {
                    self.feedbackView.inputTextField.text = ""
                }
            }
            self.feedbackView.sendButton.isEnabled = true
        })
    }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate
extension FeedbackViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    fileprivate func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String: AnyObject]
    ) {
        guard let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }

        self.prepareFeedbackWithBlock({ (succeeded, error) in
            if self.filterError(error as NSError?) {
                let attachment = AVFile(
                    name: "feedback.png",
                    data: UIImageJPEGRepresentation(originImage, 0.6)!
                )
                attachment.saveInBackground({ (succeeded, error) in
                    if self.filterError(error as NSError?) {
                        let feedbackReply = LCUserFeedbackReply(
                            attachment: attachment.url,
                            type: LCReplyTypeUser
                        )
                        feedbackReply?.attachmentImage = originImage

                        guard let userFeedback = self.userFeedback else {
                            return
                        }
                        self.saveFeedbackReply(feedbackReply!, AtFeedback: userFeedback)
                    }
                })
            }
        })
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - LCUserFeedbackReplyCellDelegate
extension FeedbackViewController: LCUserFeedbackReplyCellDelegate {
    func didSelectImageView(on feedbackReply: LCUserFeedbackReply!) {
        let imageViewController = LCUserFeedbackImageViewController()
        imageViewController.image = feedbackReply.attachmentImage
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }

}
