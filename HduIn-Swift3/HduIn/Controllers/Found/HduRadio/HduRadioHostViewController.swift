//
//  HostViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/1.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit
import SnapKit


class HduRadioHostViewController: BaseViewController {
    
    var hostView = HduRadioMainView()
    var backButton = UIButton()
    var hostmodel:[HostModel] = []
    var programmodel:[ProgramModel] = []
    var provider = APIProvider<HduRadioTarget>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(hostView)
        self.view.addSubview(backButton)
        
        hostView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(0)
        }
        hostView.hostCollectionView.delegate = self
        hostView.hostCollectionView.dataSource = self
        hostView.programCollectionView.delegate = self
        hostView.programCollectionView.dataSource = self
        getProgramData()
        getHostData()
        
        self.backButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.leading.equalTo(16)
            make.top.equalTo(28)
            self.backButton.setImage(UIImage(named: "Radio-back"), for: UIControlState.normal)
            backButton.addTarget(self, action: #selector(HduRadioHostViewController.back), for: UIControlEvents.touchUpInside)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addGradientLayer([
            UIColor(red: 93/255, green: 195/255, blue: 252/255, alpha: 1),
            UIColor(red: 113/255, green: 180/255, blue: 241/255, alpha: 1),
            UIColor(red: 149/255, green: 172/255, blue: 230/255, alpha: 1)]) 
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getHostData(){
        _ = provider.request(.hostList).mapArray(HostModel.self).subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                self.hostmodel = results
                self.hostView.hostCollectionView.reloadData()
            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
        }
    }
    
    func getProgramData(){
        _ = provider.request(.programList).mapArray(ProgramModel.self).subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                self.programmodel = results
                self.hostView.programCollectionView.reloadData()
            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
        }
    }


    
}
extension HduRadioHostViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView == hostView.programCollectionView){
            if (indexPath.row == 6){
                return CGSize(width: SCREEN_WIDTH - 16 - 24, height: 109)
            }
            let width:CGFloat = SCREEN_WIDTH - 12 * 4 - 8 * 2 - 10
            return CGSize(width: width/3, height: width/3 + 24)

        }
        else{
            
            let width:CGFloat = SCREEN_WIDTH - 20 * 4 - 8 * 2 - 10 - 30
            return CGSize(width: width/3 , height: width/3 + 24)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if(collectionView == hostView.hostCollectionView){
            return UIEdgeInsets(top:5, left: 20, bottom:0, right: 20)
        }else{
            return  UIEdgeInsets(top:5, left: 0, bottom:0, right: 0)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        if(collectionView == hostView.hostCollectionView){
            return 0
        }else{
            return 12
        }
    }

    
}

extension HduRadioHostViewController:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if (collectionView == hostView.programCollectionView){
            let vc = HduRadioProgramViewController()
            self.present(vc, animated: true, completion:nil)

        }
        else{
            let vc = BookHostViewController()
            self.present(vc, animated: true, completion: nil)
        }
    }
 
}

extension HduRadioHostViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hostView.hostCollectionView{
            return hostmodel.count
        }else{
        return programmodel.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func  collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HduRaidoHostCellIdentify, for: indexPath) as? HostCell else{
            return UICollectionViewCell()
        }
        if  collectionView == hostView.programCollectionView{
            if(indexPath.row == 6 ){
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HduLargetCellIdentify, for: indexPath) as? HduRadioLargeCell{
                    cell.titleLabel.text = programmodel[indexPath.row].name
                    //cell.imageView.image = UIImage(named: "nuomi")
                    if let url = programmodel[indexPath.row].coverUrl{
                         cell.imageView.yy_imageURL = URL(string: url)
                    }
                    cell.timesLabel.text = programmodel[indexPath.row].times
                    cell.titleLabel.textAlignment = .left
                    return cell
                }
            }else{
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HduProgramCellIdentify, for: indexPath) as? ProgramCell{
                    cell.titleLabel.text = programmodel[indexPath.row].name
                    if let url = programmodel[indexPath.row].coverUrl{
                        cell.imageView.yy_imageURL = URL(string: url)
                    }
                    cell.timesLabel.text = programmodel[indexPath.row].times
                    cell.titleLabel.textAlignment = .left
                    return cell
                }
            }
            
        }else{
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HduRaidoHostCellIdentify, for: indexPath) as? HostCell{
                cell.titleLabel.text = hostmodel[indexPath.row].name
                cell.iconImageView.image = UIImage(named: "")
                //cell.imageView.image = UIImage(named: "nuomi")?.roundCornersToCircle()
                cell.imageView.imageFromURL(hostmodel[indexPath.row].avatarUrl!, placeholder: (UIImage(named: "nuomi")?.roundCornersToCircle())!)
                return cell
            }
           
        }
        return cell
        
    }
    
}
