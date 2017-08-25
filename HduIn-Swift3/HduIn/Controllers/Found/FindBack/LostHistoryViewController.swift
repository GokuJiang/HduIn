//
//  LostHistoryViewController.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/26.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit

class LostHistoryViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    var segment: UISegmentedControl!

    var providor = APIProvider<FindBackTarget>()
    var modelFind: [FindBack.FindoutFind] = []
    var modelLost: [FindBack.FindoutLost] = []

    var indexPaths: [IndexPath] = []
    var itemNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setCollectionView()
        setSegmentCtrl()
        getData(0)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSegmentCtrl(){
        let view = UIView()
        let title = ["捡到","丢失"]
        self.segment = UISegmentedControl(items: title)
        self.segment.frame = CGRect(x: self.view.frame.midX - 159 / 2, y: 10, width: 159, height: 28)
        self.segment.tintColor = UIColor(hex: "28bcd2")
        self.segment.selectedSegmentIndex = 0
        self.collectionView.addSubview(view)
        view.backgroundColor = UIColor(hex: "ffffff")
        view.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(48)
            make.top.equalTo(0)
        }
        view.addSubview(segment)
        self.segment.addTarget(self, action: #selector(self.matchMode), for: .valueChanged)
    }
    
    func setNavigation(){
        let leftBar = UIBarButtonItem(image: UIImage(named: "Back-LostFound"), style: .plain, target: self, action: #selector(self.navigateBack))
        leftBar.tintColor = UIColor(hex: "6d6d6d")
        self.navigationItem.leftBarButtonItem = leftBar
        self.title = "历史发布"
    }
    
    func setCollectionView(){
        self.view.backgroundColor = UIColor(hex: "ffffff")
        
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalTo(0)
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(LostInfoCollectionViewCell.self, forCellWithReuseIdentifier: "LostInfoCollectionViewCell")
        
        self.collectionView.backgroundColor = UIColor(hex: "f7f7f7")
    }
    
    func matchMode(){
        switch self.segment.selectedSegmentIndex {
        case 0:
            self.getData(0)
        case 1:
            self.getData(1)
        default:
            break
        }
    }
    
    func getData(_ i: Int){
        if i == 0{
            if self.modelFind.isEmpty{
                _ = providor.request(.fdfindhistory)
                    .mapArray(FindBack.FindoutFind.self)
                    .subscribe({(event) in
                    switch event{
                    case .next(let results):
                        log.debug(results)
                        for i in 0..<results.count{
                            if results[i].status == 1{
                                self.modelFind.append(results[i])
                            }
                        }
                        self.itemNumber = self.modelFind.count
                        self.collectionView.reloadData()
                    case .error(let error):
                        log.error(error)
                    case .completed:
                        break
                    }
                })
                
            }else{
                 self.collectionView.reloadData()
            }
            
        }
            
        else if i == 1{
            
            if self.modelLost.isEmpty{
                
                _ = providor.request(.fdlosthistory)
                    .mapArray(FindBack.FindoutLost.self)
                    .subscribe({(event) in
                    switch event{
                    case .next(let results):
                        log.debug(results)
                        for i in 0..<results.count{
                            if results[i].status == 1{
                                self.modelLost.append(results[i])
                            }
                        }
                        self.itemNumber = self.modelLost.count
                        self.collectionView.reloadData()
                    case .error(let error):
                        log.error(error)
                    case .completed:
                        break
                    }
                
                })
            }else{
                 self.collectionView.reloadData()
            }
            
        }
       
        
    }
}

extension LostHistoryViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width - 37) / 2, height: 212)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 48)
    }
    
    
    
}

