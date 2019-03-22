//
//  ExpensesViewController.swift
//  Tricount
//
//  Created by Hien Tuong on 3/19/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit
import Firebase
import ObjectMapper
import PKHUD

class ExpensesViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var expenses = [ExpenseModel]()
    var trip: TripModel?
    var sortFlag: Bool = false
    var sortItemButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        self.parent?.title = trip?.name
        
        sortItemButton = UIBarButtonItem(title: "Sort by name", style: .plain, target: self, action: #selector(sort))
        tabBarController?.viewControllers?.first?.navigationItem.rightBarButtonItem = sortItemButton
        
        tableView.tableFooterView = UIView()
    }
    
    override func setupData() {
        let service = ExpenseService()
        HUD.show(.progress)
        service.getExpense(with: trip!.id!, { [weak self] arr in
            guard let `self` = self else { return }
            HUD.hide()
            self.expenses = arr.sorted {
                return $0.timestamp! > $1.timestamp!
            }
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addExpense(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(ofType: AddExpenseViewController.self)
        vc.trip = trip
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func sort(){
        if sortFlag {
            expenses = expenses.sorted { return $0.timestamp! > $1.timestamp! }
        } else {
            expenses = expenses.sorted { return $0.paid_by! > $1.paid_by! }
        }
        sortItemButton.title = sortFlag ? "Sort by name" : "Sort by time"
        sortFlag = !sortFlag
        tableView.reloadData()
    }
}

extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: ExpensesTableViewCell.self)
        let model = expenses[indexPath.row]
        setupCell(cell: cell, model: model)
        return cell
    }
    
    private func setupCell(cell: ExpensesTableViewCell, model: ExpenseModel) {
        cell.nameLB.text = model.name
        cell.amountLB.text = "đ\(model.amount!)"
        cell.dateLB.text = FunctionHelpers.convert(timestamp: model.timestamp!)
        
        let service = MemberService()
        service.getMember(by: model.paid_by!) { member in
            cell.paidLB.text = "paid by \(member.name!)"
        }
    }
}

