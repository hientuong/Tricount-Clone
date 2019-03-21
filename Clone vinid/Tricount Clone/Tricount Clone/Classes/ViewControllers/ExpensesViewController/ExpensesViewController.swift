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

class ExpensesViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var expenses = [ExpenseModel]()
    var trip: TripModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        navigationItem.title = trip?.name
        tableView.tableFooterView = UIView()
    }
    
    override func setupData() {
        let service = ExpenseService()
        service.getExpense(with: trip!.id!, { [weak self] arr in
            guard let `self` = self else { return }
            self.expenses = arr
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addExpense(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(ofType: AddExpenseViewController.self)
        navigationController?.pushViewController(vc, animated: true)
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
        cell.paidLB.text = model.id
        cell.amountLB.text = model.amount
        cell.dateLB.text = model.timestamp
    }
}

