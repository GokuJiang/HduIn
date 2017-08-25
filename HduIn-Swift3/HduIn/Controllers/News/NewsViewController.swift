////
////  NewsViewController.swift
////  HduIn
////
////  Created by Lucas on 9/20/15.
////  Copyright © 2015 Redhome. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//import RxSwift
//
//class NewsViewController: BaseViewController {
//
//    let newsView = NewsView()
//    let networking = NewsNetworking.instance
//
//    var postsResult: Results<NewsPost>? = nil {
//        didSet {
//            postsResult = postsResult?
//                .filter("state == %@", NewsPost.State.Published.rawValue)
//                .sorted("weight", ascending: false)
//        }
//    }
//
//    // MARK: View LifeCycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        newsView.frame = self.view.frame
//        newsView.delegate = self
//        newsView.dataSource = self
//        newsView.newsViewDelegate = self
//        self.view = newsView
//
//        _ = observeData().subscribe { (event) in
//                switch event {
//                case .Next:
//                    self.newsView.reloadData()
//                case .Error(let error):
//                    log.error("Fetch posts failed with error: \(error)")
//                case .Completed:
//                    break
//                }
//            }
//    }
//
//    func observeData(offset offset: Int = 0) -> Observable<Results<NewsPost>> {
//        return networking.allCategoriesObservable()
//            .flatMap { (categories) -> Observable<Results<NewsPost>> in
//                return self.networking.postsObservable(offset: offset)
//            }
//            .map { (posts) -> Results<NewsPost> in
//                self.postsResult = posts
//                return posts
//            }
//    }
//}
//
//// MARK: - TabViewController
//extension NewsViewController: TabViewController {
//    func setupTabInfo() {
//        let title = "title_news".localized()
//        self.title = title
//
//        let newsTabBarItem = UITabBarItem(
//            title: title,
//            image: UIImage(named: "TabBar-News")?.imageWithRenderingMode(.AlwaysOriginal),
//            selectedImage: UIImage(named: "TabBar-News-Highlight")?
//                .imageWithRenderingMode(.AlwaysOriginal)
//        )
//
//        self.tabBarItem = newsTabBarItem
//    }
//}
//
//// MARK: - NewsViewDelegate
//extension NewsViewController: NewsViewDelegate {
//    func viewNeedRefresh(done: () -> ()) {
//        _ = observeData()
//            .subscribe { (event) in
//                switch event {
//                case .Next(let posts):
//                    self.postsResult = posts
//                case .Error(let error):
//                    log.error("refresh posts failed with error: \(error)")
//                case .Completed:
//                    break
//                }
//                done()
//            }
//    }
//
//    func viewNeedMoreData(done: (Bool) -> ()) {
//        _ = observeData(offset: self.postsResult?.count ?? 0)
//            .subscribe { (event) in
//                switch event {
//                case .Next(let posts):
//                    self.postsResult = posts
//                case .Error(let error):
//                    log.error("load more posts failed with error: \(error)")
//                case .Completed:
//                    break
//                }
//                done(self.postsResult?.count == self.networking.postsCount)
//            }
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension NewsViewController: UITableViewDelegate {
//    func tableView(
//        tableView: UITableView,
//        heightForRowAtIndexPath indexPath: NSIndexPath
//    ) -> CGFloat {
//        guard let result = postsResult else {
//            return 0
//        }
//        let post = result[indexPath.row]
//
//        switch post.mode {
//        case .Common:
//            return NewsCommonCell.cellHeight
//        case .Hybrid:
//            return NewsHybridCell.cellHeightForWidth(self.view.frame.width)
//        case .Banner:
//            return NewsBannerCell.cellHeightForWidth(self.view.frame.width)
//        }
//    }
//
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let postViewController = NewsPostViewController()
//        postViewController.post = postsResult?[indexPath.row]
//        navigationController?.pushViewController(postViewController, animated: true)
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension NewsViewController: UITableViewDataSource {
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return postsResult?.count ?? 0
//    }
//
//    func tableView(
//        tableView: UITableView,
//        cellForRowAtIndexPath indexPath: NSIndexPath
//    ) -> UITableViewCell {
//        guard let result = postsResult else {
//            return UITableViewCell()
//        }
//        let post = result[indexPath.row]
//
//        switch post.mode {
//        case .Common:
//            guard let cell = tableView
//                .dequeueReusableCellWithIdentifier(NewsCommonCell.reuseIdentifier)
//                as? NewsCommonCell else {
//                    let cell = NewsCommonCell()
//                    cell.fillData(post)
//                    return cell
//                }
//            cell.fillData(post)
//            return cell
//        case .Hybrid:
//            guard let cell = tableView
//                .dequeueReusableCellWithIdentifier(NewsHybridCell.reuseIdentifier)
//                as? NewsHybridCell else {
//                    let cell = NewsHybridCell()
//                    cell.fillData(post)
//                    return cell
//            }
//            cell.fillData(post)
//            return cell
//        case .Banner:
//            guard let cell = tableView
//                .dequeueReusableCellWithIdentifier(NewsBannerCell.reuseIdentifier)
//                as? NewsBannerCell else {
//                    let cell = NewsBannerCell()
//                    cell.fillData(post)
//                    return cell
//            }
//            cell.fillData(post)
//            return cell
//        }
//    }
//}
