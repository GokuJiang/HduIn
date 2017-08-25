//
//  PostViewController.swift
//  HduIn
//
//  Created by 赵逸文 on 2017/3/14.
//  Copyright © 2017年 姜永铭. All rights reserved.
//

import UIKit
import DateTimePicker
import Qiniu

class PostViewController: BaseViewController {
    
    var segmentControl = UISegmentedControl(items: ["发布招领信息","发布失物信息"])
    var mainTableView = UITableView()
    var postButton = UIButton()
    let map = ["一卡通": 1,"书籍资料": 2,"衣物饰品": 3,"交通工具": 4,"随身物品": 5,"电子数码": 6,"卡类物件": 7,"其他物品": 0]
    var selectPhotoButton = UIButton(frame: CGRect(x: 16, y: 3, width: 85, height: 22))
    var tap: UITapGestureRecognizer?
    var txetView: UITextView?
    
    //MARK: 标题数组
    let tableItem1 = ["物品名称","物品类型","捡到时间","捡到地点","领取地点","联系方式","详细信息"]
    let tableItem2 = ["物品名称","物品类型","失物时间","失物地点","联系方式","详细信息"]
    let cardArray1 = ["物品名称","物品类型","一卡通姓名","一卡通学号","捡到时间","捡到地点","领取地点","联系方式","详细信息"]
    let cardArray2 = ["物品名称","物品类型","一卡通姓名","一卡通学号","失物时间","失物地点","联系方式","详细信息"]
    
    //MARK: Upload data
    var lostModel = FindoutLostModel()
    var findModel = FindoutLostModel()
    
    
    var isUpload:Bool = false
    
    var provider = APIProvider<FindBackTarget>()
    var uploadString = Array.init(repeating: "", count: 9)
    
// MARK: - Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发布"
        showBackActionButton()
        addViews()
        setupView()
        setNavigation()
        self.lostModel.mode = .lost
        self.findModel.mode = .find
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addViews(){
        self.view.addSubview(segmentControl)
        self.view.addSubview(mainTableView)
        self.view.addSubview(postButton)
    }
    
