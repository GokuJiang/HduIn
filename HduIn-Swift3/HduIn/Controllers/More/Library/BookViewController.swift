//
//  BookViewController.swift
//  HduIn
//
//  Created by Kevin on 2017/1/15.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class BookViewController: BaseViewController {
    
    var tableView = UITableView()
    var provider = APIProvider<LibraryTarget>()
    var model: [ReservationInfo] = []
    var nullBookText = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        wireRainbow()
        showBackActionButton()
        self.title = "预约"
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.nullBookText)
        self.nullBookText.isHidden = true
        
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(0)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(ReservationTableViewCell.self, forCellReuseIdentifier: "ReservationTableViewCell")
        self.tableView.separatorStyle = .none
        getData()
    }

    func getData(){
        _ = self.provider.request(.reservation)
            .mapArray(ReservationInfo.self)
            .subscribe({ (event) in
                switch event{
                case .next(let results):
                    log.debug(results)
                    self.model = results
                    self.tableView.reloadData()
                case .error(let error):
                    
                    log.error(error)
                case .completed:
                    break
                }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func wireRainbow() {
        super.wireRainbow()
        navigationController?.navigationBar.df_setBackgroundColor(HIColor.HduInBlue)
    }
    override func navigationBarInColor() -> UIColor {
        return HIColor.HduInBlue
    }
}

extension BookViewController: UITableViewDelegate{
    
}

extension BookViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.model.count == 0){
            self.nullBookText.text = "您没有预约任何图书"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ReservationTableViewCell(style: .default, reuseIdentifier: "ReservationTableViewCell")
        if let author = model[indexPath.row].author{
            cell.authorNameLabel.text = author
        }
        if let bookName = model[indexPath.row].title{
            cell.bookNameLabel.text = bookName
        }
        if let status = model[indexPath.row].status{
            cell.status.text = status
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}


extension BookViewController:TabViewController {
    func setupTabInfo() {
        self.title = title
        
        let mineTabBarItem = UITabBarItem(
            title: "预约",
            image: UIImage(named: "library_borrowgray")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "library_borrowblue")?
                .withRenderingMode(.alwaysOriginal)
        )
        self.tabBarItem = mineTabBarItem
    }
}

