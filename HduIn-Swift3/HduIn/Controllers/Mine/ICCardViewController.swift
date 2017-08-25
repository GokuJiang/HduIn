//
//  ICCardViewController.swift
//  HduIn
//
//  Created by Lucas on 10/2/15.
//  Copyright © 2015 Redhome. All rights reserved.
//

import UIKit

class ICCardViewController: BaseViewController {

    let iccardView = ICCardView()

    let provider = APIProvider<StaffTarget>()

    var remainingAmount: Double = 0
    var consumeRecords: [MineICCard.ConsumeRecord] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "一卡通"

        self.iccardView.frame = self.view.frame
        iccardView.delegate = self
        iccardView.dataSource = self
        self.view = self.iccardView

        queryData()
    }

    func queryData() {
        _ = provider.request(.cardRemaining)
            .mapObject(MineICCard.Remaining.self)
            .subscribe({ (event) -> Void in
                switch event {
                case .next(let remaining):
                    self.remainingAmount = remaining.value
                    self.iccardView.reloadData()
                case .error(let error):
                    log.error("Fetch Card Remaining Failed with error: \(error)")
                default:
                    break
                }
        })

        _ = provider.request(.cardConsume)
            .mapArray(MineICCard.ConsumeRecord.self)
            .subscribe({ (event) -> Void in
                switch event {
                case .next(let records):
                    self.consumeRecords = records
                    self.iccardView.reloadData()
                case .error(let error):
                    log.error("Fetch Card Consume Records Failed with error: \(error)")
                default:
                    break
                }
        })
    }

    func popViewController(_ sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - ICCardView Delegate

extension ICCardViewController: ICCardViewDelegate {
    func iccardView(_ iccardView: ICCardView, didSelectLossReporting button: UIButton) {
    }
}

extension ICCardViewController: ICCardViewDataSource {
    func iccardViewRemaining(_ iccardView: ICCardView) -> Double {
        return remainingAmount
    }

    func iccardView(_ iccardView: ICCardView, numberOfItemInTableView tableView: UITableView) -> Int {
        return consumeRecords.count
    }

    func iccardView(
        _ iccardView: ICCardView,
        itemAtIndexPath indexPath: IndexPath
    ) -> MineICCard.ConsumeRecord {
        return consumeRecords[indexPath.item]
    }
}
