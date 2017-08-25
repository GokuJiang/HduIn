//
//  MineCard.swift
//  HduIn
//
//  Created by Lucas on 3/13/16.
//  Copyright © 2016 Redhome. All rights reserved.
//

import Foundation

enum MineCard {
    case TodayCourses(MineViewController)
    case SunnySport(MineViewController)
    case ICCard(MineViewController)
    case ExamScore(MineViewController)
    case ExamSchedule(MineViewController)
}

extension MineCard {
    static func getCardsOf(_ controller: MineViewController) -> [Card] {
        var array = [Card]()

        if LeanCloudAgent.getOnlineParam(.ShouldShowCourse) as Bool {
            array.append(TodayCourses(controller).card)
        }
        if LeanCloudAgent.getOnlineParam(.ShouldShowRunning) as Bool {
            array.append(SunnySport(controller).card)
        }
        if LeanCloudAgent.getOnlineParam(.ShouldShowExamResult) as Bool {
            array.append(ExamScore(controller).card)
        }
        if LeanCloudAgent.getOnlineParam(.ShouldShowExamSchedule) as Bool {
            array.append(ExamSchedule(controller).card)
        }

        array.append(ICCard(controller).card)
        return array
    }
}

extension MineCard {
    var card: Card {
        switch self {
        case .TodayCourses(let controller):
            return Card(
                title: "mine_title_today_courses".localized(),
                image: UIImage(named: "Mine-Courses"),
                content: MineTodayCoursesView(),
                action: ("mine_label_whole_week_courses".localized(), {
                    let wholeWeekCourses = MineWholeWeekCoursesController()
                    controller.navigationController?
                        .pushViewController(wholeWeekCourses, animated: true)
                }),
                loadData: controller.loadTodayCourses
            )
        case .SunnySport(let controller):
            return Card(
                title: "mine_title_sunny_sport".localized(),
                image: UIImage(named: "Mine-SunnySport"),
                content: MineSunnySportView(),
                action: ("mine_label_sunny_sport_details".localized(), {
                    let details = MineSportDetailsController()
                    details.showBackActionButton(#selector(MineSportDetailsController.popViewController(_ :)))
                    controller.navigationController?.pushViewController(details, animated: true)
                }),
                loadData: controller.loadSunnySport
            )
        case .ICCard(let controller):
            return Card(
                title: "mine_title_ic_card".localized(),
                image: UIImage(named: "Mine-ICCard"),
                content: MineICCardView(),
                action: ("mine_label_ic_card_details".localized(), {
                    let card = ICCardViewController()
                    controller.navigationController?.pushViewController(card, animated: true)
                }),
                loadData: controller.loadICCard
            )
        case .ExamScore(let controller):
            return Card(
                title: "mine_title_exam_score".localized(),
                image: UIImage(named: "Mine-ExamScore"),
                content: MineExamScoreView(),
                loadData: controller.loadScores
            )
        case .ExamSchedule(let controller):
            return Card(
                title: "mine_title_exam_schedule".localized(),
                image: UIImage(named: "Mine-ExamSchedule"),
                content: MineExamScheduleView(),
                loadData: controller.loadExamSchedule
            )
        }
    }
}

extension MineCard {
    typealias ContentView = MineCardContentView
    typealias Action = () -> ()
    typealias LoadData = (ContentView) -> ()

    struct Card {
        let view: MineCardContainer
        let contentView: ContentView
        let action: (String, Action)?
        let loadData: LoadData

        init(
            title: String,
            image: UIImage?,
            content: ContentView,
            action: (String, Action)? = nil,
            loadData: @escaping LoadData
        ) {
            self.contentView = content
            self.action = action

            self.loadData = loadData

            self.view = MineCardContainer()
            self.view.title = title
            self.view.image = image
            self.view.contentView = self.contentView
            self.view.action = action
        }
    }
}
