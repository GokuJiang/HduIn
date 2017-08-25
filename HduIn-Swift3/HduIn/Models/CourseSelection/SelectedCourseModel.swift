//
//  SelectedCourseModel.swift
//  HduIn
//
//  Created by 姜永铭 on 15/12/15.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectedCourseModel: NSObject {
    var delegate: selectedCourseModleHttpRequest?
//    let api = APIManager()

    struct CourseData {
        var name: String
        var place: String
        var time: String
        var teacher: String
        var selectCode: String

        init() {
            name = ""
            place = ""
            time = ""
            teacher = ""
            selectCode = ""
        }

        init(fromJSON json: JSON) {
            name = json["name"].stringValue
            place = json["place"].stringValue
            time = json["time"].stringValue
            teacher = json["teacher"].stringValue
            selectCode = json["select_code"].stringValue
        }
    }

    func fetchdata() {
//        api.request(.GET, "selection/selected")
//            .responseJSON(options: NSJSONReadingOptions.AllowFragments) { (response) -> Void in
//                if response.result.isSuccess {
//                    self.delegate!.selectedCourseModel(self, result: response.result.value!)
//                } else {
//                    log.debug("网络通信失败: \(response.result.error)")
//                }
//        }
    }

    func deleteCourse(_ courseId: String) {
//        api.request(.DELETE, "selection/selected/\(courseId)")
    }
}

protocol selectedCourseModleHttpRequest {
    func selectedCourseModel(_ model: SelectedCourseModel, result: AnyObject)
}
