////
////  NewsNetworking.swift
////  HduIn
////
////  Created by Lucas Woo on 3/29/16.
////  Copyright © 2016 Redhome. All rights reserved.
////
//
//import Foundation
//import Moya
//import RxSwift
//import RealmSwift
//
//class NewsNetworking {
//
//    typealias PostsObservable = Observable<Results<NewsPost>>
//    typealias CategoriesObservable = Observable<Results<NewsCategory>>
//
//    static let instance = NewsNetworking()
//    let provider = RxMoyaProvider<NewsTarget>(plugins: [
//        NetworkActivityPlugin(networkActivityClosure: NewsNetworking.networkActivity)
//    ])
//
//    static func networkActivity(change: NetworkActivityChangeType) {
//        switch change {
//        case .Began:
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        case .Ended:
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//        }
//    }
//
//    static let defaultPageSize = 10
//
//    var postsCount: Int? = nil
//    var categoriesCount: Int? = nil
//
//    func postsObservable(
//        offset offset: Int,
//        size: Int = NewsNetworking.defaultPageSize
//    ) -> PostsObservable {
//        return Observable.create { (observable) -> Disposable in
//            var networkDisposable: Disposable?
//            do {
//                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
//                let objects = realm.objects(NewsPost)
//                if objects.count != 0 && offset == 0 {
//                    observable.onNext(objects)
//                }
//                networkDisposable = self.postsNetworkingObservable(offset, size: size)
//                    .subscribe { (event) in
//                        switch event {
//                        case .Next(let meta):
//                            self.postsCount = meta.count
//                            observable.onNext(objects)
//                        case .Error(let error):
//                            observable.onError(error)
//                        case .Completed:
//                            observable.onCompleted()
//                        }
//                    }
//            } catch {
//                observable.onError(error)
//            }
//            return AnonymousDisposable {
//                networkDisposable?.dispose()
//            }
//        }
//    }
//
//    func allCategoriesObservable() -> CategoriesObservable {
//        return Observable.create { (observable) -> Disposable in
//            var networkDisposable: Disposable?
//
//            func recursivelyRequesting(requestedCount: Int) {
//                networkDisposable = self.categoriesObservable(offset: requestedCount)
//                    .subscribe { (event) in
//                        switch event {
//                        case .Next(let categories):
//                            if categories.count < self.categoriesCount {
//                                recursivelyRequesting(categories.count)
//                            } else {
//                                observable.onNext(categories)
//                            }
//                        case .Error(let error):
//                            observable.onError(error)
//                        case .Completed:
//                            observable.onCompleted()
//                        }
//                    }
//            }
//
//            recursivelyRequesting(0)
//
//            return AnonymousDisposable {
//                networkDisposable?.dispose()
//            }
//        }
//    }
//
//    func categoriesObservable(
//        offset offset: Int,
//        size: Int = NewsNetworking.defaultPageSize
//    ) -> CategoriesObservable {
//        return Observable.create { (observable) -> Disposable in
//            var networkDisposable: Disposable?
//            do {
//                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
//                let objects = realm.objects(NewsCategory.self)
//                if objects.count != 0 {
//                    observable.onNext(objects)
//                }
//                networkDisposable = self.categoriesNetworkingObservable(offset, size: size)
//                    .subscribe { event in
//                        switch event {
//                        case .Next(let meta):
//                            self.categoriesCount = meta.count
//                            observable.onNext(objects)
//                        case .Error(let error):
//                            observable.onError(error)
//                        case .Completed:
//                            observable.onCompleted()
//                        }
//                    }
//            } catch {
//                observable.onError(error)
//            }
//            return AnonymousDisposable {
//                networkDisposable?.dispose()
//            }
//        }
//    }
//
//}
//
//extension NewsNetworking {
//    private func postsNetworkingObservable(offset: Int, size: Int) -> Observable<NewsPost.Meta> {
//        return provider.request(.Posts(offset, size))
//            .mapObject(NewsPost.Meta.self)
//            .observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
//            .map { meta -> NewsPost.Meta in
//                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
//                let posts = meta.posts.map { post -> NewsPost in
//                    // Replace id only category with full data cached category list
//                    post.categories = List(post.categories.map { category -> NewsCategory? in
//                        return realm.objects(NewsCategory.self)
//                            .filter("id == %@", category.id)
//                            .first
//                    }.flatMap { (optionalCategory) -> [NewsCategory] in
//                        switch optionalCategory {
//                        case .Some(let value):
//                            return [value]
//                        case .None:
//                            return []
//                        }
//                    })
//                    return post
//                }
//                try realm.write {
//                    realm.add(posts, update: true)
//                }
//                return meta
//            }
//            .observeOn(MainScheduler.instance)
//    }
//
//    private func categoriesNetworkingObservable(
//        offset: Int,
//        size: Int
//    ) -> Observable<NewsCategory.Meta> {
//        return provider.request(.Categories(offset, size))
//            .mapObject(NewsCategory.Meta.self)
//            .observeOn(SerialDispatchQueueScheduler(globalConcurrentQueueQOS: .Background))
//            .map { meta -> NewsCategory.Meta in
//                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
//                try realm.write {
//                    realm.add(meta.categories, update: true)
//                }
//                return meta
//            }
//            .observeOn(MainScheduler.instance)
//    }
//}
