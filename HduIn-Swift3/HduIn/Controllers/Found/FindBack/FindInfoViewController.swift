//
//  FindInfoViewController.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/4/2.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit
import MJRefresh

class FindInfoViewController: UIViewController ,ZHDropDownMenuDelegate{

 
    var collectionView: UICollectionView!
    var searchBar = UITextField()
    
    var provider = APIProvider<FindBackTarget>()
    var model:[FindBack.FindoutFind] = []
    var excatModel: [FindBack.FindoutFind] = []
    var searchModel: [FindBack.FindoutFind] = []
    var isSearch: Bool = false
    var menu = ZHDropDownMenu()
    let menuView = UIView()
    var objList = ["  全部","  一卡通","  书籍资料","  衣物饰品","  交通工具","  随身物品","  电子数码","  卡类物品","  其他物品"]
    var tap: UITapGestureRecognizer?
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    var limit: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "ffffff")
        
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(0)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(LostInfoCollectionViewCell.self, forCellWithReuseIdentifier: "LostInfoCollectionViewCell")
        self.collectionView.backgroundColor = UIColor(hex: "f7f7f7")
        
        setNavigation()
        setSearchBar()
        
        setMenu()
        getData()
        self.header.setRefreshingTarget(self, refreshingAction: #selector(self.headerFresh))
        self.footer.setRefreshingTarget(self, refreshingAction: #selector(self.footerFresh))
        self.collectionView.mj_header = self.header
        self.collectionView.mj_footer = self.footer
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func headerFresh() {
        self.collectionView.mj_header.endRefreshing()
        self.limit = 10
        getData()
    }
    
    func footerFresh(){
        self.collectionView.mj_footer.endRefreshing()
        self.limit += 10
        getData()
    }
    func setNavigation(){
        let rightBar = UIBarButtonItem(image: UIImage(named: "icon-LostFound"), style: .plain, target: self, action:#selector(self.popToHistory))
        rightBar.tintColor = UIColor(hex: "6d6d6d")
        self.navigationItem.rightBarButtonItem = rightBar
        self.collectionView.addSubview(self.menuView)
        self.menuView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(36)
            self.menuView.backgroundColor = UIColor(hex: "ffffff")
        }
    }
    
    func popToHistory(){
        let rootVC = UINavigationController(rootViewController: LostHistoryViewController())
        self.present(rootVC, animated: true, completion: nil)
    }
    
    func setMenu(){
        
        self.collectionView.addSubview(self.menu)
        self.menu.snp.makeConstraints { (make) in
            make.leading.equalTo(36)
            make.top.equalTo(1)
            make.height.equalTo(29)
            make.width.equalTo(120)
        }
        self.menu.options = self.objList
        self.menu.defaultValue = self.objList[0]
        self.menu.delegate = self
        self.menu.buttonImage = UIImage(named: "Triangle-LostFound")
        self.menu.textColor = UIColor(hex: "28bcd2")
        self.menu.font = UIFont(name: ".PingFangSC-Medium", size: 13)
        self.menu.showBorder = false
        
    }
    
    //menu
    //选择完后回调
    func dropDownMenu(_ menu: ZHDropDownMenu!, didChoose index: Int) {
        if self.isSearch{
            searchType(index, self.searchModel)
        }else{
            searchType(index, self.model)
        }
    }
    
    //编辑完成后回调
    func dropDownMenu(_ menu: ZHDropDownMenu!, didInput text: String!) {
    }
    
    func searchType(_ index: Int, _ model: [FindBack.FindoutFind]){
        self.excatModel.removeAll()
        for i in 0..<model.count{
            if index == 0 && model[i].status == 1{
                self.excatModel.append(model[i])
                continue
            }
            if self.model[i].type == index && model[i].status == 1{
                self.excatModel.append(model[i])
            }
        }
        self.collectionView.reloadData()
    }
    
    func setSearchBar(){
        
        
        self.searchBar.frame = CGRect(x: 0, y: 0, width: 282, height: 27)
        
        self.searchBar.delegate = self
        self.searchBar.backgroundColor = UIColor(hex: "e9e9e9")
        self.searchBar.tintColor = UIColor.lightGray
        
        let placeString = NSMutableAttributedString(string: "")
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "search")
        
        textAttachment.bounds = CGRect(x: 10, y: -3, width: 17, height: 17)
        let attString = NSAttributedString(attachment: textAttachment)
        placeString.append(attString)
        
        self.searchBar.attributedPlaceholder = placeString
        self.searchBar.textAlignment = .natural
        self.searchBar.layer.cornerRadius = 4
        self.searchBar.layer.masksToBounds = true
        
        self.searchBar.addTarget(self, action: #selector(self.textDidChange(_:)), for: .allEditingEvents)
        self.navigationItem.titleView = self.searchBar
    }
    
    func getData(){
        let limit = String(self.limit)
        _ = provider.request(.FindoutFind(limit,"0"))
            .mapArray(FindBack.FindoutFind.self)
            .subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                self.model = results
                self.searchType(0, self.model)
            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
            
        }
    }

    func dismissKeyboard(){
        if isSearch{
            self.tap = UITapGestureRecognizer(target: self, action: #selector(self.destroyKeyboard))
            if let tap = self.tap {
                self.view.addGestureRecognizer(tap)
            }
        }else {
            if let tap = self.tap {
                self.view.removeGestureRecognizer(tap)
            }
        }
        
    }
    
    func destroyKeyboard(){
        self.isSearch = false
        setMenu()
        self.searchBar.resignFirstResponder()
        if let tap = self.tap {
            self.view.removeGestureRecognizer(tap)
            self.tap = nil
        }
        self.collectionView.reloadData()
    }
    
    func dismissMenu() {
        _ = self.collectionView.subviews.map { (view) -> Void in
            if view is ZHDropDownMenu {
                view.removeFromSuperview()
            }
        }
         self.collectionView.reloadData()
    }
}

extension FindInfoViewController: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.isSearch = true
        dismissKeyboard()
        return true
    }
    
    func textDidChange(_ textField: UITextField){
        
        if let keyword = textField.text{
            if keyword == "" {
                self.searchType(0, self.model)
            }else{
                dismissMenu()
                _ = provider.request(.searchFind(keyword))
                    .mapArray(FindBack.FindoutFind.self)
                    .subscribe({ (event) in
                        switch event{
                        case .next(let results):
                            self.searchModel = results
                            self.searchType(0, self.searchModel)
                        case .error(let error):
                            log.error(error)
                        case .completed:
                            break
                        }
                    })
            }
        }else{
            self.isSearch = false
            self.searchType(0, self.model)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
    

    
    
    
}

extension FindInfoViewController: UICollectionViewDelegate{
    
}

extension FindInfoViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
        return self.excatModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "LostInfoCollectionViewCell", for: indexPath) as? LostInfoCollectionViewCell
            else{
                return UICollectionViewCell()
        }
        cell.setBezierPath()
        
        let url = URL(string: self.excatModel[indexPath.row].photoURL)
        if let url = url{
            do{
                let data = try Data(contentsOf: url)
                cell.imageView.image = UIImage(data: data)
            }
            catch{
                cell.imageView.image = #imageLiteral(resourceName: "Lack-Photo")
            }
        }else{
            cell.imageView.image = #imageLiteral(resourceName: "Lack-Photo")
        }
        cell.imageView.image = #imageLiteral(resourceName: "Lack-Photo")
        let picName = ["foodCard-LostFound",
                       "book-LostFound",
                       "jacket-LostFound",
                       "bicycle-LostFound",
                       "backpack-LostFound",
                       "digitalProduction-LostFound",
                       "creditCard-LostFound",
                       "coffee-LostFound"]
        let colors: [UIColor] =
            [UIColor(hex: "28bcd2"), UIColor(hex: "a6e3e9"),
             UIColor(hex: "ffe4b3"),UIColor(hex: "45a0e1"),
             UIColor(hex: "bda4eb"),UIColor(hex: "e98c8c"),
             UIColor(hex: "3f72af"),UIColor(hex: "76bda3")]
        
        if let type = self.excatModel[indexPath.row].type, type < picName.count && type > 0{
            cell.attrImageView.image = UIImage(named: picName[type - 1])
            cell.bgLayer.fillColor = colors[type - 1].cgColor
        }else{
            cell.bgLayer.fillColor = colors[0].cgColor
        }
        
        cell.lostContentLabel.text = self.excatModel[indexPath.row].name
        if let type = self.excatModel[indexPath.row].type {
            if type == 0{
                if let staffId = self.excatModel[indexPath.row].studentNumber {
                    cell.numContentLabel.text = "\(staffId)"
                }
            }
        }
        cell.timeContentLabel.text = self.excatModel[indexPath.row].foundTime
        cell.addressContentLabel.text = self.excatModel[indexPath.row].location
        
        cell.setView(mode: .display)
        cell.addressLabel.text = "捡到地点"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.collectionView.deselectItem(at: indexPath, animated: true)
        let vc = DetailViewController()
        
        if let id = self.excatModel[indexPath.row].itemId {
            vc.itemID = String(id)
        }
        vc.mode = .find
        if let studentNumber = self.excatModel[indexPath.row].studentNumber {
            vc.detailView.numberLable.text = "\(studentNumber)"
        }
        vc.detailView.timeLable.text = self.excatModel[indexPath.row].foundTime
        vc.detailView.addressLable.text = self.excatModel[indexPath.row].location
        
        vc.classLable.text = self.excatModel[indexPath.row].name
        let picName = ["foodCard-LostFound",
                       "book-LostFound",
                       "jacket-LostFound",
                       "bicycle-LostFound",
                       "backpack-LostFound",
                       "digitalProduction-LostFound",
                       "creditCard-LostFound",
                       "coffee-LostFound"]
        let colors: [UIColor] =
            [UIColor(hex: "58D5E8"), UIColor(hex: "CDFBFF"),
             UIColor(hex: "FCF0D2"),UIColor(hex: "78C7FF"),
             UIColor(hex: "FCF0D2"),UIColor(hex: "DECFFA"),
             UIColor(hex: "69A3E9"),UIColor(hex: "7BDDC6")]
        vc.icon.image = UIImage(named: picName[0])
        vc.icon.backgroundColor = colors[0]
        if let type = self.excatModel[indexPath.row].type{
            vc.icon.image = UIImage(named: picName[type - 1])
            vc.icon.backgroundColor = colors[type - 1]
        }else{
            vc.icon.backgroundColor = colors[0]
        }
        
        let url = URL(string: self.excatModel[indexPath.row].photoURL)
        if let url = url{
            do{
                let data = try Data(contentsOf: url)
                vc.detailView.image.image = UIImage(data: data)
            }
            catch{
                vc.detailView.image.image = #imageLiteral(resourceName: "Lack-Photo")
            }
        }else{
            vc.detailView.image.image = #imageLiteral(resourceName: "Lack-Photo")
        }
        self.present(vc, animated: true, completion: nil)
    }
}

extension FindInfoViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 37) / 2, height: 212)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 36)
    }
    
}

extension FindInfoViewController: TabViewController {
    func setupTabInfo() {
        let title = "捡到".localized()
        //self.title = title
        let tabBarNoamalImage = #imageLiteral(resourceName: "findgrey").withRenderingMode(.alwaysOriginal)
        let tabBarSelectedImage:UIImage = #imageLiteral(resourceName: "findblue").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: title, image: tabBarNoamalImage,selectedImage: tabBarSelectedImage)
        self.tabBarItem = tabBarItem
    }
}





