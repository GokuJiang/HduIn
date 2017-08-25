//
//  FIndBackLost.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/4/11.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import Foundation
import RealmSwift

class FindBackLost {
    static let shareInstance = FindBackLost()
    
    static var operatorItem: ItemLost = ItemLost()
    
    subscript(index: Int) -> ItemLost?{
        get{
            do{
                let realm = try Realm()
                let objects = realm.objects(ItemLost.self)
                if objects.count == 0{
                    return nil
                }
                return objects[index]
            }catch{
                return nil
            }
        }
    }
    

    var newItem: ItemLost? {
        didSet{
            do{
                let realm = try Realm()
                try realm.write({
                    if let newOne = self.newItem {
                        realm.add(newOne)
                    }
                })
            }catch{
                
            }
        }
    }
    
    var count: Int?{
        get{
            do{
                let realm = try Realm()
                return realm.objects(ItemLost.self).count
            }catch{
                return 0
            }
        }
    }
    
    var deleteItemId: String? {
        didSet{
            do{
                let realm = try Realm()
                let objects = realm.objects(ItemLost.self)
                var i = 0
                while i < objects.count {
                    if objects[i].itenId == self.deleteItemId {
                        break
                    }
                    i += 1
                }
                try realm.write {
                    realm.delete(objects[i])
                }
            }catch{
                
            }
        }
    }
    
    private init(){}
}
class ItemLost: Object {
    dynamic var itenId: String = ""
    dynamic var name: String = ""
//    dynamic var image: UIImage?
    var type: Int?
}