    func setNavigation(){
        let leftBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Back-LostFound"), style: .plain, target: self, action: #selector(self.navigateBack(sender:)))
        leftBarItem.tintColor = UIColor(hex: "6d6d6d")
        self.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    func setupView(){
        self.segmentControl.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.centerX.equalTo(self.view)
            make.width.greaterThanOrEqualTo(30)
            make.height.greaterThanOrEqualTo(30)
            segmentControl.layer.borderWidth = 2
            segmentControl.layer.cornerRadius = 3
            segmentControl.layer.borderColor = HIColor.hduGreenBlue.cgColor
            segmentControl.layer.masksToBounds = true
            segmentControl.tintColor = HIColor.hduGreenBlue
            segmentControl.selectedSegmentIndex = 0
            segmentControl.addTarget(self, action: #selector(self.segmentChange), for: .valueChanged)
        }
        
        self.mainTableView.snp.makeConstraints { (make) in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.leading.equalTo(0)
            make.trailing.equalTo(-10)
            make.bottom.equalTo(-100)
            
        mainTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCellFind")
            mainTableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCellLost")
            mainTableView.delegate = self
            mainTableView.dataSource = self
            mainTableView.estimatedRowHeight = 80
            mainTableView.rowHeight = UITableViewAutomaticDimension
            
            let footView = UIView(frame: CGRect(x: 5, y: 5, width: SCREEN_WIDTH, height: 30))
            footView.addSubview(self.selectPhotoButton)
            self.selectPhotoButton.setTitle("上传照片", for: .normal)
            self.selectPhotoButton.setTitleColor(HIColor.hduGreenBlue, for: .normal)
            self.selectPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            self.selectPhotoButton.addTarget(self, action: #selector(self.selectPhoto), for: .touchUpInside)
            mainTableView.tableFooterView = footView
        }
        
        self.postButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(-30)
            make.width.equalTo(100)
            make.height.equalTo(40)
            postButton.setTitle("发布", for: .normal)
            postButton.backgroundColor = HIColor.hduGreenBlue
            postButton.tintColor = UIColor.white
            postButton.layer.cornerRadius = 20
            postButton.layer.masksToBounds = true
            postButton.addTarget(self, action: #selector(self.postInfo), for: .touchUpInside)
        }
    }
    
    func segmentChange(){
        self.mainTableView.reloadData()
    }
    
    func selectPhoto(){
        let photoVC = PhotoPickerViewController()
        photoVC.delegate = self
        self.present(photoVC, animated: true, completion: nil)
    }
    
    func postInfo(){
        let alter = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "朕知道了", style: .cancel, handler: nil)
        alter.addAction(okAction)
    
        if self.segmentControl.selectedSegmentIndex == 0{
            if self.findModel.canUpload {
                _ = provider.request(.postFind(self.findModel))
                    .mapJSON()
                    .subscribe({ (event) in
                        switch event{
                        case .next(let results):
                            log.debug(results)
                            self.dismiss(animated: true, completion: nil)
                        case .error(let error):
                            log.debug(error)
                            alter.title = "网络好像有点问题。"
                            self.present(alter, animated: true, completion: nil)
                        default:
                            break
                        }
                    })
            } else {
                alter.title = "没有把必填信息填完整哦！"
                self.present(alter, animated: true, completion: nil)
            }
        }else{
            if self.lostModel.canUpload {
                _ = provider.request(.postLost(self.lostModel))
                    .mapJSON()
                    .subscribe({ (event) in
                        switch event{
                        case .next(let results):
                            log.debug(results)
                            self.dismiss(animated: true, completion: nil)
                        case .error(let error):
                            log.debug(error)
                            alter.title = "网络好像有点问题。"
                            self.present(alter, animated: true, completion: nil)
                        default:
                            break
                        }
                    })
            } else {
                alter.title = "没有把必填信息填完整哦！"
                self.present(alter, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - SELECTED CELL

extension PostViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.segmentControl.selectedSegmentIndex == 0{
            let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
            
            switch indexPath.row {
            case 1:
                let vc = SelectClassViewController()
                self.present(BaseNavigationController(rootViewController:vc), animated: true, completion: nil)
                vc.closure = { (labelValue)  in
                    self.findModel.typeName = labelValue
                    self.findModel.type = self.map[labelValue]
                    self.mainTableView.reloadData()
                    cell.textView.text = labelValue
                }
            case 2:
                if !self.findModel.isCard {
                    // Time Pick
                    self.creatTime(cell: cell)
                }
            case 4:
                if self.findModel.isCard {
                    self.creatTime(cell: cell)
                }
            default:
                break
            }
            
        }else{
            let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
            
            switch indexPath.row {
           
            case 1:
                let vc = SelectClassViewController()
                self.present(BaseNavigationController(rootViewController:vc), animated: true, completion: nil)
                vc.closure = { (labelValue)  in
                    self.lostModel.typeName = labelValue
                    self.lostModel.type = self.map[labelValue]
                    self.mainTableView.reloadData()
                    cell.textView.text = labelValue
                }
            case 2:
                if !self.lostModel.isCard {
                    // Time Pick
                    self.creatTime(cell: cell)
                }
            case 4:
                if self.lostModel.isCard {
                    self.creatTime(cell: cell)
                }
            default:
                break
            }
        }
    }

    //Time Picker
    func creatTime(cell: PostTableViewCell){
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255/255.0, green: 138/255.0, blue: 138/255.0, alpha: 1)
        picker.completionHandler = { date in
            cell.textView.text = date.toString(format: DateFormat.Custom("yyyy-MM-dd HH:mm"))
            if self.segmentControl.selectedSegmentIndex == 0{
                self.findModel.foundTime = cell.textView.text
                print.debug(self.findModel.foundTime)
            }else {
                self.lostModel.lostTime = cell.textView.text
            }
        }
        
    }
    
    func makeMap(_ str:[String]) -> Dictionary<String, Int> {
        
        var dic: Dictionary<String, Int> = [:]
        for i in 0..<str.count {
            dic[str[i]] = i
        }
        return dic
    }
    
    func pullView(index: Int){
        if index - 1000 > 4 {
            UIView.animate(withDuration: 0.4, animations: {
                self.view.frame.origin.y = -CGFloat((index - 1000) * 20)
            })
        }else {
            UIView.animate(withDuration: 0.4, animations: {
                self.view.frame.origin.y = 0
            })
        }
    }
}

// MARK: - Fill Interface
extension PostViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentControl.selectedSegmentIndex == 0{
            return self.findModel.isCard ? cardArray1.count : tableItem1.count
        }else{
            return self.lostModel.isCard ? cardArray2.count : tableItem2.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempMap: Dictionary<String, Int>
        
        if self.segmentControl.selectedSegmentIndex == 0{
            let cell = PostTableViewCell(style: .default, reuseIdentifier: "PostTableViewCellFind")
           cell.textView.tag = 1000 + indexPath.row
            cell.textView.delegate = self
            if !self.findModel.isCard {
                cell.titleLable.text = tableItem1[indexPath.row]
                tempMap = self.makeMap(self.tableItem1)
                if let i = tempMap[tableItem1[indexPath.row]] {
                    switch i {
                    case 0:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.findModel.name
                    case 1:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.findModel.typeName
                    case 2:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.findModel.foundTime
                    case 3:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.findModel.findLocation
                    case 4:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.findModel.pickupLocation
                    case 5:
                        cell.textView.keyboardType = UIKeyboardType.numberPad
                        cell.textView.text = self.findModel.contact
                    default:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.icon.text = ""
                    }
                    
                }
            }else{
                cell.titleLable.text = cardArray1[indexPath.row]
                tempMap = self.makeMap(self.cardArray1)
                if let i = tempMap[cardArray1[indexPath.row]] {
                    switch i {
                    case 0:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.findModel.name
                    case 1:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.findModel.typeName
                    case 2:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.findModel.studentName
                    case 3:
                        cell.textView.keyboardType = UIKeyboardType.numberPad
                        cell.textView.text = self.findModel.studentNumber
                    case 4:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.findModel.foundTime
                    case 5:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.findModel.findLocation
                    case 6:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.findModel.pickupLocation
                    case 7:
                        cell.textView.keyboardType = UIKeyboardType.numberPad
                        cell.textView.text = self.findModel.contact
                    default:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.icon.text = ""
                    }
                }

            }
            return cell
                
        }else{
            let cell = PostTableViewCell(style: .default, reuseIdentifier: "PostTableViewCellLost")
            cell.textView.tag = 1000 + indexPath.row
            cell.textView.delegate = self
            if !self.lostModel.isCard {
                cell.titleLable.text = tableItem2[indexPath.row]
                tempMap = self.makeMap(self.tableItem2)
                if let i = tempMap[tableItem2[indexPath.row]] {
                    switch i {
                    case 0:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.lostModel.name
                    case 1:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.lostModel.typeName
                    case 2:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.lostModel.lostTime
                    case 3:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.lostModel.lostLocation
                    case 4:
                        cell.textView.keyboardType = UIKeyboardType.numberPad
                        cell.textView.text = self.lostModel.contact
                    default:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.icon.text = ""
                    }
                }
            }else{
                cell.titleLable.text = cardArray2[indexPath.row]
                tempMap = self.makeMap(self.cardArray2)
                if let i = tempMap[cardArray2[indexPath.row]] {
                    switch i {
                    case 0:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.lostModel.name
                    case 1:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.lostModel.typeName
                    case 2:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.lostModel.studentName
                    case 3:
                        cell.textView.keyboardType = UIKeyboardType.numberPad
                        cell.textView.text = self.lostModel.studentNumber
                    case 4:
                        cell.accessoryType = .disclosureIndicator
                        cell.textView.isEditable = false
                        cell.textView.text = self.lostModel.lostTime
                    case 5:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.textView.text = self.lostModel.lostLocation
                    case 6:
                        cell.textView.keyboardType = UIKeyboardType.numberPad
                        cell.textView.text = self.lostModel.contact
                    default:
                        cell.textView.keyboardType = UIKeyboardType.default
                        cell.icon.text = ""
                    }
                }

            }
            return cell
        }
    }
}

// MARK: - Save Info
extension PostViewController: UITextViewDelegate{
    
    func dismissKeyboard(){
        if let textView = self.txetView {
            textView.resignFirstResponder()
            UIView.animate(withDuration: 0.4, animations: {
                self.view.frame.origin.y = 0
            })
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       // textView.becomeFirstResponder()
        self.txetView = textView
        pullView(index: textView.tag)
        self.tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        if let tap = self.tap{
            self.view.addGestureRecognizer(tap)
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        if let tap = self.tap {
            self.view.removeGestureRecognizer(tap)
            self.tap = nil
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        if self.segmentControl.selectedSegmentIndex == 0 {
            switch textView.tag - 1000 {
            case 0:
                self.findModel.name =  textView.text
            case 2:
                if self.findModel.isCard {
                    self.findModel.studentName = textView.text
                }
            case 3:
                if self.findModel.isCard {
                    self.findModel.studentNumber = textView.text
                }else{
                    self.findModel.findLocation = textView.text
                }
            case 4:
                if !self.findModel.isCard {
                    self.findModel.pickupLocation = textView.text
                }
            case 5:
                if self.findModel.isCard {
                    self.findModel.findLocation = textView.text
                }else{
                    self.findModel.contact = textView.text
                }
            case 6:
                if self.findModel.isCard {
                    self.findModel.pickupLocation = textView.text
                }else{
                    self.findModel.descriptionField = textView.text
                }
            case 7:
                self.findModel.contact = textView.text
            default:
                self.findModel.descriptionField = textView.text
            }
        }else{
            switch textView.tag - 1000 {
            case 0:
                self.lostModel.name = textView.text
            case 2:
                if self.lostModel.isCard {
                    self.lostModel.studentName = textView.text
                }
            case 3:
                if self.lostModel.isCard {
                    self.lostModel.studentNumber = textView.text
                }else{
                    self.lostModel.lostLocation = textView.text
                }
            case 4:
                if !self.lostModel.isCard {
                    self.lostModel.contact = textView.text
                }
            case 5:
                if self.lostModel.isCard {
                    self.lostModel.lostLocation = textView.text
                }else{
                    self.lostModel.descriptionField = textView.text
                }
            case 6:
                self.lostModel.contact = textView.text
            default:
                self.lostModel.descriptionField = textView.text
            }
        }
    }
    
}

extension PostViewController: PhotoPickerDelegate {
    func getImageFromPicker(photoPickerViewController: PhotoPickerViewController, imageInfo info: [String : Any], imageData data: Data) {
        print.debug(data)
        QiniuAgent.shareInstance.uploadDataToQiniu(imageData: data, type: "img") { (info, key, resp) in
            if let key = resp?["key"] as? String {
                print.debug(key)
            }
        }

    }
}
