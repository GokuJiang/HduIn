//
//  programInformationModel.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/2/10.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
class programInformationModel{
    var title: String
    var time: String
    var issue: String
    var date: String
    var pageView: String
    
    init(title: String, time: String, issue: String, date: String, pageView: String) {
        self.title = title
        self.time = time
        self.issue = issue
        self.date = date
        self.pageView = pageView
    }
}
