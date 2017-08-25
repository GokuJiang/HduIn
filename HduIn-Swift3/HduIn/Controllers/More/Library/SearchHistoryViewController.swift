//
//  SearchHistoryViewController.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/17.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class SearchHistoryViewController: BaseNavigationController {

    var collectionView: UICollectionView!
    var backBtn = UIButton()
    var searchBar = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.backBtn)
        self.view.addSubview(self.searchBar)
        
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(0)
            make.top.equalTo(60)
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(SearchHistoryCollectionViewCell.self, forCellWithReuseIdentifier: "SearchHistoryCollectionViewCell")
        self.collectionView.backgroundColor = UIColor.white
        
        self.collectionView.register(SearchHistoryHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchHistoryHeaderCollectionReusableView")
     
        self.collectionView.register(SearcherHistoryFooterCollectionReusableView.self, forSupplementaryViewOfKind:  UICollectionElementKindSectionFooter, withReuseIdentifier: "SearcherHistoryFooterCollectionReusableView")
        
        self.collectionView.register(HistoryHeadView.self, forSupplementaryViewOfKind:  UICollectionElementKindSectionFooter, withReuseIdentifier: "SearcherHistory")
        
        setBackButton()
        setSearchBar()
        
    }

    
    func setSearchBar(){
        
        searchBar.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.backBtn)
            make.leading.equalTo(10)
            make.trailing.equalTo(self.backBtn.snp.leading).offset(-10)
            make.height.equalTo(28)
        }
        
        let  placestring = NSMutableAttributedString(string:"")
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "library_blacksearch")
        textAttachment.bounds = CGRect(x: 0, y: -3, width: 17, height: 17)
        let attString = NSAttributedString(attachment: textAttachment)
        placestring.append(attString)
        let  placeholder = NSMutableAttributedString(string:" 搜索书名、书号")
        placestring.append(placeholder)
        
        searchBar.attributedPlaceholder = placestring
        searchBar.backgroundColor = UIColor.white
        searchBar.tintColor = UIColor.lightGray
        searchBar.textAlignment = .center
        searchBar.layer.cornerRadius = 5
        searchBar.layer.masksToBounds = true
        searchBar.delegate = self
    }

    func setBackButton(){
        backBtn.setTitle("取消", for: .normal)
        backBtn.backgroundColor = UIColor.clear
        backBtn.titleLabel?.textColor = UIColor.blue
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backBtn.addTarget(self, action: #selector(self.back), for: UIControlEvents.touchUpInside)
        self.backBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 40, height: 25))
            make.trailing.equalTo(-15)
            make.top.equalTo(25)
        }
    }

    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension SearchHistoryViewController: UICollectionViewDelegate{
    
}

extension SearchHistoryViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 10
        }
        return 7
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "SearchHistoryCollectionViewCell", for: indexPath) as? SearchHistoryCollectionViewCell else{
            return UICollectionViewCell()
        }
        if indexPath.section == 0{
            let textColor = [UIColor(hex: "dc6a69"),
                             UIColor(hex: "fb747d"),
                             UIColor(hex: "e5bab1"),
                             UIColor(hex: "6c6c6c")]
            var bookName = ["UI设计规范","数据结构","写给大家看的设计书","设计中的设计","马克思主义","摄影技术","ios交互指南","西天","毛泽东思想","拍出极致"]
            cell.numberLabel.textColor = textColor[(indexPath.row % 2 == 0) && (indexPath.row < 6) ? indexPath.row / 2 : 3]
            cell.numberLabel.text = String(indexPath.row % 2 == 0 ? indexPath.row / 2 + 1 : (indexPath.row - 1) / 2 + 6)
            cell.bookNameLabel.text = bookName[(indexPath.row % 2 == 0 ? indexPath.row / 2 : (indexPath.row - 1) / 2 + 5)]
        }else if indexPath.section == 1{
            cell.historyBookLabel.text = "数据结构"
            cell.searchIamgeView.image = UIImage(named: "Search-Icon-Black")
        }
        return cell
    }
    
}

extension SearchHistoryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: self.view.frame.width / 2 - 18, height: 30)
        }
        return CGSize(width: self.view.frame.width, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: UIScreen.main.bounds.width, height: 58)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: self.view.frame.width, height: 49)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionElementKindSectionHeader{
            if indexPath.section == 0{
                let hotheadview = HistoryHeadView()
                hotheadview.headTitle.text = "本周最热门"
                hotheadview.imageview.image = UIImage(named: "Top-Ten")
                hotheadview.imageview.snp.updateConstraints { (make) in
                    make.width.height.equalTo(34)
                }
                return hotheadview
            }else{
                var headerView = SearchHistoryHeaderCollectionReusableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 58))
                headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHistoryHeaderCollectionReusableView", for: indexPath) as! SearchHistoryHeaderCollectionReusableView
                headerView.headerTitle.text = "历史记录"
                
                headerView.searchIamgeView.snp.makeConstraints({ (make) in
                    make.leading.equalTo(headerView.headerTitle.snp.trailing).offset(33)
                    make.bottom.equalTo(-10)
                    make.width.height.equalTo(24)
                })
                
                headerView.searchIamgeView.image = UIImage(named: "Search-History-Blue")
                return headerView
            }
        }else if kind == UICollectionElementKindSectionFooter{
            if indexPath.section == 0{
                var footerView = SearcherHistoryFooterCollectionReusableView(frame: CGRect(x: 0, y: 0, width: 0, height: 49))
                footerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearcherHistoryFooterCollectionReusableView", for: indexPath) as! SearcherHistoryFooterCollectionReusableView
               
                return footerView
            }
            return UICollectionReusableView()
        }
        return UICollectionReusableView()
    }

}

extension SearchHistoryViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBar.resignFirstResponder()
            
        return true
    }
}



