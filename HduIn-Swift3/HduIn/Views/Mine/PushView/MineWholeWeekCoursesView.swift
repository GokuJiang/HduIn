//
//  MineWholeWeekCoursesView.swift
//  HduIn
//
//  Created by Misaki Haruka on 15/10/12.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit
import RealmSwift

class MineWholeWeekCoursesView: UIView {

    var delegate: MineWholeWeekCoursesViewDelegate? = nil

    var courses: Results<Course>? = nil

    func setData(_ results: Results<Course>) {
        courses = results
        self.setNeedsDisplay()
    }

    func randomIn(_ min: Int, max: Int) -> Int {
        let random = UInt32(arc4random())
        return Int(random % UInt32((max - min + 1) + min))
    }

    // NavigationBar Height, set if needed
    var navHeight = 0.0

    var delWidth: Double!

    let horizontalModifier = 3.0
    let verticalModifier = 2.0
    let horizontalTextFloat = 3.0
    let verticalTextFloat = 2.0
    let round: CGFloat = 6.0
    let rectAlpha = "99"

    let colorReference = ["#e64c66", "#6d69d4", "#ffc800",
        "#13b9cb", "#1d507f", "#eb6100", "#1bbc9b",
        "#19afe9", "#5f52a0"
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        delWidth = Double((self.bounds.width - 30) / 7)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delWidth = Double((self.bounds.width - 30) / 7)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let courses = courses else {
            return
        }

        if courses.count == 0 {
            return
        }

        let delWidth = Double((self.bounds.width - 30) / 7)

        let touch = touches.first!

        let pt = touch.location(in: self)

        let day = Int(Double(pt.x - 30.0) / delWidth)

        let section = Int((Double(pt.y) - navHeight - 30.0) / 39.0) + 1

        let course = courses.filter("weekDay = %@", day + 1).filter {
            $0.startSection <= section && $0.endSection >= section
        }.first

        if let course = course {
            delegate?.showDetail(course)
        }
    }
}

// MARK: - Drawing
extension MineWholeWeekCoursesView {

    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!

        drawBackgroudInContext(ctx)
        drawCoordinate()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2.0
        paragraphStyle.alignment = .center

        var attributes = [
            NSForegroundColorAttributeName: UIColor(hex: "#ffffff"),
            NSParagraphStyleAttributeName: paragraphStyle
        ]

