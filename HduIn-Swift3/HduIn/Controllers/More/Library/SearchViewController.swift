//
//  SearchViewController.swift
//  HduIn
//
//  Created by Kevin on 2017/1/16.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit
import MBProgressHUD

class SearchViewController: BaseNavigationController {
    var backBtn = UIButton()
    var searchBar = UITextField()
    var historyTableView = UITableView()
    var hotCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var searchListTableView = UITableView()
    var hotHeadView = HistoryHeadView()
    var provider = APIProvider<LibraryTarget>()
    var rankmodel:[Library.RankList] = []
    var searchmodel:[Library.SearchList] = []
    var searchHistory:NSMutableArray = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        addViews()
        setBackButton()
        setSearchBar()
        setHistoryTableView()
        setHotCollectionView()
        getRankData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addViews(){
        self.view.addSubview(hotHeadView)
        self.view.addSubview(backBtn)
        self.view.addSubview(searchBar)
        self.view.addSubview(historyTableView)
        self.view.addSubview(hotCollectionView)
        self.view.addSubview(searchListTableView)
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
    
    func setSearchBar(){
    
        searchBar.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.backBtn)
            make.leading.equalTo(10)
            make.trailing.equalTo(self.backBtn.snp.leading).offset(-10)
            make.height.equalTo(28)
        }
        
        searchListTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalTo(0)
        }
        searchListTableView.register(SearchResultCell.self, forCellReuseIdentifier: "SearchResultCell")
        searchListTableView.tableFooterView = UIView()
        searchListTableView.rowHeight = 65
        searchListTableView.delegate = self
        searchListTableView.dataSource = self
        searchListTableView.isHidden = true
        
        let  placestring = NSMutableAttributedString(string:"")
        let textAttachment = NSTextAttachment()
        textAttachment.image = UIImage(named: "library_graysearch")
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
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setHotCollectionView(){
        self.hotHeadView.snp.makeConstraints { (make) in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(50)
        }
        hotHeadView.headTitle.text = "本周最热门"
        hotHeadView.imageview.image = UIImage(named: "Top-Ten")
        hotHeadView.imageview.snp.remakeConstraints { (make) in
            make.leading.equalTo(hotHeadView.headTitle.snp.trailing).offset(13)
            make.width.equalTo(26)
            make.height.equalTo(32)
            make.centerY.equalTo(hotHeadView.headTitle)
        }

        
        self.hotCollectionView.register(HotCollectionViewCell.self, forCellWithReuseIdentifier: "HotCollectionViewCell")
        self.hotCollectionView.delegate = self
        self.hotCollectionView.dataSource = self
        self.hotCollectionView.backgroundColor = UIColor.white
        self.hotCollectionView.register(HistoryHeadView.self, forSupplementaryViewOfKind:  UICollectionElementKindSectionHeader, withReuseIdentifier: "HotHeadView")
        self.hotCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(hotHeadView.snp.bottom).offset(0)
            make.bottom.equalTo(historyTableView.snp.top).offset(-23)
            make.leading.trailing.equalTo(0)
        }

       
    }
    
    func setHistoryTableView(){
        
        self.historyTableView.separatorStyle = .none
        self.historyTableView.tableFooterView = UIView()
        self.historyTableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: "HistoryTableViewCell")
        self.historyTableView.rowHeight = 35
        self.historyTableView.delegate = self
        self.historyTableView.dataSource = self
        self.historyTableView.snp.makeConstraints { (make) in
            make.top.equalTo(SCREEN_HEIGHT/2 - 30)
            make.leading.trailing.bottom.equalTo(0)
        }
        let headview = HistoryHeadView()
        self.historyTableView.tableHeaderView = headview

        
    }
    
    func getRankData(){
        _ = provider.request(.rank)
            .mapArray(Library.RankList.self)
            .subscribe({ (event) in
                switch event{
                case .next(let results):
                    log.debug(results)
                    self.rankmodel = results
                    self.hotCollectionView.reloadData()
                case .error(let error):
                    log.error(error)
                case .completed:
                    break
                }
            })

    }
    
    func getSearchData(keyword:String,page:Int){
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.labelText = "正在搜索"
        _ = provider.request(.search(keyword, page))
            .mapArray(Library.SearchList.self)
            .subscribe({ (event) in
                switch event{
                case .next(let results):
                    log.debug(results)
                    self.searchmodel = results
                    self.searchListTableView.reloadData()
                    hud?.hide(true)
                    self.searchListTableView.isHidden = false
                case .error(let error):
                    log.error(error)
                case .completed:
                    break
                }
            })
        
    }
    
}


extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let VC = BorrowDetailViewController()
        VC.bookId = self.searchmodel[indexPath.row].bookId
        let rootVC = UINavigationController(rootViewController: VC)
        self.present(rootVC, animated: true, completion: nil)

    }
}

extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView{
            return self.searchHistory.count

        }else{
            return searchmodel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView{
            let cell = HistoryTableViewCell(style: .default, reuseIdentifier: "HistoryTableViewCell")
            cell.title.text = searchHistory[indexPath.row] as? String
            return cell
        }else{
            let cell = SearchResultCell(style: .default, reuseIdentifier: "SearchResultCell")
            cell.title.text = searchmodel[indexPath.row].title
            cell.author.text = searchmodel[indexPath.row].author
            return cell
        }
        
    }
    
}

extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchBar.resignFirstResponder()
        
        if (searchBar.text != ""){
            searchHistory.insert(searchBar.text as Any, at: 0)
            self.historyTableView.reloadData()
            getSearchData(keyword: searchBar.text!, page: 1)
        }
    
        return true
    }
}

extension SearchViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = BorrowDetailViewController()
        vc.bookId = self.rankmodel[(indexPath.row % 2 == 0 ? indexPath.row / 2 : (indexPath.row - 1) / 2 + 5)].bookId
       
        let rootVC = BaseNavigationController(rootViewController: vc)
        self.present(rootVC, animated: true, completion: nil)
    }
}

extension SearchViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.rankmodel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotCollectionViewCell", for: indexPath) as! HotCollectionViewCell
        cell.number.text = String(indexPath.row % 2 == 0 ? indexPath.row / 2 + 1 : (indexPath.row - 1) / 2 + 6)
        cell.title.text = rankmodel[(indexPath.row % 2 == 0 ? indexPath.row / 2 : (indexPath.row - 1) / 2 + 5)].title
        if(indexPath.row % 2 == 1){
            cell.number.snp.updateConstraints({ (make) in
                make.leading.equalTo(10)
            })
        }
        switch indexPath.row {
            case 0:
                cell.number.textColor = UIColor(hex: "dc6a69")
            case 2:
                cell.number.textColor = UIColor(hex: "fb747d")
            case 4:
                cell.number.textColor = UIColor(hex: "e5bab1")
            default:
                cell.number.textColor = UIColor(hex: "6c6c6c")
            }
            return cell
    }
    
}


extension SearchViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: SCREEN_WIDTH/2 - 5, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
            return  UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
}

