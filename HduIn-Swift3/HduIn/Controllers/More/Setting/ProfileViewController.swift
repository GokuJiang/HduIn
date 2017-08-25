//
//  ProfileViewController.swift
//  HduIn
//
//  Created by Lucas on 10/12/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import TOCropViewController
import SwiftyJSON
import AVOSCloud

class ProfileViewController: BaseViewController {

    struct ProfileViewData {
        let title: String
        var content: String?
    }

    enum ProfileViewEnum: String {
        case Email = "邮箱"
        case ChangePassword = "修改密码"
    }

    var profileViewRows = [ProfileViewData]()
    var avatarUrl: String?
    let profileView = ProfileView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.title = "个人信息"

        profileView.frame = self.view.frame
        profileView.delegate = self
        profileView.dataSource = self
        self.view = profileView
    }

    func loadData() {
        let user = AVUser.current()
        if let file = user?.object(forKey: "avatar") as? AVFile {
            avatarUrl = file.url
        }

        profileViewRows = [ProfileViewData]()
        let array: [ProfileViewEnum] = [.ChangePassword]
        for item in array {
            var content: String?
            switch item {
            case .Email:
                content = user?.object(forKey: "email") as? String
            default:
                break
            }
            profileViewRows.append(ProfileViewData(title: item.rawValue, content: content))
        }
        profileView.reloadData()
    }
}

// MARK: - ProfileView Delegate

extension ProfileViewController: ProfileViewDelegate {
    func profileView(_ profileView: ProfileView, didSelectAvatar avatar: UIImageView) {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.allowsEditing = false
        picker.delegate = self

        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: kCATransition)
        self.present(picker, animated: false, completion: nil)
    }

    func profileView(_ profileView: ProfileView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let item = ProfileViewEnum(rawValue: profileViewRows[indexPath.item].title)!

        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        self.view.window?.layer.add(transition, forKey: kCATransition)

        switch item {
        case .Email:
            let viewController = ProfileInputController()
            viewController.inputType = .Email
            let navigationController = BaseNavigationController(rootViewController: viewController)
            self.present(navigationController, animated: false, completion: nil)
        case .ChangePassword:
            UIApplication.shared.open(URL(string: "http://pwd.hdu.edu.cn/")!, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - ProfileView DataSource
extension ProfileViewController: ProfileViewDataSource {
     func profileView(_ profileView: ProfileView, itemForRowAtIndexPath indexPath: IndexPath) -> ProfileViewController.ProfileViewData {
        return profileViewRows[indexPath.item]

    }

    func profileView(_ profileView: ProfileView, avatarImage avatar: UIImageView) -> String? {
        return avatarUrl
    }

    func profileView(_ profileView: ProfileView, staffName nameLabel: UILabel) -> String? {
        return UserModel.staffName
    }

    func profileView(
        _ profileView: ProfileView,
        numberOfRowInTableView tableView: UITableView
    ) -> Int {
        return profileViewRows.count
    }


}

// MARK: - UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?
    ) {
        let cropViewController = ImageCropViewController(image: image)
        cropViewController.delegate = self

        picker.navigationController?.pushViewController(cropViewController, animated: true)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]
    ) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let cropViewController = ImageCropViewController(image: pickedImage)
            cropViewController.delegate = self
            cropViewController.forcedAspectRatio = .square
            picker.isNavigationBarHidden = true
            picker.pushViewController(cropViewController, animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        picker.view.window?.layer.add(transition, forKey: kCATransition)
        picker.dismiss(animated: false, completion: nil)
    }
}

// MARK: - TOCropViewControllerDelegate
extension ProfileViewController: ImageCropViewControllerDelegate {
    func cropViewController(
        _ cropViewController: ImageCropViewController!,
        didFinishCancelled cancelled: Bool
    ) {
        cropViewController.navigationController?.isNavigationBarHidden = false
        cropViewController.navigationController?.popViewController(animated: true)
    }

    func cropViewController(
        _ cropViewController: ImageCropViewController!,
        didCropToImage image: UIImage!,
        withRect cropRect: CGRect,
        angle: Int
    ) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionFade
        cropViewController.navigationController?.view.window?.layer.add(
            transition,
            forKey: kCATransition
        )
        cropViewController.navigationController?.dismiss(
            animated: false,
            completion: nil
        )

        profileView.avatarImageView.image = image

        let imageData = UIImagePNGRepresentation(image)
        let file = AVFile(data: imageData!)
        file.saveInBackground({(result, error) -> Void in
            if let error = error {
                log.error("Upload Avatar Failed with error: \(error.localizedDescription)")
            } else if result {
                let user = AVUser.current()
                user?.setObject(file, forKey: "avatar")
                user?.saveInBackground({ (result, error) -> Void in
                    if let error = error {
                        log.error("save user failed with error: \(error.localizedDescription)")
                    } else {
                        log.warning("save user successfully")
                    }
                })
            }
        }) { (progress) -> Void in
            log.warning("Progress: \(progress)")
        }
    }
}

// MARK: - ProfileInputControllerDelegate
extension ProfileViewController: ProfileInputControllerDelegate {
    func profileDismissed() {
        self.loadData()
    }
}

// MARK: - RainbowNavigation
extension ProfileViewController {
    override func navigationBarInColor() -> UIColor {
        return UIColor.clear
    }
}
