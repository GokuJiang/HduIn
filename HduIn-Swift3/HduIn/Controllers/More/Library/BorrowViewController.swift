
//
//  BorrowViewController.swift
//  HduIn
//
//  Created by Kevin on 2017/1/15.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit
import MBProgressHUD

class BorrowViewController: BaseViewController {

    var tableView = UITableView()
    var selecetdNumber:Int = -1
    var reSelected:IndexPath = IndexPath(row: 0, section: 0)
    var provider = APIProvider<LibraryTarget>()
    var model:[Library.LibraryLents] = []
    var nullBookText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        wireRainbow()
        getData()
        self.view.backgroundColor = UIColor.white
        self.title = "图书馆"
        showBackActionButton()
        
        self.view.addSubview(tableView)
        self.view.addSubview(nullBookText)
        self.nullBookText.isHidden = true
        tableView.snp.makeConstraints { (make) in
            make.top.leading.bottom.trailing.equalTo(0)
        }
        tableView.register(BorrowTableViewCell.self, forCellReuseIdentifier: "BorrowCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData(){
        _ = provider.request(.lentsIndex).mapArray(Library.LibraryLents.self).subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                self.model = results
                self.tableView.reloadData()
                if results.count != 0 {
                    self.nullBookText.isHidden = true
                }
            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
            
        }

    }
    
    func renewAction(_ sender: UIButton){
        let id:String = model[sender.tag - 1000].entityId
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.minShowTime = 1
        _ = provider.request(.renew(id)).mapObject(Library.BookRenew.self).subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                hud?.labelText = results.result
                hud?.mode = .customView
                hud?.hide(true)
            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
        }
    }
    
    override func wireRainbow() {
        super.wireRainbow()
        navigationController?.navigationBar.df_setBackgroundColor(HIColor.HduInBlue)
    }
    
    override func navigationBarInColor() -> UIColor {
        return HIColor.HduInBlue
    }

}



extension BorrowViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! BorrowTableViewCell
        if cell.showDetail{
            cell.showDetail = false
        }else{
            cell.showDetail = true
        }
        
        
        tableView.beginUpdates()
        
        let beforecell = tableView.cellForRow(at: reSelected) as?BorrowTableViewCell
        
        
        beforecell?.didSelected()
        if (beforecell?.showDetail)!{
            beforecell?.showDetail = false
        }else{
            beforecell?.showDetail = true
        }
        
        cell.didSelected()
        if selecetdNumber == indexPath.row{
            selecetdNumber = -1
        }else{
            selecetdNumber = indexPath.row
        }
        
        tableView.endUpdates()
        reSelected = indexPath

        
    }
}

extension BorrowViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.model.count == 0){
            self.nullBookText.text = "您没有借阅任何图书"
            self.nullBookText.textColor = UIColor.darkGray
            self.nullBookText.textAlignment = .center
            self.nullBookText.font = UIFont.boldSystemFont(ofSize: 22)
            self.nullBookText.snp.makeConstraints({ (make) in
                make.center.equalTo(self.view)
                make.height.greaterThanOrEqualTo(70)
                make.width.equalTo(300)
            })
            self.nullBookText.isHidden = false
        }
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BorrowTableViewCell(style: .default, reuseIdentifier: "BorrowCell")
       
        cell.authorLable.text = model[indexPath.row].author
        cell.titleLable.text = model[indexPath.row].title
        cell.deadlineLable.text = model[indexPath.row].deadline+"到期"
        cell.residueNumberLable.text = String(model[indexPath.row].surplusDays) + "天"
        cell.publicHouseLable.text = model[indexPath.row].publisher
        cell.numberLabe.text = model[indexPath.row].entityId
        cell.renewNumberLable.text = "续借次数: " + String(model[indexPath.row].renewedTimes) + "次"
        
        if((model[indexPath.row].surplusDays != -1) && model[indexPath.row].surplusDays <= 3){
            cell.bgView.backgroundColor = UIColor(hex: "f74a56")
        }
        cell.renewButton.addTarget(self, action: #selector(self.renewAction(_:)), for: .touchUpInside)
        cell.renewButton.tag = 1000 + indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selecetdNumber{
            return 190
        }
        return 112.5
    }

}

extension BorrowViewController:TabViewController {
    func setupTabInfo() {
        self.title = title
        
        let mineTabBarItem = UITabBarItem(
            title: "借阅",
            image: UIImage(named: "library_bookgray")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "library_bookblue")?
                .withRenderingMode(.alwaysOriginal)
        )
        self.tabBarItem = mineTabBarItem
    }
}
