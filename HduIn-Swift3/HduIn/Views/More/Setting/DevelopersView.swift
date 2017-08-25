//
//  DevelopersView.swift
//  HduIn
//
//  Created by Lucas on 10/13/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class DevelopersView: UIView {

    struct Developer {
        let name: String
        let position: String
        let avatar: String
    }

    let tableView = UITableView()
    let developers = [
        Developer(name: "糯米", position: "UI设计师", avatar: "糯米"),
        Developer(name: "东东", position: "UI设计师", avatar: "东东"),
        Developer(name: "赵逸文", position: "iOS工程师", avatar: "赵逸文"),
        Developer(name: "杨骏垒Gary", position: "iOS工程师", avatar: "杨骏垒"),
        Developer(name: "馒头", position: "UI设计师", avatar: "Mantou"),
        Developer(name: "吞吞", position: "iOS工程师", avatar: "Tuntun"),
        Developer(name: "姜永铭", position: "iOS工程师", avatar: "Jiang"),
        Developer(name: "小七", position: "iOS工程师", avatar: "Qi"),
        Developer(name: "胖胖", position: "产品经理", avatar: "Pangpang")
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        tableView.register(DeveloperCell.self, forCellReuseIdentifier: "DeveloperCell")
        tableView.register(AboutCell.self, forCellReuseIdentifier: "AboutCell")
        tableView.backgroundColor = UIColor(hex: "f5f5f5")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        self.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.center.equalTo(self)
            make.size.equalTo(self)
        }
    }

    class DeveloperCell: UITableViewCell {
        let avatarImageView = UIImageView()
        let nameLabel = UILabel()
        let positionLabel = UILabel()

        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupView()
        }

        func setupView() {
            self.backgroundColor = UIColor.white

            self.addSubview(avatarImageView)
            avatarImageView.snp.makeConstraints { (make) -> Void in
                make.size.equalTo(CGSize(width: 50, height: 50))
                make.leading.equalTo(self).offset(20)
            }

            nameLabel.textColor = UIColor(hex: "434343")
            nameLabel.font = UIFont.systemFont(ofSize: 15)
            self.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(14)
                make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            }

            positionLabel.textColor = UIColor(hex: "a0a0a0")
            positionLabel.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(positionLabel)
            positionLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(nameLabel.snp.bottom).offset(8)
                make.leading.equalTo(nameLabel)
            }
        }
    }

    class AboutCell: UITableViewCell {
        let logoImageView = UIImageView()
        let aboutLabel = UILabel()
        let contactLabel = UILabel()

        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupView()
        }

        func setupView() {
            self.backgroundColor = UIColor.white

            aboutLabel.numberOfLines = 0
            aboutLabel.text = "    我们都来自红色家园工作室，如果你会移动端开发、 UI 设计并有兴趣致力于这个旨在服务杭电的移动 App ，欢迎加入我们。"
            aboutLabel.textColor = UIColor(hex: "434343")
            aboutLabel.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(aboutLabel)
            aboutLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(self).offset(-30)
                make.center.equalTo(self)
            }

            logoImageView.image = UIImage(named: "About-Logo")
            self.addSubview(logoImageView)
            logoImageView.snp.makeConstraints { (make) -> Void in
                make.size.equalTo(CGSize(width: 132, height: 56))
                make.centerX.equalTo(self)
                make.bottom.equalTo(aboutLabel.snp.top).offset(-19)
            }

            contactLabel.numberOfLines = 0
            contactLabel.textAlignment = NSTextAlignment.center
            contactLabel.text = "简历发送至：\nhr@redhome.cc\n更多资讯关注：\n官方微信 (e-hduhdu)\n官方微博 (@HduIn)"
            contactLabel.textColor = UIColor(hex: "6b6b6b")
            contactLabel.font = UIFont.systemFont(ofSize: 14)
            self.addSubview(contactLabel)
            contactLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(aboutLabel.snp.bottom).offset(8)
                make.width.equalTo(aboutLabel)
                make.centerX.equalTo(self)
            }
        }
    }
}

extension DevelopersView: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 60
        default:
            return 0
        }
    }
}

extension DevelopersView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "工作室简介"
        case 1:
            return "人员简介"
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return developers.count
        default:
            return 0
        }
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "AboutCell")!
        case 1:
            guard let cell = tableView
                .dequeueReusableCell(withIdentifier: "DeveloperCell") as? DeveloperCell else {
                    return UITableViewCell()
            }
            let item = developers[indexPath.row]
            cell.avatarImageView.image = UIImage(named: "Developer-\(item.avatar)")
            cell.nameLabel.text = item.name
            cell.positionLabel.text = item.position
            if item.name == "杨骏垒Gary"{
                let line = UIView()
                cell.addSubview(line)
                line.backgroundColor = UIColor.gray
                line.snp.makeConstraints({ (make) in
                    make.bottom.equalTo(0)
                    make.leading.trailing.equalTo(0)
                    make.height.equalTo(1)
                })
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
