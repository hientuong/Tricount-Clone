//
//  BalancesViewController.swift
//  Tricount
//
//  Created by Hien Tuong on 3/19/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit
import PKHUD
import Foundation

class BalancesViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trip: TripModel?
    private var debts = [DebtModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func setupUI() {
        self.parent?.title = trip?.name
        
        tableView.tableFooterView = UIView()
    }
    
    override func setupData() {
        let service = DebtService()
        
        HUD.show(.progress)
        service.getAllDebt(by: trip!.id!) { [weak self] arr in
            HUD.hide()
            guard let `self` = self else { return }
            self.debts = self.calculateData(arr)
            self.tableView.reloadData()
        }
    }
    
    private func calculateData(_ arr: [DebtModel]) -> [DebtModel] {
        var resultArr = [DebtModel]()
        
        let uids = Set<String>(arr.compactMap { $0.uid})
        let paidIds = Set<String>(arr.compactMap { $0.paid_id})
        
        for uid in uids {
            for paidId in paidIds {
                let sum = arr.filter{$0.uid == uid && $0.paid_id == paidId}
                    .map{$0.amount!}
                    .reduce(0, +)
                if sum > 0 {
                    let model = DebtModel(
                        uid: uid,
                        amount: sum,
                        paid_id: paidId)
                    resultArr.append(model)
                }
            }
        }
        
        var finalResult = [DebtModel]()
        
        for result in resultArr {
            let arr = resultArr
                .filter { $0.uid == result.paid_id && $0.paid_id == result.uid }
            
            if let first = arr.first {
                let amount = result.amount! - first.amount!
                let model = DebtModel(
                    uid: result.uid,
                    amount: amount,
                    paid_id: result.paid_id)
                
                finalResult.append(model)
            } else {
                finalResult.append(result)
            }
        }
        return finalResult.filter { $0.amount! > 0 }
    }
}

extension BalancesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: BalancesTableViewCell.self)
        setupCell(cell, model: debts[indexPath.row])
        return cell
    }
    
    private func setupCell(_ cell: BalancesTableViewCell, model: DebtModel){
        cell.amountLB.text = "đ" + String(format: "%g", model.amount!)
        
        let service = MemberService()
        
        service.getMember(by: model.uid!) { member in
            cell.borrowerLB.text = member.name
        }
        
        service.getMember(by: model.paid_id!) { (member) in
            cell.lenderLB.text = member.name
        }
    }
}
