//
//  HduRadioPalyViewController.swift
//  HduIn
//
//  Created by 姜永铭 on 11/7/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import UIKit

class HduRadioPalyViewController: BaseViewController {

    var playView = HduRaioPlayView()
    var backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(playView)
        self.view.addSubview(backButton)
        playView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        playView.hostLabel.text = "主播：于心诺"
        playView.directorLabel.text = "导播：于心诺"
        playView.producerLabel.text  = "监制：于心诺"
        playView.songNameLabel.text = "《富士山下》"
        playView.titleLabel.text = "文字来信"
        playView.startLabel.text = "00:00"
        playView.endLabel.text = "05:07"
        
        backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.top.equalTo(32)
            make.width.height.equalTo(20)
            backButton.setImage(UIImage(named: "Radio-back"), for: UIControlState.normal)
            
        }
        backButton.addTarget(self, action: #selector(self.back), for: .touchUpInside)
    }
    
    func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playView.backgroundImageView.addGradientLayer([UIColor.HISapphire,UIColor.HICornflower])
//        playView.backgroundImageView.addGradientLayer([UIColor])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
