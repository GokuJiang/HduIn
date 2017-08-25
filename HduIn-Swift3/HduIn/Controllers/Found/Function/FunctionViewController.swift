//
//  FunctionViewController.swift
//  HduIn
//
//  Created by 杨骏垒 on 2017/3/8.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class FunctionViewController: BaseViewController {

    var tableView = UITableView()
    var isHidden: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(0)
        }
        self.tableView.separatorStyle = .none
        self.tableView.register(FunctionTableViewCell.self, forCellReuseIdentifier: "FunctionTableViewCell")
        self.title = "功能"
//        setNavigation()
    
        checkStatus()
    }
    
//    func setNavigation(){
//        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "ffffff")
//    }

    func checkStatus(){
        let status = LeanCloudAgent.getOnlineParam(.CourseSelectionEnabled) as LeanCloudAgent.ParamStatus
        switch status {
        case .Enabled:
            self.isHidden = false
        case .Disabled:
            self.isHidden = true
        case .Hidden:
            self.isHidden = true
        }
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

extension FunctionViewController: UITableViewDelegate{
    
}

extension FunctionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isHidden{
            return 2
        }
        return 3
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FunctionTableViewCell(style: .default, reuseIdentifier: "FunctionTableViewCell")
        
//        bgLayer.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
            //colors(i: indexPath.row)
        //bgLayer.frame = cell.bgView.frame
        
        let i: Int
        if self.isHidden {
            i = indexPath.row + 1
        }else{
            i = indexPath.row
        }
        let bgLayer = colors(i: i)
        cell.bgView.layer.insertSublayer(bgLayer, at: 0)
        cell.bgView.layer.cornerRadius = 7.0
        cell.bgView.layer.masksToBounds = true
        let labelString = [["选课系统", "争分夺秒，快人一步"],
                           ["图书馆", "读万卷书，行万里路"],
                           ["爪回网", "众里寻它千百度"]]
        let imageName = ["magic-function", "library-function", "foot-function"]
        let size = [[30, 29],
                    [25, 27],
                    [21, 25]]
        cell.myImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(cell.bgView.snp.leading).offset(20)
            make.top.equalTo(cell.bgView.snp.top).offset(21)
            make.width.equalTo(size[i][0])
            make.height.equalTo(size[i][1])
        }
        cell.myImageView.image = UIImage(named: imageName[i])
        cell.funLabel.text = labelString[i][0]
        cell.explainLabel.text = labelString[i][1]

        return cell
    }
    
    func colors(i: Int) -> CAGradientLayer{
        let leftColor: UIColor
        let rightColor: UIColor
        if i == 0{
            leftColor = UIColor(red: 254.0 / 255.0, green: 122.0 / 255.0, blue: 138.0 / 255.0, alpha: 1.0)
            rightColor =  UIColor(red: 254.0 / 255.0, green: 162.0 / 255.0, blue: 110.0 / 255.0, alpha: 1.0)
        }
        else if i == 1{
            leftColor = UIColor(red: 94.0 / 255.0, green: 164.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
            rightColor = UIColor(red: 224.0 / 255.0, green: 195.0 / 255.0, blue: 252.0 / 255.0, alpha: 1.0)
        }
        else{
            leftColor = UIColor(red: 73.0 / 255.0, green: 201.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
            rightColor = UIColor(red: 172.0 / 255.0, green: 203.0 / 255.0, blue: 238.0 / 255.0, alpha: 1.0)
        }
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [0, 1]
        gradientLayer.colors = [leftColor.cgColor ,rightColor.cgColor]
        gradientLayer.borderWidth = 0
        return gradientLayer
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
       
        switch indexPath.row {
        case 0:
            if self.isHidden {
                self.present(LibraryViewController(), animated: true, completion: nil)
            }else{
                self.present(SelectionCoursesViewController(), animated: true, completion: nil)
            }
        case 1:
            
            if self.isHidden {
                
                self.present(FindBackViewController(), animated: true, completion: nil)
            }else{
                
                self.present(LibraryViewController(), animated: true, completion: nil)
            }
            
        case 2:
            self.present(FindBackViewController(), animated: true, completion: nil)
        default:
            break
        }
    }
}

extension FunctionViewController: TabViewController {
    func setupTabInfo() {
        let title = "功能".localized()
        self.title = title
        
        let tabBarNoamalImage = UIImage(named: "gongneng--grey")?.withRenderingMode(.alwaysOriginal)
        let tabBarSelectedImage:UIImage = #imageLiteral(resourceName: "gongneng--blue").withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let tabBarItem = UITabBarItem(title: title, image: tabBarNoamalImage,selectedImage: tabBarSelectedImage)
        self.tabBarItem = tabBarItem
    }
}



