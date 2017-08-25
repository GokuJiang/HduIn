//
//  BorrowDetailViewController.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/1/14.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class BorrowDetailViewController: BaseViewController {
    
    var tableView = UITableView()
    var provider = APIProvider<LibraryTarget>()
    var model: BookInfo?
    var bookId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
        self.tableView.separatorStyle = .none
        self.tableView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.top.equalTo(0)
        }
        self.tableView.register(BorrowDetailTableViewCell.self, forCellReuseIdentifier: "BorrowDetailTableViewCell")
        getData()
        
        
        let leftBarBtn = UIBarButtonItem(image: UIImage(named: "Library-Back"), style: .plain, target: self, action: #selector(BorrowDetailViewController.backToPrevious))
        self.title = "图书详情"
        self.navigationController?.navigationBar.barTintColor = HIColor.HduInBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        
        leftBarBtn.image = UIImage(named: "Navigation-BackWhite")
        leftBarBtn.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarBtn
        
    }
    
    func setHeader(data: BookInfo){
        let bgView = HeaderBorrowDetailView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 236))
        bgView.bookNameLabel.numberOfLines = 3
        bgView.bookNameLabel.lineBreakMode = .byWordWrapping
        
        bgView.bookNameLabel.text = data.title
        bgView.authorNameLabel.text = data.author! + "编著"
        bgView.publishHouseLabel.text = "出版社：" + data.publisher!
        bgView.bookReferenceLabel.text = "索书号：" + data.position!
        
        
        self.tableView.tableHeaderView = bgView
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func getData(){
        if let bookId = self.bookId{
            _ = provider.request(.bookInfo(bookId))
                .mapObject(BookInfo.self)
                .subscribe({ (event) in
                    switch event{
                    case .next(let results):
                        log.debug(results)
                        self.model = results
                        self.setHeader(data: results)
                        self.tableView.reloadData()
                    case .error(let error):
                        log.error(error)
                    case .completed:
                        break
                    }
                })
        }
        
    }
    
    func backToPrevious(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

    /*
     // MARK: - Navigation
     */
    
}

extension BorrowDetailViewController: UITableViewDelegate{
    
}

extension BorrowDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if let count = model?.entities?.count{
                return count
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BorrowDetailTableViewCell(style: .default, reuseIdentifier: "BorrowDetailTableViewCell")
        if indexPath.section == 0{
            cell.detialLabel.numberOfLines = 2
            if let data = model?.entities{
                
                cell.campusLabel.text = data[indexPath.row].campus
                cell.detialLabel.text = data[indexPath.row].location
                cell.statusLabel.text = data[indexPath.row].isLent! ? "不可借" : "可借"
            }
        }else {
            cell.statusLabel.textColor = UIColor(hex: "50b5ed")
            cell.statusLabel.font = UIFont(name: "PingFangSC-Medium", size: 18)
            if let lentCount = model?.lentCount{
                cell.campusLabel.text = "\(lentCount)人等待"
                cell.detialLabel.text = ""
                cell.statusLabel.text = "可预约"
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 35
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 36))
        
        headerView.backgroundColor = UIColor.white
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}


