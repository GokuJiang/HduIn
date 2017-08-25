//
//  ImageCropViewController.swift
//  HduIn
//
//  Created by Lucas Woo on 10/17/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit
import TOCropViewController

class ImageCropViewController: UIViewController {
    
    enum ImageCropViewAspectRatio: Int {
        case original
        case square
        case ratio3x2
        case ratio5x3
        case ratio4x3
        case ratio5x4
        case ratio7x5
        case ratio16x9
    }
    
    var delegate: ImageCropViewControllerDelegate?
    
    /**
    If performing a transition animation, this block can be used to set up any view states just before the animation begins
    */
    var prepareForTransitionHandler: (() -> Void)!
    
    /**
    If true, when the user hits 'Done', a UIActivityController will appear before the view controller ends
    */
    var showActivitySheetOnDone: Bool = false
    
    /**
    If `showActivitySheetOnDone` is true, then these activity items will be supplied to that UIActivityViewController
    in addition to the `TOActivityCroppedImageProvider` object.
    */
    var activityItems: [Any]!
    
    /**
    If `showActivitySheetOnDone` is true, then you may specify any custom activities your app implements in this array.
    If your activity requires access to the cropping information, it can be accessed in the supplied `TOActivityCroppedImageProvider` object
    */
    var applicationActivities: [UIActivity]!
    
    /**
    If `showActivitySheetOnDone` is true, then you may expliclty set activities that won't appear in the share sheet here.
    */
    var excludedActivityTypes: [UIActivityType]!
    
    var forcedAspectRatio: ImageCropViewAspectRatio?
    
    fileprivate var image: UIImage
    fileprivate var toolbar: CropToolbar!
    fileprivate var cropView: TOCropView!
    fileprivate var snapshotView: UIView!
    fileprivate let transitionController: TOCropViewControllerTransitioning
    fileprivate var activityPopoverController: UIPopoverPresentationController!
    fileprivate var inTransition: Bool = false
    
    init(image: UIImage) {
        self.transitionController = TOCropViewControllerTransitioning()
        self.image = image
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init(image: UIImage())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let landscapeLayout = self.view.frame.width > self.view.frame.height
        self.cropView = TOCropView(image: image)
        self.cropView.frame = CGRect(x: landscapeLayout ? 44 : 0, y: 0 , width: self.view.bounds.width - (landscapeLayout ? 44 : 0), height: self.view.bounds.height - (landscapeLayout ? 0 : 44))
        self.cropView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, .flexibleHeight]
        self.cropView.delegate = self
        self.view.addSubview(cropView)
        
        self.toolbar = CropToolbar()
        self.toolbar.frame = self.frameForToolbarWithVerticalLayout(self.view.bounds.width < self.view.bounds.height)
        self.view.addSubview(self.toolbar)
        
        self.toolbar.doneButtonTapped = { [weak self] in
            self?.doneButtonTapped()
        }
        self.toolbar.cancelButtonTapped = { [weak self] in
            self?.cancelButtonTapped()
        }
        self.toolbar.resetButtonTapped = { [weak self] in
            self?.resetCropViewLayout()
        }
        self.toolbar.clampButtonTapped = { [weak self] in
            self?.showAspectRatioDialog()
        }
        self.toolbar.rotateButtonTapped = { [weak self] in
            self?.rotateCropView()
        }
        
        self.view.backgroundColor = self.cropView.backgroundColor
        
