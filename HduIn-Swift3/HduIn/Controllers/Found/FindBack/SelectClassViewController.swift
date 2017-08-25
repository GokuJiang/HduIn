//
//  SelectClassViewController.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/22.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

typealias SendValueClosure = (_ labelValue:String) -> Void

class SelectClassViewController: BaseViewController {
    var mainTableView = UITableView()
    var closure: SendValueClosure?
    var items = ["一卡通","书籍资料","衣物饰品","交通工具","随身物品","电子数码","卡类物件","其他物品"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackActionButton()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        self.view.addSubview(mainTableView)
        self.mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(30)
            make.leading.equalTo(0)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-190)
            mainTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
            mainTableView.delegate = self
            mainTableView.dataSource = self
            mainTableView.estimatedRowHeight = 80
            mainTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SelectClassViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
        closure!(cell.titleLable.text!)
        self.dismiss(animated: true, completion: nil)
    }
}

extension SelectClassViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PostTableViewCell(style: .default, reuseIdentifier: "PostTableViewCell")
        cell.titleLable.text = items[indexPath.row]
        cell.icon.text = ""
        cell.textView.isHidden = true
        return cell
    }
}



