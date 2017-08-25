//
//  FocusPhotogragherViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

class FocusPhotogragherViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView = UITableView()
    var provider = APIProvider<FocusTarget>()
    var model = [FocusPhotographerModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        getData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        self.tableView.register(PhotographerTableViewCell.self, forCellReuseIdentifier: "PhotographerCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.snp.makeConstraints { (make) in
            make.top.trailing.bottom.leading.equalTo(0)
        }
        self.title = "摄影师"
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imageUrl:[String] = []
        if let photos = self.model[indexPath.row].photos{
            for i in 0..<photos.count{
                if let url = photos[i].url{
                    imageUrl.append(url)
                }
            }
        }
        let cell = PhotographerTableViewCell(images: imageUrl)
        cell.avaterImage.yy_imageURL = URL(string: model[indexPath.row].avatar!)
        cell.nameLable.text = model[indexPath.row].name
        log.debug(self.model[indexPath.row].photos?.count)
        return cell

//<<<<<<< HEAD
//        if let url = imageUrl{
//            let cell = PhotographerTableViewCell(images: url)
//            cell.avaterImage.yy_imageURL = URL(string: model[indexPath.row].avatar!)
//            cell.nameLable.text = model[indexPath.row].name
//            
//            log.debug(self.model[indexPath.row].photos?.count)
//            return cell
//        }
//        return UITableViewCell()
//=======
//        let cell = PhotographerTableViewCell(images: imageUrl)
//        cell.avaterImage.yy_imageURL = URL(string: model[indexPath.row].avatar!)
//        cell.nameLable.text = model[indexPath.row].name
//        
//        log.debug(self.model[indexPath.row].photos?.count)
//        return cell
//>>>>>>> feature/news
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PhotographerViewController()
        tableView.deselectRow(at: indexPath, animated: true)
        vc.id = model[indexPath.row].id!
        self.present(vc, animated: true, completion: nil)
    }
    
    func getData(){
        _ = provider.request(.photographer).mapArray(FocusPhotographerModel.self).subscribe{(event) in
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
