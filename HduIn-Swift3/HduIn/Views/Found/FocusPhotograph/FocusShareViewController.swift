//
//  FocusShareViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class FocusShareViewController: UIViewController {
    var provider = APIProvider<FocusTarget>()
    var tableView = UITableView()
    var backgroundColor = [HIColor.hduSoftBlue,UIColor.black]
    var model = [ArticleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getData()
        
        self.view.addSubview(self.tableView)
        self.tableView.register(FocusShareTableViewCell.self, forCellReuseIdentifier: "FocusShareTableViewCell")
        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        self.view.backgroundColor = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
        self.tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(7)
            make.top.equalTo(0)
            make.trailing.equalTo(-7)
            make.bottom.equalTo(0)
            tableView.separatorStyle = .none
        }
        self.title = "干货分享"
    }
    
    func getData(){
        _ = provider.request(.article).mapArray(ArticleModel.self).subscribe{(event) in
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
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
}

extension FocusShareViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FocusShareViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FocusShareTableViewCell(style: .default, reuseIdentifier: "FocusShareTableViewCell")
        cell.introductionLable.text = model[indexPath.section].title
        cell.summmaryLable.text = model[indexPath.section].summary
//        cell.titleLable.text = "相机知识"
        cell.backgroudView.yy_imageURL = URL(string: model[indexPath.section].cover)
        
        return cell
    }
}
