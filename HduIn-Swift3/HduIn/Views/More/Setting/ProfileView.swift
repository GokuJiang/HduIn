//
//  ProfileView.swift
//  HduIn
//
//  Created by Lucas on 10/12/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    let profileImageView = UIImageView()
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let profileTabel = UITableView()

    var delegate: ProfileViewDelegate?
    var dataSource: ProfileViewDataSource? {
        didSet {
            reloadData()
        }
    }

    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: View Methods
    func setupView() {
        self.backgroundColor = UIColor.white

        profileImageView.image = UIImage(named: "Profile-Background")
        profileImageView.layer.shadowColor = UIColor.lightGray.cgColor
        profileImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        profileImageView.layer.shadowOpacity = 0.65
        profileImageView.layer.shadowRadius = 2
        profileImageView.layer.masksToBounds = false
        self.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(213)
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }

        let avatarImageBorder = UIView()
        avatarImageBorder.backgroundColor = UIColor.white
        avatarImageBorder.layer.cornerRadius = 53
        avatarImageBorder.layer.shadowOffset = CGSize(width: 0, height: 0)
        avatarImageBorder.layer.shadowOpacity = 0.65
        avatarImageBorder.layer.shadowRadius = 2
        avatarImageBorder.layer.masksToBounds = false
        self.addSubview(avatarImageBorder)
        avatarImageBorder.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 106, height: 106))
            make.centerX.equalTo(self)
            make.centerY.equalTo(profileImageView.snp.bottom).offset(-18)
        }

        avatarImageView.image = UIImage(named: "Profile-Avatar")
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.masksToBounds = true
        self.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalTo(avatarImageBorder)
        }
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(ProfileView.avatarTapGestureRecognized(sender:))
        )
        avatarImageView.addGestureRecognizer(tapGesture)

        nameLabel.text = "haha"
        nameLabel.textColor = UIColor(hex: "333333")
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(avatarImageBorder.snp.bottom).offset(10)
        }
        
        profileTabel.separatorStyle = .none
        profileTabel.delegate = self
        profileTabel.dataSource = self
        profileTabel.register(ProfileViewCell.self, forCellReuseIdentifier: "ProfileViewCell")
        profileTabel.isScrollEnabled = false
        profileTabel.backgroundColor = UIColor.clear

        self.addSubview(profileTabel)
        profileTabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(28)
            make.leading.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(80)
        }
    }

    func avatarTapGestureRecognized(sender: UITapGestureRecognizer) {
        delegate?.profileView( self, didSelectAvatar: avatarImageView)
    }

    func reloadData() {
        if let dataSource = dataSource {
            
            if let avatarUrl = dataSource.profileView( self, avatarImage: avatarImageView) {
                avatarImageView.yy_setImage(with: URL(string: avatarUrl), options: .progressive)
            }
            nameLabel.text = dataSource.profileView( self, staffName: nameLabel)
            profileTabel.reloadData()
        }
    }

    class ProfileViewCell: UITableViewCell {
        let titleLabel = UILabel()
        let contentLabel = UILabel()
        let accessChevron = UIImageView()

        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupView()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupView()
        }

        func setupView() {
            titleLabel.textColor = UIColor(hex: "7d7d7d")
            titleLabel.font = UIFont.systemFont(ofSize: 15)
            self.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) -> Void in
                make.leading.equalTo(self).offset(15)
                make.centerY.equalTo(self)
            }

            accessChevron.image = UIImage(named: "Profile-RightChevron")
            self.addSubview(accessChevron)
            accessChevron.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(self)
                make.trailing.equalTo(self).offset(-15)
            }

            contentLabel.textColor = UIColor(hex: "333333")
            contentLabel.font = UIFont.systemFont(ofSize: 15)
            self.addSubview(contentLabel)
            contentLabel.snp.makeConstraints { (make) -> Void in
                make.centerY.equalTo(self)
                make.trailing.equalTo(accessChevron.snp.leading).offset(-15)
            }
        }
    }
}

// MARK: - UITabelViewDelegate

extension ProfileView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        delegate?.profileView(profileView: self, didSelectRowAtIndexPath: indexPath)
        delegate?.profileView(self, didSelectRowAtIndexPath: indexPath)
    }


    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 40
    }
}

// MARK: - UITabelViewDataSource

extension ProfileView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: "ProfileViewCell") as? ProfileViewCell else {
                return UITableViewCell()
        }
        
        if let dataSource = dataSource {
            let item = dataSource.profileView(self, itemForRowAtIndexPath: indexPath)
//            let item = dataSource.profileView(profileView: self, itemForRowAtIndexPath: indexPath)
            cell.titleLabel.text = item.title
            cell.contentLabel.text = item.content
        }
        
        return cell

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.profileView(self, numberOfRowInTableView: tableView)
        }
        return 0
    }


}

// MARK: - ProfileViewDelegate

protocol ProfileViewDelegate {
    func profileView(_ profileView: ProfileView, didSelectAvatar avatar: UIImageView)

    func profileView(_ profileView: ProfileView, didSelectRowAtIndexPath indexPath: IndexPath)
}

// MARK: - ProfileViewDataSource

protocol ProfileViewDataSource {
    func profileView(_ profileView: ProfileView, avatarImage avatar: UIImageView) -> String?

    func profileView(_ profileView: ProfileView, staffName nameLabel: UILabel) -> String?

    func profileView(_ profileView: ProfileView, numberOfRowInTableView tableView: UITableView) -> Int

    func profileView(
        _ profileView: ProfileView,
        itemForRowAtIndexPath indexPath: IndexPath
    ) -> ProfileViewController.ProfileViewData
}
