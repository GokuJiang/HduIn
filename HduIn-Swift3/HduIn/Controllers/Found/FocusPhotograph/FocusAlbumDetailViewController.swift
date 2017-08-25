//
//  FocusAlbumDetailViewController.swift
//  HduIn
//
//  Created by Kevin on 2016/12/17.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit
import XHWaterfallFlowLayout

class FocusAlbumDetailViewController: UIViewController {
    var id:Int = -1
    var albumDetailHeadView = AlbumDetailHeadView()
    var backBtn = UIButton()
    var photoCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: XHWaterfallFlowLayout())
    var scrollDown: Bool = true
    var scrollContentOffsetY: CGFloat = 0
    var provider = APIProvider<FocusTarget>()
    var model:FocusAlbumModel? {
        didSet {
            if let title = self.model?.title{
                self.albumDetailHeadView.titalLable.text = title
            }
            if let subtitle = self.model?.descriptionLable{
                self.albumDetailHeadView.subTitalLable.text = subtitle
            }
            if let cover = self.model?.cover{
                self.albumDetailHeadView.bgImage.yy_imageURL = URL(string: cover)
            }
            if let count = self.model?.photos?.count{
                self.albumDetailHeadView.countLable.text = count.description
            }
            
            if let photo = self.model?.photos {
                images = Array<UIImage>(repeating: UIImage(), count: photo.count)
                self.photoCollectionView.reloadData()
            }
        }
    }
    var countOfImages:Int = 0 {
        didSet {
            if countOfImages == images.count {
                self.photoCollectionView.reloadData()
            }
        }
    }
    var images:[UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(albumDetailHeadView)
        self.view.addSubview(backBtn)
        self.view.addSubview(photoCollectionView)
        setHeadView()
        showCloseButton()
        showCollectionView()
        getData()
    }
    func setHeadView(){
        self.albumDetailHeadView.snp.makeConstraints { (make) in
            make.trailing.leading.top.equalTo(0)
            make.height.equalTo(SCREEN_HEIGHT * 0.45)
        }
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
    
    func showCollectionView(){
        self.photoCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(albumDetailHeadView.snp.bottom)
            make.trailing.leading.bottom.equalTo(0)
        }
        self.photoCollectionView.backgroundColor = UIColor.white
        self.photoCollectionView.register(PhotographerCollectionViewCell.self, forCellWithReuseIdentifier: PhotographerCollectionViewCellIdentify)
        let layout = XHWaterfallFlowLayout()
        layout.columnCount = 2
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sDelegate = self
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.photoCollectionView.collectionViewLayout = layout
    }
    
    func getData(){
        _ = provider.request(.singleAlbum(String(id))).mapObject(FocusAlbumModel.self).subscribe{(event) in
            switch event{
            case .next(let results):
                log.debug(results)
                self.model = results
            case .error(let error):
                log.error(error)
            case .completed:
                break
            }
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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

extension FocusAlbumDetailViewController: XHWaterfallFlowLayoutDelegate{    
    func getImageRatio(ofWidthAndHeight indexPath: IndexPath!) -> CGFloat {
        let image = images[indexPath.item]
        let height  = image.size.height
        let width = image.size.width
        if height == 0 || width == 0 {
            return 1
        }
        let ratio = (image.size.width) / (image.size.height)
        return ratio
    }
    
}

extension FocusAlbumDetailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let photo = model?.photos{
            return photo.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotographerCollectionViewCellIdentify, for: indexPath) as? PhotographerCollectionViewCell {
            guard let photos = self.model?.photos else {
                return UICollectionViewCell()
            }
            if let url = photos[indexPath.item].url{
                cell.imageView.contentMode = .scaleToFill
                cell.imageView.yy_setImage(with: URL(string:url), placeholder: nil, options: .useNSURLCache, completion: { (image, url, type, stateg, error) in
                    if let image = image {
                        self.images[indexPath.item] = image
                        self.countOfImages += 1
                    }
                })
                if let like = photos[indexPath.item].like {
                    cell.likeLabel.text = like.description
                }
            }
            return cell
        }
        
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.alpha = 0.2
        if (self.scrollDown == true) {
            cell.transform = CGAffineTransform(translationX: 0, y: 20)
            
            UIView.animate(withDuration: 1) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1;
            }
        }
        else
        {
            cell.transform = CGAffineTransform(translationX: 0, y: -20)
            
            UIView.animate(withDuration: 1) {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1;
            }
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.scrollDown = scrollView.contentOffset.y - scrollContentOffsetY > 0 ? true : false
        
        self.scrollContentOffsetY = scrollView.contentOffset.y
    }
}

