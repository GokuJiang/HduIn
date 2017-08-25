//
//  DetailViewController.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/13.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {
    var detailView = ObjectDetailView()
    var showButton = UIButton()
    var icon = UIImageView()
    var classLable = UILabel()
    var backButton = UIButton()
    var isShow:Int = 1
    
    enum Mode {
        case find
        case lost
    }
    
    var mode: Mode = .find{
        didSet{
            switch  self.mode{
            case .find:
                self.getData(.find)
            case .lost:
                self.getData(.lost)
            }
        }
    }
    
    
    var provider = APIProvider<FindBackTarget>()
    var model:FindBack.FindoutItem?
    var itemID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 40/255, green: 188/255, blue: 210/255, alpha: 1)

        showBackActionButton()
        addViews()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addViews(){
        self.view.addSubview(detailView)
        self.view.addSubview(showButton)
        self.view.addSubview(icon)
        self.view.addSubview(classLable)
        self.view.addSubview(backButton)
    }
    
    func setupViews(){
        self.detailView.snp.makeConstraints { (make) in
            make.leading.equalTo(17)
            make.trailing.equalTo(-17)
            make.top.equalTo(82)
            make.height.equalTo(300)

        }
        
        self.showButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(-30)
            make.width.height.equalTo(80)
            showButton.layer.cornerRadius = 40
            showButton.layer.masksToBounds = true
            showButton.backgroundColor = UIColor(red: 87/255, green: 213/255, blue: 232/255, alpha: 1)
            showButton.setTitle("查看\n详情", for: .normal)
            showButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            showButton.titleLabel?.numberOfLines = 2
            showButton.setTitleColor(UIColor.white, for: .normal)
            showButton.addTarget(self, action: #selector(self.showDetail), for: .touchUpInside)
        }
        
        self.classLable.snp.makeConstraints { (make) in
            make.trailing.equalTo(-16)
            make.top.equalTo(38)
            make.width.greaterThanOrEqualTo(40)
            make.height.greaterThanOrEqualTo(20)
            classLable.textColor = UIColor.white
            classLable.font = UIFont.systemFont(ofSize: 18)
        }
        self.icon.snp.makeConstraints { (make) in
            make.trailing.equalTo(classLable.snp.leading).offset(-6)
            make.centerY.equalTo(classLable)
            make.width.height.equalTo(32)
            self.icon.layer.cornerRadius = 16
            self.icon.layer.masksToBounds = true
        }
        self.backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.top.equalTo(40)
            make.width.equalTo(13)
            make.height.equalTo(22)
            backButton.setImage(UIImage(named:"Navigation-BackWhite"), for: .normal)
            backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
        }
    }
    
    func showDetail(){
    
        if isShow == 0{
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.0)
            self.isShow = 1
            
            self.showButton.setTitle("查看\n详情", for: .normal)
            self.detailView.snp.updateConstraints({ (make) in
                make.height.equalTo(300)
            })
        
            UIView.commitAnimations()
        }else{
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.0)
            self.isShow = 0
            self.showButton.setTitle("收起", for: .normal)
            self.detailView.snp.updateConstraints({ (make) in
                make.height.equalTo(480)
            })
           UIView.commitAnimations()
        }
    }
    
    func getData(_ mode: Mode){
        switch mode {
        case .find:
            self.detailView.telTitle.text = "热心同学联系方式"
            if let itemID = self.itemID {
                _ = provider
                    .request(.FindoutFindItem(itemID))
                    .mapObject(FindBack.FindoutItem.self)
                    .subscribe({ (event) in
                        switch event{
                        case .next(let results):
                            log.debug(results)
                            self.model = results
                            if let model = self.model {
                                self.detailView.nameLable.text = model.studentName
                                self.detailView.localLable.text = model.pickup
                                self.detailView.detailLable.text = model.description
                                self.detailView.telLable.text = model.contact
                            }
                        case .error(let error):
                            log.error(error)
                        case .completed:
                            break
                        }
                })
                
            }
            
        case .lost:
            self.detailView.addressTitle.text = "丢失地点："
            self.detailView.telTitle.text = "丢失同学联系方式"
            if let itemID = self.itemID {
                _ = provider
                    .request(.FindoutLostItem(itemID))
                    .mapObject(FindBack.FindoutItem.self)
                    .subscribe({ (event) in
                        switch event{
                        case .next(let results):
                            log.debug(results)
                            self.model = results
                            if let model = self.model {
                                self.detailView.nameLable.text = model.studentName
                                self.detailView.localLable.text = model.pickup
                                self.detailView.detailLable.text = model.description
                                self.detailView.telLable.text = model.contact
                            }
                        case .error(let error):
                            log.error(error)
                        case .completed:
                            break
                        }
                    })
            }
        }
        
        
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