extension LostHistoryViewController: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.itemNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "LostInfoCollectionViewCell", for: indexPath) as? LostInfoCollectionViewCell
            else{
                return UICollectionViewCell()
        }
        
        cell.setBezierPath()
        
        
        let picName = ["foodCard-LostFound",
                       "book-LostFound",
                       "jacket-LostFound",
                       "bicycle-LostFound",
                       "backpack-LostFound",
                       "digitalProduction-LostFound",
                       "creditCard-LostFound",
                       "coffee-LostFound"]
        let colors: [UIColor] =
            [UIColor(hex: "28bcd2"),UIColor(hex: "a6e3e9"),
             UIColor(hex: "ffe4b3"),UIColor(hex: "45a0e1"),
             UIColor(hex: "bda4eb"),UIColor(hex: "e98c8c"),
             UIColor(hex: "3f72af"),UIColor(hex: "76bda3")]
        if self.segment.selectedSegmentIndex == 0 {
            
            if let index = self.modelFind[indexPath.row].type {
                cell.attrImageView.image = UIImage(named: picName[index])
                cell.bgLayer.fillColor = colors[index].cgColor
                
            }else{
                cell.bgLayer.fillColor = colors[0].cgColor
            }
            cell.lostContentLabel.text = self.modelFind[indexPath.row].name
            
            let url = URL(string: self.modelFind[indexPath.row].photoURL)
            if let url = url{
                do{
                    let data = try Data(contentsOf: url)
                    cell.imageView.image = UIImage(data: data)
                }
                catch{
                    cell.imageView.image = #imageLiteral(resourceName: "Lack-Photo")
                }
            }else{
                cell.imageView.image = #imageLiteral(resourceName: "Lack-Photo")
            }

            cell.infoButton.setTitle("物归原主啦", for: .normal)
            cell.infoButton.tag = indexPath.row
            self.indexPaths.append(indexPath)
            cell.infoButton.addTarget(self, action: #selector(self.haveFinished(_:)), for: .touchUpInside)
            
            
        }else{
            
            if let index = self.modelLost[indexPath.row].type{
                cell.attrImageView.image = UIImage(named: picName[index - 1])
                cell.bgLayer.fillColor = colors[index - 1].cgColor
            }else{
                cell.bgLayer.fillColor = colors[0].cgColor
            }
            
            cell.lostContentLabel.text = self.modelLost[indexPath.row].name
            
            let url = URL(string: self.modelLost[indexPath.row].photoURL)
            if let url = url{
                do{
                    let data = try Data(contentsOf: url)
                    cell.imageView.image = UIImage(data: data)
                }
                catch{
                    cell.imageView.image = #imageLiteral(resourceName: "Lack-Photo")
                }
            }else{
                cell.imageView.image = #imageLiteral(resourceName: "Lack-Photo")
            }
            
            cell.infoButton.setTitle("物归原主啦", for: .normal)
            cell.infoButton.tag = indexPath.row
            self.indexPaths.append(indexPath)
            cell.infoButton.addTarget(self, action: #selector(self.haveFinished(_:)), for: .touchUpInside)
            
            
        }
        
        cell.setView(mode: .changeState)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func haveFinished(_ button: UIButton) {
        switch self.segment.selectedSegmentIndex {
        case 0:
            if let id = self.modelFind[button.tag].itemId {
                _ = providor
                    .request(.markFind("\(id)", UserModel.staffId))
                    .subscribe({ (event) in
                    switch event{
                    case .next(_):
                        break
                    case .error(_):
                        print.debug("ERROR!!!")
                        break
                    case .completed:
                        print.debug("COMPLETED!!!")

                        self.itemNumber = (self.itemNumber == 0) ? 0 : self.itemNumber - 1
                        self.collectionView.deleteItems(at: [self.indexPaths[button.tag]])
                        
                        for i in button.tag..<self.indexPaths.count - 1 {
                            self.indexPaths[i + 1] = self.indexPaths[i]
                        }
                        
                        break
                    }
                })
            }
        case 1:
            if let id = self.modelLost[button.tag].itemId{
                _ = providor
                    .request(.markLost("\(id)", UserModel.staffId))
                    .subscribe({ (event) in
                    switch event{
                    case .next(_):
                        break
                    case .error(_):
                        break
                    case .completed:

                        self.itemNumber = (self.itemNumber == 0) ? 0 : self.itemNumber - 1
                        self.collectionView.deleteItems(at: [self.indexPaths[button.tag]])

                        for i in button.tag..<self.indexPaths.count - 1 {
                            self.indexPaths[i + 1] = self.indexPaths[i]
                        }
                        break
                    }
                })
            }
            
        default:
            break
        }
    }
}

extension LostHistoryViewController: UICollectionViewDelegate{
    
}

