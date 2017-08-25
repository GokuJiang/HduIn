//
//  MyViewController.swift
//  HduIn
//
//  Created by Izayoi on 15/9/24.
//  Copyright © 2015年 Redhome. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RealmSwift
//import TZStackView

class MineViewController: BaseViewController {

    // MARK: Properties
    var cards: [MineCard.Card] = []

    let containerView = MineContainerView()

    // MARK: Data Model
    lazy var courseSchedule = MineCourseSchedule()
    let provider = APIProvider<StaffTarget>()
    let teachingProvider = APIProvider<TeachingTarget>()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) -> Void in
            make.size.equalTo(self.view)
            make.center.equalTo(self.view)
        }

        setupCards()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wireRainbow()

        cards.forEach { $0.loadData($0.contentView) }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.contentSize = containerView.stackView.frame.size
    }

    // MARK: - Private Methods

    func setupCards() {
        for item in cards {
            containerView.stackView.removeArrangedSubview(item.view)
            item.view.removeFromSuperview()
        }

        cards = MineCard.getCardsOf(self)

        for item in cards {
            containerView.stackView.addArrangedSubview(item.view)
            item.view.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.bounds.width - CGFloat(2 * MineContainerView.horizonMargin))
            }
        }
    }
    
    override func wireRainbow() {
        super.wireRainbow()
        navigationController?.navigationBar.df_setBackgroundColor(UIColor.clear)
    }
    
    override func navigationBarInColor() -> UIColor {
        return UIColor.clear
    }
}

// MARK: - Data Methods
extension MineViewController {
    func loadTodayCourses(_ cell: UIView) {
        _ = courseSchedule.todayCoursesObservable()
            .subscribe { (event) -> Void in
                switch event {
                case .next(let results):
                    if let tar = cell as? MineTodayCoursesView {
                        tar.setData(results)
                    }
                case .error(let error):
                    log.error("Request course schedules failed with error: \(error)")
                default:
                    break
                }
            }
    }

    func loadSunnySport(_ cell: UIView) {
        _ = provider.request(.runningInfo)
            .mapObject(MineRunning.RunningInfo.self)
            .subscribe({ (event) -> Void in
                switch event {
                case .next(let info):
                    let tar = cell as? MineSunnySportView
                    tar?.setData(info)
                case .error(let error):
                    log.error("Request Running Info failed with error: \(error)")
                default:
                    break
                }
        })
    }

    func loadICCard(_ cell: UIView) {
        _ = provider.request(.cardRemaining)
            .mapObject(MineICCard.Remaining.self)
            .subscribe { (event) -> Void in
                switch event {
                case .next(let remaining):
                    let tar = cell as? MineICCardView
                    tar?.setData(remaining.value)
                case .error(let error):
                    log.error("Request IC Card Remaining failed with error: \(error)")
                default:
                    break
                }
        }
    }

    func loadExamSchedule(_ cell: UIView) {
        _ = teachingProvider.request(.examSchedule)
            .mapArray(MineExam.Schedule.self)
            .subscribe({ (event) -> Void in
                switch event {
                case .next(let schedules):
                    // Thread block
                    let sortedSchedules = schedules.sorted {
                        $0.startTime.isEarlierThanDate(date: $1.startTime)
                    }
                    if let cell = cell as? MineExamScheduleView {
                        cell.setData(sortedSchedules)
                    }
                case .error(let error):
                    log.error("Request ExamSchduule failed with error: \(error)")
                    if let cell = cell as? MineExamScheduleView {
                        cell.setData([])
                    }
                default:
                    break
                }
            })
    }

    func loadScores(_ cell: UIView) {
        _ = teachingProvider.request(.examScore)
            .mapArray(MineExam.ScoreRecord.self)
            .subscribe({ (event) -> Void in
                switch event {
                case .next(let records):
                    if let cell = cell as? MineExamScoreView {
                        cell.setData(records)
                    }
                case .error(let error):
                    log.error("Request ExamScore failed with error: \(error)")
                    if let cell = cell as? MineExamScoreView {
                        cell.setData([])
                    }
                default:
                    break
                }
            })
    }
}

// MARK: - TabViewController
extension MineViewController: TabViewController {
    func setupTabInfo() {
        let title = "在杭电".localized()
        self.title = title

        let mineTabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: "hduingrey")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "hduinblue")?
                .withRenderingMode(.alwaysOriginal)
        )

        
        self.tabBarItem = mineTabBarItem
    }
}

