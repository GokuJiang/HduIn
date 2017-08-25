//
//  FindBack.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/3/27.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import ObjectMapper

struct FindoutLostModel: Mappable{
    
    enum Mode {
        case find
        case lost
    }
    var mode: Mode = .find
    var name: String = ""
    var foundTime: String = ""
    var lostTime: String = ""
    var location: String = ""
    var type: Int? {
        didSet {
            if let t = self.type {
                self.isCard = (t==1)
            }
        }
    }
    var typeName: String = ""
    var photoURL: String = ""
    var status: Int = 1
    var itemId: Int?
    var studentNumber : String = ""
    var author : String?
    var contact : String = ""
    var descriptionField : String = ""
    var findLocation : String = ""
    var lostLocation: String = ""
    var time : String?
    var photoUrl : String?
    var pickupLocation : String = ""
    var studentName : String = ""
    
    var canUpload: Bool{
        get{
            switch self.mode {
            case .find:
                if !self.isCard {
                        if self.name != "" &&
                        self.type != nil &&
                        self.time != "" &&
                        self.findLocation != "" &&
                        self.pickupLocation != "" &&
                        self.contact != "" {
                        return true
                    }else {
                        return false
                    }
                }else{
                    if self.name != "" &&
                        self.type != nil &&
                        self.studentName != "" &&
                        self.studentNumber != "" &&
                        self.time != "" &&
                        self.findLocation != "" &&
                        self.pickupLocation != "" &&
                        self.contact != ""{
                        return true
                    }else {
                        return false
                    }
                }
            default:
                if !self.isCard {
                    if self.name != "" &&
                        self.type != nil &&
                        self.time != "" &&
                        self.lostLocation != "" &&
                        self.contact != ""{
                        return true
                    }else {
                        return false
                    }
                }else{
                    if self.name != "" &&
                        self.type != nil &&
                        self.studentName != "" &&
                        self.studentNumber != "" &&
                        self.time != "" &&
                        self.lostLocation != "" &&
                        self.contact != ""{
                        return true
                    }else {
                        return false
                    }
                }

            }
           
            
        }
    }
    
    var isCard:Bool = false
    
    init?(map: Map) {
    }

    func toString() -> String{
        var i = 0
        var result = "?"
        if self.name != ""{
            result += "name=\(self.name)"
        }
        if self.pickupLocation != ""{
            result += "&pickup_loaction=\(self.pickupLocation)"
        }
        switch self.mode {
        case .find:
            if self.foundTime != ""{
                let index = self.foundTime.index(self.foundTime.endIndex, offsetBy: -6)
                result += "&find_time=\(self.foundTime.substring(to: index))"
            }
            
            if self.findLocation != ""{
                result += "&find_location=\(self.findLocation)"
            }

        case .lost:
            if self.lostTime != ""{
                let index = self.lostTime.index(self.lostTime.endIndex, offsetBy: -6)
                result += "&find_time=\(self.lostTime.substring(to: index))"
            }
            
            if self.lostLocation != ""{
                result += "&find_location=\(self.lostLocation)"
            }
        }
        if self.descriptionField != ""{
            result += "&description=\(self.descriptionField)"
        }
        if let type = self.type {
            result += "&type=\(type)"
            i += 1
        }
        if self.contact != ""{
            result += "&contact=\(self.contact)"
        }
        if self.studentName != ""{
            result += "&student_name=\(self.studentName)"
        }
        if self.studentNumber != ""{
            result += "&student_number=\(self.studentNumber)"
        }
        if let url = self.photoUrl{
            result += "&photo_url=\(url)"
        }
        result += "&author=\(UserModel.staffId)"
        if let url = result.addingPercentEncoding(withAllowedCharacters: .whitespacesAndNewlines){
            return url
        }
        return result
    }
    
    
    init(){
        
    }
    
    mutating func mapping(map: Map){
        name <- (map["name"])
        studentNumber <- (map["student_number"])
        foundTime <- (map["find_time"])
        location <- (map["find_location"])
        type <- (map["type"])
        photoURL <- (map["photo_url"])
        status <- (map["status"])
        itemId <- (map["id"])
        if let type = type {
            isCard = (type == 1)
        }
    }
    
}




struct FindBack {
    struct FindoutLost: Mappable{
        var name: String = ""
        var foundTime: String = ""
        var location: String = ""
        var type: Int? {
            willSet {
                if let t = newValue {
                    self.isCard = (t==1)
                }
            }
        }
        
        var photoURL: String = ""
        var status: Int = 1
        var itemId: Int?
        var studentNumber : Int?
        var author : String?
        var contact : String?
        var descriptionField : String?
        var findLocation : String?
        var findTime : String?
        var photoUrl : String?
        var pickupLocation : String?
        var studentName : String?
        
        var isCard:Bool = false
        
        init?(map: Map) {
        }
        
        init(){
            
        }
        
        mutating func mapping(map: Map){
            name <- (map["name"])
            studentNumber <- (map["student_number"])
            foundTime <- (map["lost_time"])
            location <- (map["lost_location"])
            type <- (map["type"])
            photoURL <- (map["photo_url"])
            status <- (map["status"])
            itemId <- (map["id"])
            if let type = type {
                isCard = (type == 1)
            }
        }

    }
    
    struct FindoutFind: Mappable {
        var name: String = ""
        var studentNumber: Int?
        var foundTime: String = ""
        var location: String = ""
        var type: Int?
        var photoURL: String = ""
        var status: Int = 1
        var itemId: Int?
        
        
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            name <- (map["name"])
            studentNumber <- (map["student_number"])
            foundTime <- (map["find_time"])
            location <- (map["find_location"])
            type <- (map["type"])
            photoURL <- (map["photo_url"])
            status <- (map["status"])
            itemId <- (map["id"])
        }
    }
    
    struct FindoutItem: Mappable{
        var contact: String = ""
        var description: String = ""
        var pickup: String = ""
        var studentName: String = ""
        
        init?(map: Map){
            
        }
        
        mutating func mapping(map: Map){
            contact <- (map["contact"])
            description <- (map["description"])
            pickup <- (map["pickup_location"])
            studentName <- (map["student_name"])
        }
    }
    
    struct FindoutPost: Mappable {
        var data: [photoURL]?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            data <- (map["data"])
        }
    }
    
    struct photoURL: Mappable {
        var url: String?
        
        init?(map: Map) {
        }

        mutating func mapping(map: Map) {
            url <- (map["file_url"])
        }
    }
    
    struct postData: Mappable {
        var token: String?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            token <- (map["token"])
        }
    }
    
}
