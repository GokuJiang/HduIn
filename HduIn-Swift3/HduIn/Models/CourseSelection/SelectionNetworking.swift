//
//  SelectionNetworking.swift
//  HduIn
//
//  Created by Lucas Woo on 12/2/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import ObjectMapper

class SelectionNetworking {
    typealias Category = SelectionCourse.Category

    let provider = APIProvider<CourseSelectionTarget>(
        endpointClosure: APIProvider.APIJSONEndpointMapping
    )

    func getStars() -> Observable<Results<SelectionStar>> {
        return Observable.create { (observable) -> Disposable in
            do {
                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                let result = realm.objects(SelectionStar.self)
                observable.onNext(result)
            } catch {
                observable.onError(error)
            }

            let disposable = self.provider.request(.GetStars)
                .mapArray(SelectionStar.self)
                .map { stars -> Results<SelectionStar> in
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    try realm.write {
                        realm.delete(realm.objects(SelectionStar.self))
                        realm.add(stars)
                    }
                    return realm.objects(SelectionStar.self)
                }.subscribe(observable)
            return Disposables.create {
                disposable.dispose()
            }
        }
    }

    func star(_ course: SelectionCourse) -> Observable<()> {
        return Observable.create { observable -> Disposable in
            do {
                if course.categoryType == .some(.PE) {
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    let query = realm.objects(SelectionCourse.self)
                        .filter("category = %@", Category.PE.rawValue)
                    if query.count > 0 {
                        observable.onError(SelectionError.peAlreadyStared)
                    }
                }
            } catch {
                observable.onError(error)
            }

            let disposable = self.provider.request(.CreateStar(course.selectCode))
                .map { response in
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    let star = SelectionStar()
                    star.selectCode = course.selectCode
                    star.category = course.category
                    try realm.write {
                        realm.add(star)
                    }
                }.subscribe(observable)
            return Disposables.create {
                disposable.dispose()
            }


        }
    }

    func unstar(_ course: SelectionCourse) -> Observable<()> {
        return provider.request(.DeleteStar(course.selectCode))
            .map { response -> () in
                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                try realm.write {
                    realm.delete(realm.objects(SelectionStar.self)
                        .filter("selectCode = %@", course.selectCode)
                    )
                }
            }
    }

    func submitStars() -> Observable<[SelectionResult]> {
        return provider.request(.SubmitStar).mapArray(SelectionResult.self)
    }

    func getCourses(_ category: Category) -> Observable<Results<SelectionCourse>> {
        return Observable.create { observable -> Disposable in
            do {
                let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                let result = realm.objects(SelectionCourse.self)
                    .filter("category = '\(category.rawValue)'")
                observable.onNext(result)
            } catch {
                observable.onError(error)
            }

            _ = (category == .Public ?
                self.provider.request(.GetPublics) :
                self.provider.request(.GetPEs))
                .mapArray(SelectionCourse.self)
                .map { courses -> Results<SelectionCourse> in
                    let realm = try Realm(configuration: RealmAgent.getDefaultConfigration())
                    try realm.write {
                        realm.delete(realm.objects(SelectionCourse.self)
                            .filter("category = '\(category.rawValue)'"))
                        realm.add(courses)
                    }
                    return realm.objects(SelectionCourse.self)
                        .filter("category = %@", category.rawValue)
                }.subscribe(observable)
            return Disposables.create{
            }

//            return AnonymousDisposable {
//                disposable.dispose()
//            }
        }
    }

    func selectPublics(_ courses: [SelectionCourse]) -> Observable<SelectionResult> {
        return Observable.create { observable -> Disposable in
            var completedCount = 0
            _ = courses.map {
                self.selectPublic($0).subscribe { event in
                    switch event {
                    case .next(let result):
                        observable.onNext(result)
                    case .error(let error):
                        observable.onError(error)
                    case .completed:
                        completedCount = completedCount + 1
                        if completedCount == courses.count {
                            observable.onCompleted()
                        }
                    }
                }
            }
            return Disposables.create{
            }
//            return AnonymousDisposable({ Void in
//                disposables.forEach { $0.dispose() }
//
//            })

        }
    }

    func selectPE(_ course: SelectionCourse) -> Observable<SelectionResult> {
        return provider.request(.SelectPE(course.selectCode))
            .mapObject(SelectionResult.self)
    }

    func selectPublic(_ course: SelectionCourse) -> Observable<SelectionResult> {
        return provider.request(.SelectPublic(course.selectCode))
            .mapArray(SelectionResult.self)
            .map { $0[0] }
    }
}
