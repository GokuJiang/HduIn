////
////  NewsPostViewController.swift
////  HduIn
////
////  Created by Lucas Woo on 4/4/16.
////  Copyright © 2016 Redhome. All rights reserved.
////
//
//import Foundation
//import WebKit
//
//class NewsPostViewController: BaseViewController {
//
//    let webView = WKWebView()
//
//    var post: NewsPost? {
//        didSet {
//            guard let post = post else {
//                return
//            }
//            let urlString = "/blog/post/\(post.slug)"
//            guard let url = NSURL(string: urlString,
//                relativeToURL: NSURL(string: Networking.Base.News.rawValue)!
//            ) else {
//                return
//            }
//            webView.loadRequest(NSURLRequest(URL: url))
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        webView.frame = self.view.frame
//        webView.navigationDelegate = self
//        self.view = webView
//    }
//
//}
//
//extension NewsPostViewController: WKNavigationDelegate {
//
//}
