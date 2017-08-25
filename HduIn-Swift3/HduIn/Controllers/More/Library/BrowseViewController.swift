//
//  BrowseViewController.swift
//  HduIn
//
//  Created by Kevin on 2017/1/15.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class BrowseViewController: BaseViewController {

    var tableView = UITableView()
    var provider = APIProvider<LibraryTarget>()
    var model: [Library.BookViewInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我看过的"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        showBackActionButton()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(0)
        }
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(BookViewTableViewCell.self, forCellReuseIdentifier: "BookViewTableViewCell")
        getData()
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData(){
        _ = self.provider.request(.viewHistory)
            .mapArray(Library.BookViewInfo.self)
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
    
}

extension BrowseViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = BorrowDetailViewController()
        vc.bookId = self.model[indexPath.row].bookId
        let rootVC = BaseNavigationController(rootViewController: vc)
        self.present(rootVC, animated: true, completion: nil)
    }
}

extension BrowseViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BookViewTableViewCell(style: .default, reuseIdentifier: "BookViewTableViewCell")
        
        
        cell.authorNameLabel.text = self.model[indexPath.row].author
        cell.bookNameLabel.text = self.model[indexPath.row].title
        cell.lentDateLabel.text = self.model[indexPath.row].lentDate
        cell.deadLineLabel.text =  self.model[indexPath.row].deadline
        
        
        return cell
    }

}



extension BrowseViewController:TabViewController {
    func setupTabInfo() {
        self.title = title
        
        let mineTabBarItem = UITabBarItem(
            title: "我看过的",
            image: UIImage(named: "library_historygray")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "library_historyblue")?
                .withRenderingMode(.alwaysOriginal)
        )
        self.tabBarItem = mineTabBarItem
    }
}
