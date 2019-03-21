//
//  BalancesViewController.swift
//  Tricount
//
//  Created by Hien Tuong on 3/19/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit

class BalancesViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var trip: TripModel?
    private var debts = [DebtModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        tableView.tableFooterView = UIView()
    }
    
    override func setupData() {
        let service = DebtService()
        
        service.getAllDebt(by: trip!.id!) { [weak self] arr in
            self?.debts = arr
            self?.tableView.reloadData()
        }
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
        cell.amountLB.text = "\(model.amount!)"
        
        let service = MemberService()
        
        service.getMember(by: model.uid!) { member in
            cell.borrowerLB.text = member.name
        }
        
        service.getMember(by: model.paid_id!) { (member) in
            cell.lenderLB.text = member.name
        }
    }
}