        if let ratio = forcedAspectRatio {
            self.forceAspectRatio(ratio)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIApplication.shared.isStatusBarHidden == false {
            self.inTransition = true
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inTransition = false
        if animated && UIApplication.shared.isStatusBarHidden == false {
            UIView.animate(withDuration: 0.3, animations: self.setNeedsStatusBarAppearanceUpdate)
            if self.cropView.gridOverlayHidden {
                self.cropView.setGridOverlayHidden(false, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.inTransition = true
        UIView.animate(withDuration: 0.5, animations: self.setNeedsStatusBarAppearanceUpdate)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.inTransition = false
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    // MARK: Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default

    }
    
    override var prefersStatusBarHidden: Bool {
        return !self.inTransition
    }
    
 
    
    func frameForToolbarWithVerticalLayout(_ verticalLayout: Bool) -> CGRect {
        var frame = self.toolbar.frame
        if verticalLayout {
            frame = self.toolbar.frame
            frame.origin.x = 0
            frame.origin.y = 0
            frame.size.width = 44
            frame.size.height = self.view.frame.height
        } else {
            frame.origin.x = 0
            frame.origin.y = self.view.bounds.height - 44
            frame.size.width = self.view.bounds.width
            frame.size.height = 44
        }
        return frame
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let verticalLayout = self.view.bounds.width > self.view.bounds.height
        if verticalLayout {
            var frame = self.cropView.frame
            frame.origin.x = 44
            frame.size.width = self.view.bounds.width - 44
            frame.size.height = self.view.bounds.height
            self.cropView.frame = frame
        } else {
            var frame = self.cropView.frame
            frame.origin.x = 0
            frame.size.width = self.view.bounds.width
            frame.size.height = self.view.bounds.height - 44
            self.cropView.frame = frame
        }
        UIView.setAnimationsEnabled(false)
        self.toolbar.frame = self.frameForToolbarWithVerticalLayout(verticalLayout)
        self.toolbar.setNeedsLayout()
        UIView.setAnimationsEnabled(true)
    }
    
    // MARK: Rotation Handling
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.snapshotView = self.toolbar.snapshotView(afterScreenUpdates: false)
        self.snapshotView.frame = self.toolbar.frame
        
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
            self.snapshotView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, .flexibleTopMargin]
        } else {
            self.snapshotView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, .flexibleRightMargin]
        }
        
        self.view.addSubview(self.snapshotView)
        self.toolbar.frame = self.frameForToolbarWithVerticalLayout(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        self.toolbar.layoutIfNeeded()
        
        self.toolbar.alpha = 0
        
        self.cropView.simpleRenderMode = true
        self.cropView.prepareforRotation()
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        self.toolbar.frame = self.frameForToolbarWithVerticalLayout(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        UIView.animate(withDuration: duration) {
            self.snapshotView.alpha = 0
            self.toolbar.alpha = 1
        }
        self.cropView.performRelayoutForRotation()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.snapshotView.removeFromSuperview()
        self.snapshotView = nil
        self.cropView.setSimpleRenderMode(false, animated: true)
    }
    
    // MARK: Reset
    
    func resetCropViewLayout() {
        self.cropView.resetLayoutToDefault(animated: true)
        self.cropView.aspectRatioLockEnabled = false
        self.toolbar.clampButtonGlowing = false
        if let ratio = forcedAspectRatio {
            self.forceAspectRatio(ratio)
        }
    }
    
    // MARK: Aspect Ratio Handling
    
    func showAspectRatioDialog() {
        if self.cropView.aspectRatioLockEnabled {
            self.cropView.aspectRatioLockEnabled = false
            self.toolbar.clampButtonGlowing = false
            return
        }
        var aspectRatio = CGSize.zero

        let verticalCropBox = self.cropView.cropBoxAspectRatioIsPortrait
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Original", style: .default, handler: { (action) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Square", style: .default, handler: { (action) in
            aspectRatio = CGSize(width:1, height:1)
            if self.cropView.cropBoxAspectRatioIsPortrait {
                let width = aspectRatio.width
                aspectRatio.width = aspectRatio.height
                aspectRatio.height = width
            }
            
            self.cropView.setAspectRatio(aspectRatio, animated: true)
            self.toolbar.clampButtonGlowing = true
        }))
        actionSheet.addAction(UIAlertAction(title: verticalCropBox ? "2:3" : "3:2", style: .default, handler: { (action) in
            aspectRatio =  CGSize(width:3, height:2)
            if self.cropView.cropBoxAspectRatioIsPortrait {
                let width = aspectRatio.width
                aspectRatio.width = aspectRatio.height
                aspectRatio.height = width
            }
            
            self.cropView.setAspectRatio(aspectRatio, animated: true)
            self.toolbar.clampButtonGlowing = true
        }))
        actionSheet.addAction(UIAlertAction(title: verticalCropBox ? "3:5" : "5:3", style: .default, handler: { (action) in
             aspectRatio = CGSize(width:5, height:3)
            if self.cropView.cropBoxAspectRatioIsPortrait {
                let width = aspectRatio.width
                aspectRatio.width = aspectRatio.height
                aspectRatio.height = width
            }
            
            self.cropView.setAspectRatio(aspectRatio, animated: true)
            self.toolbar.clampButtonGlowing = true
        }))
        actionSheet.addAction(UIAlertAction(title: verticalCropBox ? "3:4" : "4:3", style: .default, handler: { (action) in
            aspectRatio =  CGSize(width:4, height:3)
            if self.cropView.cropBoxAspectRatioIsPortrait {
                let width = aspectRatio.width
                aspectRatio.width = aspectRatio.height
                aspectRatio.height = width
            }
            
            self.cropView.setAspectRatio(aspectRatio, animated: true)
            self.toolbar.clampButtonGlowing = true
        }))
        actionSheet.addAction(UIAlertAction(title: verticalCropBox ? "4:5" : "5:4", style: .default, handler: { (action) in
            aspectRatio = CGSize(width:5, height:4)
            if self.cropView.cropBoxAspectRatioIsPortrait {
                let width = aspectRatio.width
                aspectRatio.width = aspectRatio.height
                aspectRatio.height = width
            }
            
            self.cropView.setAspectRatio(aspectRatio, animated: true)
            self.toolbar.clampButtonGlowing = true
        }))
        actionSheet.addAction(UIAlertAction(title: verticalCropBox ? "5:7" : "7:5", style: .default, handler: { (action) in
            aspectRatio =  CGSize(width:7, height:5)
            if self.cropView.cropBoxAspectRatioIsPortrait {
                let width = aspectRatio.width
                aspectRatio.width = aspectRatio.height
                aspectRatio.height = width
            }
            
            self.cropView.setAspectRatio(aspectRatio, animated: true)
            self.toolbar.clampButtonGlowing = true
        }))
        actionSheet.addAction(UIAlertAction(title: verticalCropBox ? "9:16" : "16:9", style: .default, handler: { (action) in
            aspectRatio =  CGSize(width:16, height:9)
            if self.cropView.cropBoxAspectRatioIsPortrait {
                let width = aspectRatio.width
                aspectRatio.width = aspectRatio.height
                aspectRatio.height = width
            }
            
            self.cropView.setAspectRatio(aspectRatio, animated: true)
            self.toolbar.clampButtonGlowing = true
        }))
        
        
        self.present(actionSheet, animated: true) { 
            
        }

    }
    
