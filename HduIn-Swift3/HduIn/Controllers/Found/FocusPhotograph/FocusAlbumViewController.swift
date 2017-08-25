//
//  FocusAlbumViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

fileprivate let AlbumTableViewCellIdentifier = "AlbumCollectionViewCell"

class FocusAlbumViewController: UIViewController{
    var model = [FocusAlbumModel]()
    var tableView = UITableView()
    var provider = APIProvider<FocusTarget>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
        getData()
        
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AlbumCollectionViewCell.self, forCellReuseIdentifier: AlbumTableViewCellIdentifier)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = 220
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.white
        
        self.title = "照片专辑"
    }
    
    func getData(){
        _ = provider.request(.album).mapArray(FocusAlbumModel.self).subscribe{(event) in
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
    }
}

extension FocusAlbumViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FocusAlbumDetailViewController()
        vc.id = model[indexPath.row].id!
        self.present(vc, animated: true, completion: nil)
    }
}

extension FocusAlbumViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCellIdentifier, for: indexPath) as? AlbumCollectionViewCell else{
            return UITableViewCell()
        }
        
        cell.photoImageView.yy_imageURL = URL(string: model[indexPath.row].cover!)
        if let photos = model[indexPath.row].photos{
            cell.numberOfPictureLable.text = "   " + String(describing: photos.count) + "图"
        }
        cell.titleLable.text = model[indexPath.row].title
        
        return cell
    }
}
