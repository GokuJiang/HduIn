//
//  AboutView.swift
//  HduIn
//
//  Created by Lucas on 7/15/15.
//  Copyright (c) 2015 Redhome. All rights reserved.
//

import UIKit

class AboutView: UIView {

    // MARK: Views
    fileprivate let logoImage = UIImageView()
    fileprivate let versionLabel = UILabel()
    let aboutTable = UITableView()
    fileprivate let copyrightLabel = UILabel()

    var delegate: AboutViewDelegate!
    var dataSource: AboutViewDataSource!

    // MARK: LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: Private Methods

    fileprivate func setupView() {
        self.backgroundColor = UIColor(hex: "f1f2f3")

        logoImage.image = UIImage(named: "About-Banner")
        self.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 117, height: 93))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(83)
        }

        let infoDict = Bundle.main.infoDictionary!
        guard let majorVersion = infoDict["CFBundleShortVersionString"] as? String else {
            return
        }
        guard let minorVersion = infoDict["CFBundleVersion"] as? String else {
            return
        }
        versionLabel.text = "Version \(majorVersion) (\(minorVersion))"
        versionLabel.textColor = UIColor(hex: "adadad")
        versionLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(logoImage.snp.bottom).offset(10)
        }

        aboutTable.dataSource = self
        aboutTable.delegate = self
        aboutTable.isScrollEnabled = false
        aboutTable.backgroundColor = UIColor.clear
        self.addSubview(aboutTable)
        aboutTable.snp.makeConstraints { make in
            make.width.equalTo(self)
            make.height.equalTo(116)
            make.top.equalTo(logoImage.snp.bottom).offset(54)
            make.centerX.equalTo(self)
        }

        copyrightLabel.textColor = UIColor(hex: "bcbcbc")
        copyrightLabel.numberOfLines = 2
        copyrightLabel.textAlignment = NSTextAlignment.center
        copyrightLabel.text = "红色家园版权所有\nCopyRight ©RedhomeStudio"
        copyrightLabel.font = UIFont.systemFont(ofSize: 10)
        self.addSubview(copyrightLabel)
        copyrightLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-8)
        }
    }
}

// MARK: - UITableView Delegate

extension AboutView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.aboutView(self, didSelectRowAtIndexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 39
    }
}

// MARK: - UITableView DataSource

extension AboutView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.aboutView(self, numberOfItemsInTableView: tableView)
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell(
            style: .default,
            reuseIdentifier: "AboutViewCell"
        )
        cell.textLabel?.text = dataSource.aboutView(self, itemAtIndexPath: indexPath)
        cell.textLabel?.textColor = UIColor(hex: "4c4c4c")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
}

// MARK: - Protocol AboutView Delegate

protocol AboutViewDelegate {
    func aboutView(_ aboutView: AboutView, didSelectRowAtIndexPath indexPath: IndexPath)
}

// MARK: - Protocol AboutView DataSource

protocol AboutViewDataSource {
    func aboutView(_ aboutView: AboutView, numberOfItemsInTableView tableView: UITableView) -> Int

    func aboutView(_ aboutView: AboutView, itemAtIndexPath indexPath: IndexPath) -> String
}
