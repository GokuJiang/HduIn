//
//  FoundViewController.swift
//  HduIn
//
//  Created by 姜永铭 on 11/7/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import UIKit

class FoundViewController: BaseViewController {
    let bannerHeight = (195.0+22) * (SCREEN_WIDTH / 374.0)

    var foundView:  FoundView?
    var model:[FoundModel] = []
    var newsList:[FoundModel] = []
    var provider = APIProvider<FoundNewsTarget>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex:"f7f7f7")
        getNewsList()
        self.getData { (urlArray) in
            self.foundView = FoundView(urlImage: urlArray)
            guard let foundView = self.foundView else {
                return
            }
            self.view.addSubview(foundView)
            foundView.snp.makeConstraints { (make) in
                make.leading.trailing.bottom.top.equalTo(0)
            }
            foundView.headView?.detailArray = self.model
            foundView.tableView.delegate = self
            foundView.tableView.dataSource = self
            foundView.clubView.audioButton.addTarget(self, action: #selector(self.audioAction), for: .touchUpInside)
            foundView.clubView.focusButton.addTarget(self, action: #selector(self.focusAction), for: .touchUpInside)

        }

       
    }
    
    func audioAction(){
        let vc = HduRadioHostViewController()
        self.present(vc, animated: false, completion: nil)
    }

    func focusAction() {
        let vc = FocusViewController()
        self.present(vc, animated: false, completion: nil)
    }
    
    func getData(successClourse:@escaping ([String])->()){
        _ = provider.request(.banner).mapArray(FoundModel.self).subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                self.model = results
                var urlArray:[String] = []
                for i in 0..<self.model.count{
                    urlArray.append(self.model[i].coverUrl!)
                }
                successClourse(urlArray)

            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
            
        }
        
    }

    func getNewsList(){
        _ = provider.request(.list).mapArray(FoundModel.self).subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                self.newsList = results
                self.foundView?.tableView.reloadData()
            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
            
        }

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func wireRainbow() {
        super.wireRainbow()
        navigationController?.navigationBar.df_setBackgroundColor(UIColor.clear)
    }
    
    override func navigationBarInColor() -> UIColor {
        return UIColor.clear
    }


}

extension FoundViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

}

extension FoundViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FoundTableViewCell()
        if let time = newsList[indexPath.row].updatedAt{
            let index = time.index(time.startIndex, offsetBy: 10)
            cell.timeLabel.text = time.substring(to: index)
        }
        cell.titleLabel.text = newsList[indexPath.row].title
        cell.detailLabel.text = newsList[indexPath.row].summary
        cell.contentImageView.yy_imageURL = URL(string: newsList[indexPath.row].coverUrl!)
        return cell
    }
}

extension FoundViewController: TabViewController {
    func setupTabInfo() {
        let title = "发现".localized()
        self.title = title
        
        let mineTabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: "findgray")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "faxianblue")?
                .withRenderingMode(.alwaysOriginal)
        )
        self.tabBarItem = mineTabBarItem
    }
}
