//
//  HduRadioMainView.swift
//  HduIn
//
//  Created by 姜永铭 on 06/12/2016.
//  Copyright © 2016 姜永铭. All rights reserved.
//

import UIKit
let HduRaidoHostCellIdentify = "HduRaidoHostCell"
let HduLargetCellIdentify = "HduLargetCellIdentify"
let HduProgramCellIdentify = "HduProgramCellIdentify"
class HduRadioMainView: UIView {
    var titleLable = UILabel()
    var mainview = UIView()
    var circleView = UIView()
    var programButton = UIButton()
    var hostButton = UIButton()
    var logoImageView = UIImageView()
    var programCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var hostCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(){
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupView(){
        self.addSubview(mainview)
        self.addSubview(titleLable)
        self.addSubview(logoImageView)
        self.mainview.addSubview(programButton)
        self.mainview.addSubview(hostButton)
        self.insertSubview(circleView, aboveSubview: mainview)
        
        self.setTitle()
        self.setMainView()
        
    }
    
    func setTitle() {
        titleLable.textColor = UIColor.white
        titleLable.backgroundColor = UIColor(colorLiteralRed: 93/255, green: 195/255, blue: 252/255, alpha: 1)
        titleLable.text = "杭电之声"
        titleLable.font = UIFont.systemFont(ofSize: 18)
        titleLable.textAlignment = .center
        titleLable.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(28)
            make.height.equalTo(18)
        }
    }
    
    func setMainView(){
        logoImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(mainview)
            make.centerY.equalTo(mainview.snp.top)
            make.size.equalTo(CGSize(width: 62, height: 62))
            logoImageView.image = UIImage(named: "HduRadio")
            //logoImageView.contentMode = .scaleAspectFill
        }
        
        mainview.snp.makeConstraints{(make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-12)
            
            mainview.backgroundColor = UIColor.white
            make.top.equalTo(titleLable.snp.bottom).offset(66)
            mainview.layer.cornerRadius = 5
            mainview.layer.masksToBounds = true
        }
       
        programButton.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.top.equalTo(8)
            make.trailing.equalTo(mainview.snp.centerX).offset(-40)
            make.height.greaterThanOrEqualTo(19)

            programButton.setTitle("节目专辑", for: .normal)
            programButton.setTitleColor(UIColor.lightGray, for: .normal)
            programButton.setTitleColor(UIColor(colorLiteralRed: 83/255, green: 162/255, blue: 208/255, alpha: 1), for: .selected)
            programButton.isSelected = true
            programButton.isEnabled = false
            programButton.setTitleColor(UIColor(red: 70/255, green: 160/255, blue: 194/255, alpha: 1), for: .normal)

            programButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            programButton.addTarget(self, action: #selector(self.changePage(sender:)), for: .touchUpInside)
            programButton.tag = 1000

        }
        
        hostButton.setTitle("主持人预约", for: .normal)
        hostButton.setTitleColor(UIColor.lightGray, for: .normal)
        hostButton.setTitleColor(UIColor(colorLiteralRed: 83/255, green: 162/255, blue: 208/255, alpha: 1), for: .selected)
        hostButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        hostButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.mainview.snp.centerX).offset(40)
            make.top.equalTo(programButton)
            make.height.greaterThanOrEqualTo(19)
            make.trailing.equalTo(mainview.snp.trailing)
            hostButton.titleLabel?.textAlignment = .center
            hostButton.addTarget(self, action: #selector(self.changePage(sender:)), for: .touchUpInside)
        }
        hostButton.tag = 1001

        self.makeUICollectionView(collectionview: hostCollectionView)
        self.makeUICollectionView(collectionview: programCollectionView)
        circleView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.mainview).offset(-40)
            make.width.height.equalTo(80)
            circleView.backgroundColor = UIColor.white
            circleView.layer.cornerRadius = 40
            circleView.layer.masksToBounds = true
        }
    }
    
    func changePage(sender:UIButton)  {

        if sender.tag == 1000 {
            self.hostButton.isEnabled = true
            self.hostButton.isSelected = false
            self.hostButton.setTitleColor(UIColor.gray, for: .normal)
            

            self.programButton.isEnabled = false
            self.programButton.isSelected = true
            self.programButton.setTitleColor(UIColor(red: 70/255, green: 160/255, blue: 194/255, alpha: 1), for: .normal)
            UIView.setAnimationDuration(1)
            UIView.setAnimationCurve(.easeInOut)
            UIView.beginAnimations("host", context: nil)
            UIView.setAnimationTransition(.curlUp, for: self, cache: true)
            UIView.commitAnimations()
            self.mainview.bringSubview(toFront: programCollectionView)
        }else if sender == hostButton{
            self.hostButton.isEnabled = false
            self.hostButton.isSelected = true
            self.hostButton.setTitleColor(UIColor(red: 70/255, green: 160/255, blue: 194/255, alpha: 1), for: .normal)



            self.programButton.isEnabled = true
            self.programButton.isSelected = false
            self.programButton.setTitleColor(UIColor.gray, for: .normal)
            UIView.setAnimationDuration(1)
            UIView.setAnimationCurve(.easeInOut)
            UIView.beginAnimations("program", context: nil)
            UIView.setAnimationTransition(.curlDown, for: self, cache: true)
            UIView.commitAnimations()
            self.mainview.bringSubview(toFront: hostCollectionView)
        }
    }

    
    func makeUICollectionView(collectionview: UICollectionView) ->Void {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.itemSize = CGSize(width: 66, height: 80)
        
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        collectionview.collectionViewLayout = layout
        collectionview.backgroundColor = UIColor.white
        collectionview.register(HostCell.self, forCellWithReuseIdentifier: HduRaidoHostCellIdentify)
        collectionview.register(HduRadioLargeCell.self, forCellWithReuseIdentifier: HduLargetCellIdentify)
        collectionview.register(ProgramCell.self, forCellWithReuseIdentifier: HduProgramCellIdentify)
        self.mainview.addSubview(collectionview)
        
        collectionview.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(mainview.snp.top).offset(42)
            make.bottom.equalTo(0)
        }
    }

    
}
