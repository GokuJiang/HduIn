//
//  CropToolbar.swift
//  HduIn
//
//  Created by Lucas Woo on 10/17/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class CropToolbar: UIView {
    /* Button feedback handler blocks */
    var cancelButtonTapped: (() -> Void)?
    var doneButtonTapped: (() -> Void)?
    var rotateButtonTapped: (() -> Void)?
    var clampButtonTapped: (() -> Void)?
    var resetButtonTapped: (() -> Void)?

    /* Aspect ratio button settings */
    fileprivate  var _clampButtonGlowing = false
    var clampButtonGlowing: Bool {
        get {
            return _clampButtonGlowing
        }
        set {
            if _clampButtonGlowing == newValue {
                return
            }

            _clampButtonGlowing = newValue

            if _clampButtonGlowing {
                self.clampButton.tintColor = nil
            } else {
                self.clampButton.tintColor = UIColor.white
                
            }
        }
    }
    fileprivate var _clampButtonHidden = false
    var clampButtonHidden: Bool {
        get {
            return _clampButtonHidden
        }
        set {
            if _clampButtonHidden == newValue {
                return
            }
            _clampButtonHidden = newValue
            self.setNeedsLayout()
        }
    }

    /* Disable the rotate button */
    fileprivate var _rotateButtonHidden = false
    var rotateButtonHidden: Bool {
        get {
            return _rotateButtonHidden
        }
        set {
            if _rotateButtonHidden == newValue {
                return
            }
            _rotateButtonHidden = newValue
            self.setNeedsLayout()
        }
    }

    /* Enable the reset button */
    var resetButtonEnabled: Bool {
        get {
            return self.resetButtonEnabled
        }
        set {
            self.resetButton.isEnabled = newValue
        }
    }

    // MARK: private Properties
    fileprivate let doneTextButton = UIButton(type: UIButtonType.system)
    fileprivate let doneIconButton = UIButton(type: UIButtonType.system)

    fileprivate let cancelTextButton = UIButton(type: UIButtonType.system)
    fileprivate let cancelIconButton = UIButton(type: UIButtonType.system)

    fileprivate let rotateButton = UIButton(type: UIButtonType.system)
    fileprivate let resetButton = UIButton(type: UIButtonType.system)
    fileprivate let clampButton = UIButton(type: UIButtonType.system)

    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.backgroundColor = UIColor(white: 0.12, alpha: 1)

        doneTextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        doneTextButton.setTitle("Done", for: UIControlState.normal)
        doneTextButton.setTitleColor(
            UIColor(
                red: 1,
                green: 0.8,
                blue: 0,
                alpha: 1
            ),
            for: .normal
        )
        doneTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        doneTextButton.addTarget(
            self,
            action: #selector(CropToolbar.buttonTapped(_ :)),
            for: .touchUpInside
        )
        self.addSubview(doneTextButton)

        doneIconButton.setImage(CropToolbar.doneImage(), for: .normal)
        doneIconButton.setTitleColor(UIColor(
            red: 1,
            green: 0.8,
            blue: 0,
            alpha: 1
        ), for: .normal)
        doneIconButton.addTarget(self,
            action: #selector(CropToolbar.buttonTapped(_ :)),
            for: .touchUpInside
        )
        self.addSubview(doneIconButton)

        cancelTextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        cancelTextButton.setTitle("Cancel", for: UIControlState.normal)
        cancelTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelTextButton.addTarget(self,
            action: #selector(CropToolbar.buttonTapped(_ :)),
            for: .touchUpInside
        )
        self.addSubview(cancelTextButton)

        cancelIconButton.setImage(CropToolbar.cancelImage(), for: .normal)
        cancelIconButton.addTarget(self,
            action: #selector(CropToolbar.buttonTapped(_:)),
            for: .touchUpInside
        )
        self.addSubview(cancelIconButton)

        clampButton.contentMode = UIViewContentMode.center
        clampButton.tintColor = UIColor.white
        clampButton.setImage(CropToolbar.clampImage(), for: .normal)
        clampButton.addTarget(self,
            action: #selector(CropToolbar.buttonTapped(_:)),
            for: .touchUpInside
        )
        self.addSubview(clampButton)

        rotateButton.contentMode = UIViewContentMode.center
        rotateButton.tintColor = UIColor.white
        rotateButton.setImage(CropToolbar.rotateImage(), for: .normal)
        rotateButton.addTarget(self,
            action: #selector(CropToolbar.buttonTapped(_:)),
            for: .touchUpInside
        )
        self.addSubview(rotateButton)

        resetButton.contentMode = UIViewContentMode.center
        resetButton.tintColor = UIColor.white
        
        
        resetButton.isEnabled = false
        resetButton.setImage(CropToolbar.resetImage(), for: UIControlState.normal)
        resetButton.addTarget(self,
            action: #selector(CropToolbar.buttonTapped(_:)),
            for: .touchUpInside
        )
        self.addSubview(resetButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let verticalLayout = self.bounds.width < self.bounds.height
        let boundsSize = self.bounds.size

        self.cancelIconButton.isHidden = !verticalLayout
        self.cancelTextButton.isHidden = verticalLayout
        self.doneIconButton.isHidden = !verticalLayout
        self.doneTextButton.isHidden = verticalLayout

        self.rotateButton.isHidden = self.rotateButtonHidden
        self.clampButton.isHidden = self.clampButtonHidden

        if !verticalLayout {
            var frame = CGRect.zero
            frame.size.height = 44
            if let textLabel = self.cancelTextButton.titleLabel {
                frame.size.width = (
                    textLabel.text == nil ?
                    "" :
                        textLabel.text! as NSString
                ).size(attributes: [NSFontAttributeName: textLabel.font]).width + 10
            }
            self.cancelTextButton.frame = frame

            if let titleLabel = self.doneTextButton.titleLabel {
                frame.size.width = (
                    titleLabel.text == nil ?
                    "" :
                        titleLabel.text! as NSString
                ).size(attributes: [NSFontAttributeName: titleLabel.font]).width + 10
            }
            frame.origin.x = boundsSize.width - frame.width
            self.doneTextButton.frame = frame

            var containerRect = CGRect(x: 0, y: 0, width: 165, height: 44)
            containerRect.origin.x = (self.bounds.width - containerRect.width) * 0.5
            var buttonFrame = CGRect(x: 0, y: 0, width: 44, height: 44)
            if self.rotateButtonHidden {
                buttonFrame.origin.x = containerRect.minX
                self.resetButton.frame = buttonFrame
            } else {
                buttonFrame.origin.x = containerRect.minX
                self.rotateButton.frame = buttonFrame

                buttonFrame.origin.x = containerRect.midX - 22
                self.resetButton.frame = buttonFrame
            }

            buttonFrame.origin.x = containerRect.maxX - 44
            self.clampButton.frame = buttonFrame
        } else {
            var frame = CGRect.zero
            frame.size.height = 44.0
            frame.size.width = 44.0
            frame.origin.y = self.bounds.height - 44.0
            self.cancelIconButton.frame = frame

            frame.origin.y = 0.0
            frame.size.width = 44.0
            frame.size.height = 44.0
            self.doneIconButton.frame = frame

            var containerRect = CGRect(x: 0, y: 0, width: 44.0, height: 165.0)
            containerRect.origin.y = (self.bounds.height - containerRect.height) * 0.5

            var buttonFrame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)

            if self.rotateButtonHidden {
                buttonFrame.origin.y = containerRect.minY
                self.resetButton.frame = buttonFrame
            } else {
                buttonFrame.origin.y = containerRect.minY
                self.rotateButton.frame = buttonFrame

                buttonFrame.origin.y = containerRect.midY - 22.0
                self.resetButton.frame = buttonFrame
            }

            buttonFrame.origin.y = containerRect.maxY - 44.0
            self.clampButton.frame = buttonFrame
        }
    }

    func buttonTapped(_ sender: UIButton) {
        if sender == self.cancelTextButton || sender == self.cancelIconButton {
            self.cancelButtonTapped?()
        } else if sender == self.doneTextButton || sender == self.doneIconButton {
            self.doneButtonTapped?()
        } else if sender == self.rotateButton {
            self.rotateButtonTapped?()
        } else if sender == self.resetButton {
            self.resetButtonTapped?()
        } else if sender == self.clampButton {
            self.clampButtonTapped?()
        }
    }

    func clampButtonFrame() -> CGRect {
        return self.clampButton.frame
    }

    func doneButtonFrame() -> CGRect {
        if self.doneIconButton.isHidden == false {
            return self.doneIconButton.frame
        }
        return self.doneTextButton.frame
    }

    // MARK: Image Generator

    static func doneImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 17, height: 14), false, 0)
        let rectanglePath = UIBezierPath()
        rectanglePath.move(to: CGPoint(x: 1, y: 7))
        rectanglePath.addLine(to: CGPoint(x: 6, y: 12))
        rectanglePath.addLine(to: CGPoint(x: 16, y: 1))
        UIColor.white
            .setStroke()
        rectanglePath.stroke()
        let doneImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return doneImage!
    }

    static func cancelImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 16, height: 16), false, 0)
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 15, y: 15))
        bezierPath.addLine(to: CGPoint(x: 1, y: 1))
        UIColor.white.setStroke()
        bezierPath.lineWidth = 2
        bezierPath.stroke()

        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 1, y: 15))
        bezier2Path.addLine(to: CGPoint(x: 15, y: 1))
        UIColor.white.setStroke()
        bezier2Path.lineWidth = 2
        bezier2Path.stroke()

        let cancelImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cancelImage!
    }

    static func rotateImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 18, height: 21), false, 0)
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 0, y: 9, width: 12, height: 12))
        UIColor.white.setFill()
        rectangle2Path.fill()

        let rectangle3Path = UIBezierPath()
        rectangle3Path.move(to: CGPoint(x: 5, y: 3))
        rectangle3Path.addLine(to: CGPoint(x: 10, y: 6))
        rectangle3Path.addLine(to: CGPoint(x: 10, y: 0))
        rectangle3Path.addLine(to: CGPoint(x: 5, y: 3))
        rectangle3Path.close()
        UIColor.white.setFill()
        rectangle3Path.fill()

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 10, y: 3))
        bezierPath.addCurve(
            to: CGPoint(x: 17.5, y: 11),
            controlPoint1: CGPoint(x: 15, y: 3),
            controlPoint2: CGPoint(x: 17.5, y: 5.91)
        )
        UIColor.white.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.stroke()

        let rotateImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotateImage!
    }

    static func resetImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22, height: 18), false, 0)
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 22, y: 9))
        bezier2Path.addCurve(
            to: CGPoint(x: 13, y: 18),
            controlPoint1: CGPoint(x: 22, y: 13.97),
            controlPoint2: CGPoint(x: 17.97, y: 18))
        bezier2Path.addCurve(
            to: CGPoint(x: 13, y: 16),
            controlPoint1: CGPoint(x: 13, y: 17.35),
            controlPoint2: CGPoint(x: 13, y: 16.68))
        bezier2Path.addCurve(
            to: CGPoint(x: 20, y: 9),
            controlPoint1: CGPoint(x: 16.87, y: 16),
            controlPoint2: CGPoint(x: 20, y: 12.87))
        bezier2Path.addCurve(
            to: CGPoint(x: 13, y: 2),
            controlPoint1: CGPoint(x: 20, y: 5.13),
            controlPoint2: CGPoint(x: 16.87, y: 2))
        bezier2Path.addCurve(
            to: CGPoint(x: 6.55, y: 6.27),
            controlPoint1: CGPoint(x: 10.1, y: 2),
            controlPoint2: CGPoint(x: 7.62, y: 3.76))
        bezier2Path.addCurve(
            to: CGPoint(x: 6, y: 9),
            controlPoint1: CGPoint(x: 6.2, y: 7.11),
            controlPoint2: CGPoint(x: 6, y: 8.03))
        bezier2Path.addLine(to: CGPoint(x: 4, y: 9))
        bezier2Path.addCurve(
            to: CGPoint(x: 4.65, y: 5.63),
            controlPoint1: CGPoint(x: 4, y: 7.81),
            controlPoint2: CGPoint(x: 4.23, y: 6.67))
        bezier2Path.addCurve(
            to: CGPoint(x: 7.65, y: 1.76),
            controlPoint1: CGPoint(x: 5.28, y: 4.08),
            controlPoint2: CGPoint(x: 6.32, y: 2.74))
        bezier2Path.addCurve(
            to: CGPoint(x: 13, y: 0),
            controlPoint1: CGPoint(x: 9.15, y: 0.65),
            controlPoint2: CGPoint(x: 11, y: 0))
        bezier2Path.addCurve(
            to: CGPoint(x: 22, y: 9),
            controlPoint1: CGPoint(x: 17.97, y: 0),
            controlPoint2: CGPoint(x: 22, y: 4.03))
        bezier2Path.close()
        UIColor.white.setFill()
        bezier2Path.fill()

        //// Polygon Drawing
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 5, y: 15))
        polygonPath.addLine(to: CGPoint(x: 10, y: 9))
        polygonPath.addLine(to: CGPoint(x: 0, y: 9))
        polygonPath.addLine(to: CGPoint(x: 5, y: 15))
        polygonPath.close()
        UIColor.white.setFill()
        polygonPath.fill()

        let resetImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resetImage!
    }

    static func clampImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 22, height: 16), false, 0)
        //// Color Declarations
        let outerBox = UIColor(red: 1, green: 1, blue: 1, alpha: 0.553)
        let innerBox = UIColor(red: 1, green: 1, blue: 1, alpha: 0.773)

        //// Rectangle Drawing
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 3, width: 13, height: 13))
        UIColor.white.setFill()
        rectanglePath.fill()

        //// Outer
        //// Top Drawing
        let topPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 22, height: 2))
        outerBox.setFill()
        topPath.fill()

        //// Side Drawing
        let sidePath = UIBezierPath(rect: CGRect(x: 19, y: 2, width: 3, height: 14))
        outerBox.setFill()
        sidePath.fill()

        //// Rectangle 2 Drawing
        let rectangle2Path = UIBezierPath(rect: CGRect(x: 14, y: 3, width: 4, height: 13))
        innerBox.setFill()
        rectangle2Path.fill()

        let clampImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return clampImage!
    }
}
