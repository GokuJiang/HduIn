//
//  FoundView.swift
//  HduIn
//
//  Created by Goku on 16/01/2017.
//  Copyright © 2017 姜永铭. All rights reserved.
//

import UIKit

class ClubView: UIView {
    var audioButton = UIButton()
    var focusButton = UIButton()
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.size.width / 2, y: 7.5))
        path.addLine(to: CGPoint(x: rect.size.width / 2, y: rect.size.height - 7.5))
        path.close()
        UIColor(hex: "eaeaea").set()
        path.stroke()
        path.fill()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor(hex:"eaeaea").cgColor
        self.layer.borderWidth = 1
        
        setupView()
    }
    
    private func setupView() {
        self.addSubview(audioButton)
        self.addSubview(focusButton)
        audioButton.snp.makeConstraints { (make) in
            make.bottom.top.leading.equalTo(0)
            make.trailing.equalTo(self.snp.centerX)
            setButton(button: audioButton, image: "HduRadio-Enter", title: "杭电之声", titleColor: UIColor(hex:"3fb9f4"))
        }
        focusButton.snp.makeConstraints { (make) in
            make.trailing.bottom.top.equalTo(0)
            make.leading.equalTo(self.snp.centerX)
            setButton(button: focusButton, image: "Focus-Logo", title: "焦点摄影", titleColor: UIColor(hex:"0e0e0e").alpha(0.88))
        }
    }
    
    private func setButton(button:UIButton,image:String,title:String,titleColor:UIColor) {
        button.setImage(UIImage(named:image), for: .normal)
        button.setTitle(title, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 25, left: -15, bottom: -25, right: 15)
        button.setTitleColor(titleColor, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: -15, left: 40, bottom: 15, right: -40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class FoundView: UIView {
    
//    var headView = CyclePictureView(frame:  CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: (195.0+22) * (SCREEN_WIDTH / 374.0)), localImageArray: ["head"])
    var headView:CyclePictureView?

    var clubView = ClubView()
    var tableView = UITableView()
    
    init(urlImage:[String]){
        super.init(frame: CGRect.zero)
        self.headView = CyclePictureView(frame: CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: (195.0+22) * (SCREEN_WIDTH / 374.0)), imageURLArray: urlImage)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView(){
        guard let headView = self.headView else {
            return
        }
        self.addSubview(headView)
        self.addSubview(tableView)
        self.addSubview(clubView)
        self.backgroundColor = UIColor(hex: "f7f7f7")
        clubView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(headView.snp.bottom)
            make.height.equalTo(106)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(clubView.snp.bottom).offset(13)
            make.leading.trailing.bottom.equalTo(0)
            tableView.layer.borderWidth  = 1
            tableView.layer.borderColor = UIColor(hex: "d6d6d6").cgColor
        }
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(FoundTableViewCell.self, forCellReuseIdentifier: foundcellIdnetifier)
        let footerView = UIView()
        footerView.backgroundColor = UIColor(hex:"f7f7f7")
        tableView.tableFooterView = footerView
    }


}
