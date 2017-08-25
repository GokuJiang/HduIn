//
//  BookHostViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/5.
//  Copyright © 2016年 Kevin. All rights reserved.
//

import UIKit

class BookHostViewController: BaseViewController {
    
    var backBtn = UIButton()
    var leftBtn = UIButton()
    var rightBtn = UIButton()
    var hostView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addViews()
        self.showCloseButton()
        self.setLeftBtn()
        self.setRightBtn()
        self.setHostView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addGradientLayer([
            UIColor(red: 93/255, green: 195/255, blue: 252/255, alpha: 1),
            UIColor(red: 113/255, green: 180/255, blue: 241/255, alpha: 1),
            UIColor(red: 149/255, green: 172/255, blue: 230/255, alpha: 1)
        ])
    }
    func addViews(){
        self.view.addSubview(hostView)
        self.view.addSubview(backBtn)
        self.view.addSubview(leftBtn)
        self.view.addSubview(rightBtn)
    }
    
    func showCloseButton(){
        self.backBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 18, height: 18))
            make.leading.equalTo(16)
            make.top.equalTo(28)
        }
        self.backBtn.setImage(UIImage(named: "Radio-back"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(self.back), for: UIControlEvents.touchUpInside)
        
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }

    
       
    func setLeftBtn(){
        self.leftBtn.setImage(UIImage(named: "Radio-Left"), for: UIControlState.normal)
        self.leftBtn.addTarget(self, action: #selector(self.leftScoller), for: .touchDragInside)
        self.leftBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.height.equalTo(22)
            make.centerY.equalTo(self.view)
        }
    }
    
    func setRightBtn(){
        self.rightBtn.setImage(UIImage(named: "Radio-Right"), for: UIControlState.normal)
        self.rightBtn.addTarget(self, action: #selector(self.rightScoller), for: .touchDragInside)
        self.rightBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.height.equalTo(22)
            make.centerY.equalTo(self.view)
        }
    }
    
    func setHostView(){
        let pageWidth = SCREEN_WIDTH - 20
        let pageHeight = SCREEN_HEIGHT
        let numOfPages = 5
        self.hostView.isPagingEnabled = true
        self.hostView.showsVerticalScrollIndicator = false
        self.hostView.showsHorizontalScrollIndicator = false
        self.hostView.scrollsToTop = false
        self.hostView.contentSize = CGSize(width: pageWidth * CGFloat(numOfPages), height: pageHeight)
        for i in 0..<numOfPages{
            let contentView = HduHostView(frame: CGRect(x: CGFloat(Int(pageWidth) * i), y: CGFloat(0), width: CGFloat(pageWidth), height: CGFloat(pageHeight)))
            contentView.playBtn.addTarget(self, action: #selector(self.play(sender:)), for: .touchUpInside)
            hostView.addSubview(contentView)
            
        }
        self.hostView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.bottom.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH - 20)
        }
    }

    func play(sender:UIButton!){
        let vc = HduRadioPalyViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func leftScoller(){
        let offset = self.hostView.contentOffset.x
        let offsetTo = CGPoint(x: offset - (SCREEN_WIDTH - 20), y: 0)
        log.debug(offset)
        if(offset >= SCREEN_WIDTH - 30){
            self.hostView.setContentOffset(offsetTo, animated: true)
        }
    }
    
    func rightScoller(){
        let offset = self.hostView.contentOffset.x
        let offsetTo = CGPoint(x: offset + SCREEN_WIDTH - 20, y: 0)
        self.hostView.setContentOffset(offsetTo, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