        if #available(iOS 8.2, *) {
            attributes[NSFontAttributeName] = UIFont.systemFont(ofSize: 12, weight: UIFontWeightBold)
        } else {
            attributes[NSFontAttributeName] = UIFont.systemFont(ofSize: 12)
        }

        guard let courses = courses else {
            return
        }

        for index in 0..<7 {
            let startX = Double(index) * delWidth + 30.0 + horizontalModifier
            for course in courses.filter("weekDay = %@", index + 1) {
                drawCourseInContext(ctx, course: course, startX: startX, attributes: attributes)
            }
        }
    }

    func drawCoordinate() {
        let fieldColor: UIColor = UIColor(hex: "#5b7c9a")
        let fieldFont = UIFont.systemFont(ofSize: 13)
        let paraStyle = NSMutableParagraphStyle()
        paraStyle.lineSpacing = 6.0

        let attributes = [
            NSForegroundColorAttributeName: fieldColor,
            NSParagraphStyleAttributeName: paraStyle,
            NSFontAttributeName: fieldFont
        ]

        // Y Axis
        var text: String = "1"

        var yTextRect = CGRect(
            x: 10,
            y: 30.0 + navHeight + 14.0 - 39.0,
            width: 15,
            height: 15
        )
        for i in 1 ... 12 {
            text = String(i)
            if i > 9 {
                yTextRect.origin.x = CGFloat(8)
            }
            yTextRect.origin.y += CGFloat(39.0)
            text.draw(in: yTextRect, withAttributes: attributes)
        }

        // X Axis
        let weekDayMap = ["周一", "周二", "周三", "周四", "周五", "周六", "周日"]
        var xTextRect = CGRect(
            x: 30 + (delWidth / 2 - 13) - delWidth,
            y: 9.0 + navHeight,
            width: 30,
            height: 20
        )
        for i in 0 ... 6 {
            text = weekDayMap[i]
            xTextRect.origin.x += CGFloat(delWidth)
            text.draw(in: xTextRect, withAttributes: attributes)
        }
    }

    func drawBackgroudInContext(_ ctx: CGContext) {
        var rectangle = CGRect(
            x: 0.0,
            y: CGFloat(navHeight),
            width: self.bounds.width,
            height: 30.0
        )

        ctx.addRect(rectangle)

        rectangle.size.height = 39.0
        for i in 2 ... 12 {
            if (i % 2) == 0 {
                rectangle.origin.y = CGFloat(navHeight + 30.0 + Double(i - 1) * 39.0)
                ctx.addRect(rectangle)
            }
        }

        UIColor(hex: "#eeeeee").setFill()

        ctx.setLineWidth(0)

        ctx.drawPath(using: .fillStroke)

        ctx.setLineWidth(0.5)

        UIColor(hex: "#e5e5e5").setStroke()
        ctx.move(to: CGPoint(x: 0, y: CGFloat(navHeight + 30.0)))
        ctx.addLine(to: CGPoint(x: self.bounds.width, y: CGFloat(navHeight + 30.0)))
        for i in 1 ... 11 {
            ctx.move(to: CGPoint(x: 0, y: CGFloat(navHeight + 30.0 + Double(i) * 39.0)))
            ctx.addLine(to: CGPoint(x: self.bounds.width, y: CGFloat(navHeight + 30.0 + Double(i) * 39.0)))
        }
        ctx.move(to: CGPoint(x: 30.0, y: CGFloat(navHeight)))
        ctx.addLine(to: CGPoint(x:30, y: 562))
        for i in 1 ... 7 {
            ctx.move(to: CGPoint(x: CGFloat(30.0 + delWidth * Double(i - 1)), y: CGFloat(navHeight)))
            ctx.addLine(to: CGPoint(x:30 + delWidth * Double(i - 1), y: 562))
        }

        ctx.drawPath(using: .fillStroke)
    }

    func drawCourseInContext(
        _ ctx: CGContext,
        course: Course,
        startX: Double,
        attributes: [String: NSObject]
    ) {
        let startY = Double(course.startSection - 1) * 39.0
            + 30.0 + Double(navHeight) + verticalModifier
        let height = Double(course.endSection - course.startSection + 1) * 39.0

        let courseName: String
        let omoshiroi = "毛泽东思想和中国特色社会主义理论体系概论"
        if course.name == (omoshiroi + "1") || course.name == (omoshiroi + "2") {
            courseName = "毛概"
        } else {
            courseName = course.name
        }

        let text = "\(courseName)@\(course.classroom)"

        let textRect = CGRect(
            x: startX + horizontalTextFloat / 2,
            y: startY + verticalTextFloat,
            width: delWidth - horizontalTextFloat - horizontalModifier,
            height: height - verticalTextFloat - verticalTextFloat
        )

        let rect = CGRect(
            x: startX,
            y: startY,
            width: delWidth - horizontalModifier,
            height: height - verticalModifier
        )
        ctx.move(to: CGPoint(x: rect.origin.x + round, y: rect.origin.y))
        ctx.addLine(to: CGPoint(x:rect.maxX - round, y: rect.origin.y))
        ctx.addArc(
            center: CGPoint(x: rect.maxX - round, y: rect.origin.y + round),
            radius: round,
            startAngle: CGFloat.pi * (-0.5),
            endAngle: 0.0,
            clockwise: false)
        ctx.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - round))
        ctx.addArc(
            center: CGPoint(x: rect.maxX - round, y: rect.maxY - round),
            radius: round,
            startAngle: 0.0,
            endAngle: CGFloat.pi  * 0.5,
            clockwise: false)
  
        ctx.addLine(to: CGPoint(x: rect.maxX + round, y: rect.maxY ))
        ctx.addArc(
            center: CGPoint(x: rect.maxX + round, y: rect.maxY - round),
            radius: round,
            startAngle: CGFloat.pi * 0.5,
            endAngle: CGFloat.pi,
            clockwise: false)
        ctx.addLine(to: CGPoint(x: rect.origin.x, y: rect.origin.y + round ))
        ctx.addArc(
            center: CGPoint(x: rect.origin.x + round, y: rect.origin.y + round),
            radius: round,
            startAngle: CGFloat.pi,
            endAngle: CGFloat.pi * 1.5,
            clockwise: false)

        ctx.closePath()
        UIColor(hex: colorReference[randomIn(0, max: colorReference.count - 1)] + rectAlpha)
            .setFill()
        ctx.setLineWidth(0)

        ctx.drawPath(using: .fillStroke)

        text.draw(in: textRect, withAttributes: attributes)
    }
}

// MARK: - MineWholeWeekCoursesViewDelegate

protocol MineWholeWeekCoursesViewDelegate {
    func showDetail(_ course: Course)
}