    func rotateCropView() {
        self.cropView.rotateImageNinetyDegrees(animated: true)
        if let ratio = forcedAspectRatio {
            self.forceAspectRatio(ratio)
        }
    }
    
    func forceAspectRatio(_ ratio: ImageCropViewAspectRatio) {
        var aspectRatio = CGSize(width: 0, height: 0)
        
        switch ratio {
        case .original:
            break
        case .square:
            aspectRatio =  CGSize(width: 1, height: 1)
            break
        case .ratio3x2:
            aspectRatio = CGSize(width: 3, height: 2)
            break
        case .ratio5x3:
            aspectRatio = CGSize(width: 5, height: 3)
            break
        case .ratio4x3:
            aspectRatio = CGSize(width: 4, height: 3)
            break
        case .ratio5x4:
            aspectRatio = CGSize(width: 5, height: 4)
            break
        case .ratio7x5:
            aspectRatio = CGSize(width: 7, height: 5)
            break
        case .ratio16x9:
            aspectRatio = CGSize(width: 16, height: 9)
            break
        }
        
        if self.cropView.cropBoxAspectRatioIsPortrait {
            let width = aspectRatio.width
            aspectRatio.width = aspectRatio.height
            aspectRatio.height = width
        }
        self.cropView.setAspectRatio(aspectRatio, animated: true)
        self.toolbar.clampButtonHidden = true
    }
    
    // MARK: Button Feedback
    
    func cancelButtonTapped() {
        if let delegate = delegate {
            delegate.cropViewController(self, didFinishCancelled: true)
            return
        }
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonTapped() {
        let cropFrame = self.cropView.imageCropFrame
        let angle = self.cropView.angle
        
        if self.showActivitySheetOnDone {
            
            let imageItem = TOActivityCroppedImageProvider(image: self.image, cropFrame: cropFrame, angle: angle, circular: true)
            let attributes = TOCroppedImageAttributes(croppedFrame: cropFrame, angle: angle, originalImageSize: self.image.size)
            
            var activityItems = [imageItem, attributes]
            if self.activityItems != nil {
                activityItems.append(self.activityItems as NSObject?)
            }
            guard let _activityItems = self.activityItems else{
                return
            }
            let activityController = UIActivityViewController(activityItems: _activityItems, applicationActivities: self.applicationActivities)

            activityController.excludedActivityTypes = self.excludedActivityTypes
            
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
                self.present(activityController, animated: true, completion: nil)
            } else {
                self.activityPopoverController.dismissalTransitionDidEnd(false)
                self.activityPopoverController  = UIPopoverPresentationController(presentedViewController: activityController, presenting: nil)
                self.activityPopoverController.presentationTransitionDidEnd(true)
            }
            
            activityController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                if !completed {
                    return
                }
                
                if let delegate = self.delegate {
                    delegate.cropViewController(self, didFinishCancelled: false)
                } else {
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                    activityController.completionWithItemsHandler = nil
                }
            }
            return
        }
        
        if let delegate = self.delegate {
            let image: UIImage
            if angle == 0 && cropFrame.equalTo(CGRect(origin: CGPoint(x: 0, y: 0), size: self.image.size)) {
                image = self.image
            } else {
                image = self.image.croppedImage(withFrame: cropFrame, angle: angle, circularClip: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03, execute: { 
                delegate.cropViewController(self, didCropToImage: image, withRect: cropFrame, angle: angle)

            })

        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

}

// MARK: - TOCropViewDelegate
extension ImageCropViewController: TOCropViewDelegate {
    func cropViewDidBecomeResettable(_ cropView: TOCropView) {
        self.toolbar.resetButtonEnabled = true
    }
    
    func cropViewDidBecomeNonResettable(_ cropView: TOCropView) {
        self.toolbar.resetButtonEnabled = false
    }


}


// MARK: - ImageCropperControllerDelegate Protocol
protocol ImageCropViewControllerDelegate {
    func cropViewController(_ cropViewController: ImageCropViewController!, didFinishCancelled cancelled: Bool)
    func cropViewController(_ cropViewController: ImageCropViewController!, didCropToImage image: UIImage!, withRect cropRect: CGRect, angle: Int)
    
}


