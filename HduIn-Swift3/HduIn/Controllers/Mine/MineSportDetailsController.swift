//
//  MineSportDetailsController.swift
//  HduIn
//
//  Created by Lucas Woo on 11/14/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class MineSportDetailsController: BaseViewController {

    let provider = APIProvider<StaffTarget>()

    var info = MineRunning.RunningInfo()
    var records = Array<MineRunning.RunningAchievement>()

    let recordView = MineSportDetailsView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "阳光长跑记录"

        recordView.frame = self.view.frame
        self.view = recordView
        recordView.dataSource = self
        self.queryData()
    }

    func queryData() {
        _ = provider.request(.runningAchievement)
            .mapArray(MineRunning.RunningAchievement.self)
            .subscribe({ (event) -> Void in
                switch event {
                case .next(let achievements):
                    self.records = achievements
                    self.recordView.reloadData()
                case .error(let error):
                    log.error("Request Running Achievements failed with error: \(error)")
                default:
                    break
                }
            })

        _ = provider.request(.runningInfo)
            .mapObject(MineRunning.RunningInfo.self)
            .subscribe({ (event) -> Void in
                switch event {
                case .next(let info):
                    self.info = info
                    self.recordView.reloadData()
                case .error(let error):
                    log.error("Request Running Info failed with error: \(error)")
                default:
                    break
                }
            })
    }

    func popViewController(_ sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MineSportDetailsController: MineSportDetailsViewDataSource {
    func sportDetailsViewTotalCount(_ sportDetailsView: MineSportDetailsView) -> Int {
        return info.times
    }

    func sportDetailsView(
        _ sportDetailsView: MineSportDetailsView,
        itemAtIndexPath indexPath: IndexPath
    ) -> MineRunning.RunningAchievement {
        return records[indexPath.item]
    }

    func sportDetailsView(
        _ sportDetailsView: MineSportDetailsView,
        numberOfItemInTableView tableView: UITableView
    ) -> Int {
        return records.count
    }
}
