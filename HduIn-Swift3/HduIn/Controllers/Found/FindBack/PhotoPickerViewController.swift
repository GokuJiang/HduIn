//
//  PhotoPickerViewController.swift
//  Rank
//
//  Created by 姜永铭 on 8/13/16.
//  Copyright © 2016 姜永铭. All rights reserved.
//

import UIKit

protocol PhotoPickerDelegate {
    func getImageFromPicker(photoPickerViewController:PhotoPickerViewController,imageInfo info:[String:Any], imageData data:Data)
}

class PhotoPickerViewController: UIViewController {

    var alert:UIAlertController?
    var picker:UIImagePickerController = UIImagePickerController()
    var delegate:PhotoPickerDelegate?
    
    var isUpdate = false
    var selectedIndex = 0
    init(){
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        self.view.backgroundColor = UIColor.clear
        
        self.picker.allowsEditing = false
        self.picker.delegate = self
        
        _ = UITapGestureRecognizer(target: self, action: #selector(self.dismisViewController))
//        self.view.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func dismisViewController(){
        self.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.alert == nil {
            self.alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            self.alert?.addAction(UIAlertAction(title: "从相册中选择", style: UIAlertActionStyle.default, handler: { (action) in
                self.localPhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "打开相机", style: UIAlertActionStyle.default, handler: { (action) in
                self.takePhoto()
            }))
            self.alert?.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
                self.dismisViewController()
            }))
            
            self.present(self.alert!, animated: true, completion: nil)
        }

    }
    
    /**
     open carema
     */
    
    func takePhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }else {
            let alertView = UIAlertController(title: "此机型无相机", message: nil, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "关闭", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    /**
     open photo library
     */
    func localPhoto(){
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }
    
    
}

extension PhotoPickerViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.picker.dismiss(animated: true) { 
            self.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.picker.dismiss(animated: true) {
            guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else{
                return
            }
            guard let data = UIImagePNGRepresentation(pickedImage) else {
                return
            }

            self.dismiss(animated: true, completion: {
                self.delegate?.getImageFromPicker(photoPickerViewController: self, imageInfo: info, imageData: data)
            })
        }

    }

}
