//
//  AddExpenseViewController.swift
//  Tricount
//
//  Created by Hien Tuong on 3/19/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit

class AddExpenseViewController: ViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        navigationItem.title = "New expense"
    }
    
    override func setupData() {
            let service = ExpenseService()
        service.addExpense(with: <#T##[String : Any]#>) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension AddExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: RelatedTableCell.self)
        
        return cell
    }
}
