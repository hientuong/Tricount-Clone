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
    
    var trip: TripModel?
    private var members = [MemberModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        navigationItem.title = "New expense"
        let saveItemButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveItemButton
    }
    
    override func setupData() {
        let service = MemberService()
        service.getAllMember(by: trip!.id!) { [weak self] arr in
            self?.members = arr
            self?.tableView.reloadData()
        }
    }
    
    @objc private func save(){
        addNewExpense()
    }
    
    private func addNewExpense(){
        guard
            let name = nameTF.text,
            let amount = amountTF.text,
            let paid_by = paidButton.currentTitle,
            //            let timestamp = dateButton.currentTitle,
            let tripId = trip?.id
            else { return }
        
        let timestamp = Date().timeIntervalSince1970
        
        let service = ExpenseService()
        
        let values = [
            "name" : name,
            "amount": amount,
            "paid_by": "-LaU9XKbWtaHpqKl9uhu",
            "timestamp": timestamp,
            "trip_id" : tripId
            ] as [String:Any]
        
        service.addExpense(with: values) {
            let memberArr = self.members.filter {
                $0.id != "-LaU9XKbWtaHpqKl9uhu"
            }
            
            let debt = Double(amount)!/Double(self.members.count)
            for member in memberArr {
                self.addDebt(for: member, from: member, with: debt)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addDebt(for member: MemberModel, from paid_by: MemberModel,with debt: Double) {
        guard
            let uid = member.id,
            let paid_id = paid_by.id
            else { return }
        
        let values = [
            "uid" : uid,
            "amount": debt,
            "count" : "1",
            "paid_id": "-LaU9XKbWtaHpqKl9uhu"
            ] as [String:Any]
        
        let service = DebtService()
        service.addDebt(with: values)
    }
}

extension AddExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: RelatedTableCell.self)
        setupCell(cell, model: members[indexPath.row])
        return cell
    }
    
    private func setupCell(_ cell: RelatedTableCell, model: MemberModel){
        cell.nameLB.text = model.name
    }
}
