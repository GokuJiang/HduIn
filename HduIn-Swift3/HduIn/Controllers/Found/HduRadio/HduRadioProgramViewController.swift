//
//  HduRadioProgramViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/9.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class HduRadioProgramViewController: UIViewController {

    var programTableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), style: .plain)
    var backButton = UIButton()
    
    var informations = [programInformationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programTableView.delegate = self
        programTableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        self.informations.append(programInformationModel(title: "关于人与美丽",time: "33:45",issue: "241", date: "2016-11-22", pageView: "63"))
        self.informations.append(programInformationModel(title: "一个人的征程",time: "33:45",issue: "240", date: "2016-11-22", pageView: "63"))
        log.debug()
        self.view.addSubview(self.programTableView)
        self.view.addSubview(self.backButton)
        self.programTableView.separatorStyle = .none
        
        self.backButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.leading.equalTo(16)
            make.top.equalTo(28)
            self.backButton.setImage(UIImage(named: "Radio-back"), for: UIControlState.normal)
            backButton.addTarget(self, action: #selector(HduRadioProgramViewController.back), for: UIControlEvents.touchUpInside)
        }

        
        self.programTableView.register(HduRadioProgramDetailCell.self, forCellReuseIdentifier: "HduRadioProgramDetailCell")
        self.programTableView.tableHeaderView = HduRadioProgramHeadView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 198))
        
        
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension HduRadioProgramViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let bgView = HduRadioProgramSectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        bgView.title.text = "往期节目"
        bgView.totalIssue.text = "共241期"
        
        return bgView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HduRadioProgramViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.informations.count
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HduRadioProgramDetailCell(style: .default, reuseIdentifier: "HduRadioProgramDetailCell")
        cell.titleLable.text = self.informations[indexPath.row].title
        cell.timeLable.text = self.informations[indexPath.row].time
        cell.issueLable.text = self.informations[indexPath.row].issue
        cell.dateLable.text = self.informations[indexPath.row].date
        cell.pageViewLable.text = self.informations[indexPath.row].pageView
        
        return cell
    }

}
