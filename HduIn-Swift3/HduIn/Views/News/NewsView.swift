////
////  NewsView.swift
////  HduIn
////
////  Created by Lucas on 9/20/15.
////  Copyright © 2015 Redhome. All rights reserved.
////
//
//import UIKit
//import MJRefresh
//
//class NewsView: UITableView {
//
//    weak var newsViewDelegate: NewsViewDelegate?
//
//    override init(frame: CGRect, style: UITableViewStyle) {
//        super.init(frame: frame, style: style)
//        setupView()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    func setupView() {
//        self.backgroundColor = NewsDefinitions.BackgroundColor
//        self.separatorStyle = .None
//        self.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
//        self.registerClasses()
//
//        self.mj_header = MJRefreshNormalHeader {
//            self.newsViewDelegate?.viewNeedRefresh {
//                self.reloadData()
//                self.mj_header.endRefreshing()
//            }
//        }
//        self.mj_footer = MJRefreshBackNormalFooter {
//            self.newsViewDelegate?.viewNeedMoreData { isNoMoreData in
//                self.reloadData()
//                if isNoMoreData {
//                    self.mj_footer.endRefreshingWithNoMoreData()
//                } else {
//                    self.mj_footer.endRefreshing()
//                }
//            }
//        }
//    }
//
//    func registerClasses() {
//        registerClass(NewsCommonCell.self, forCellReuseIdentifier: NewsCommonCell.reuseIdentifier)
//        registerClass(NewsHybridCell.self, forCellReuseIdentifier: NewsHybridCell.reuseIdentifier)
//        registerClass(NewsBannerCell.self, forCellReuseIdentifier: NewsBannerCell.reuseIdentifier)
//    }
//
//}
//
//protocol NewsViewDelegate: class {
//    func viewNeedRefresh(done: () -> ())
//    func viewNeedMoreData(done: (Bool) -> ())
//}
