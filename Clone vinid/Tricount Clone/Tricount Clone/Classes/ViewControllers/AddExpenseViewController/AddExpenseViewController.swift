//
//  AddExpenseViewController.swift
//  Tricount
//
//  Created by Hien Tuong on 3/19/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit
import DropDown

class AddExpenseViewController: ViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerTF: UITextField!
    
    var trip: TripModel?
    
    private let datePicker = UIDatePicker()
    private let dropDown = DropDown()
    private var members = [MemberModel]()
    private var debts = [DebtModel]()
    private var currentTimestamp: TimeInterval = Date().timeIntervalSince1970
    private var paidBy: MemberModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()
        setupDropDown()
        amountTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - UI & Data
    override func setupUI() {
        navigationItem.title = "New expense"
        let saveItemButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveItemButton
        
        tableView.tableFooterView = UIView()
        datePickerTF.text = FunctionHelpers.convert(date: Date())
    }
    
    override func setupData() {
        let service = MemberService()
        service.getAllMember(by: trip!.id!) { [weak self] arr in
            self?.members = arr
            self?.paidBy = arr.first
            self?.tableView.reloadData()
        }
    }
    
    @objc private func textFieldDidChange() {
        print(amountTF.text!)
    }
    
    @objc private func save(){
        addNewExpense()
    }
    
    @IBAction func showPaidDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    private func setupDropDown(){
        dropDown.anchorView = paidButton
        dropDown.dataSource = ["Car", "Truck", "Train"]
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.paidButton.setTitle(item, for: .normal)
        }
    }
    
    private func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        datePickerTF.inputAccessoryView = toolbar
        datePickerTF.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        datePickerTF.text = formatter.string(from: datePicker.date)
        self.currentTimestamp = datePicker.date.timeIntervalSince1970
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    private func addNewExpense(){
        guard
            let name = nameTF.text,
            let amount = amountTF.text,
            let paid_by = paidBy.id,
            let tripId = trip?.id
            else { return }
        
        let service = ExpenseService()
        
        let values = [
            "name" : name,
            "amount": amount,
            "paid_by": "-LaU9XKbWtaHpqKl9uhu",
            "timestamp": currentTimestamp,
            "trip_id" : tripId
            ] as [String:Any]
        
        service.addExpense(with: values) {
            let memberArr = self.members.filter {
                $0.id != "-LaU9XKbWtaHpqKl9uhu"
            }
            
            let debt = Double(amount)!/Double(self.members.count)
            for member in memberArr {
                self.addDebt(trip: self.trip!,for: member, from: member, with: debt)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addDebt(trip: TripModel, for member: MemberModel, from paid_by: MemberModel,with debt: Double) {
        guard
            let uid = member.id,
            let paid_id = paidBy.id,
            let trip_id = trip.id
            else { return }
        
        let values = [
            "uid" : uid,
            "amount": debt,
            "count" : "1",
            "paid_id": paid_id,
            "trip_id": trip_id,
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
