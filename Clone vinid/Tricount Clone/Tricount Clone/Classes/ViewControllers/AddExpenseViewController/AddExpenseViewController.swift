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
        amountTF.addTarget(self, action: #selector(amountTFDidChange), for: .editingChanged)
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
            self?.paidButton.setTitle(arr.first?.name ?? "", for: .normal)
            
            self?.debts = arr.map {
                let debt = DebtModel(name: $0.name, uid: $0.id, amount: 0, count: 1, paid_id: self?.paidBy.id)
                return debt
            }
            
            self?.setupDropDown(with: arr)
            self?.tableView.reloadData()
        }
    }
    
    @objc private func amountTFDidChange() {
        let total = Double(amountTF.text!) ?? 0.0
        debts = modifyData(arr: debts, with: total)
        tableView.reloadData()
    }
    
    private func modifyData(arr: [DebtModel], with total: Double) -> [DebtModel] {
        var count = 0
        for debt in arr {
            count += (debt.count ?? 0)
        }
        
        print("count: \(count)")
        let part = total/Double(count)
        
        for debt in arr {
            if debt.count != nil && debt.count != 0{
                debt.amount = part * Double(debt.count!)
            } else {
                debt.amount = 0
            }
        }
        
        return arr
    }
    
    @objc private func save(){
        addNewExpense()
    }
    
    @IBAction func showPaidDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    private func setupDropDown(with arr: [MemberModel]){
        dropDown.anchorView = paidButton
        let source = arr.map { model -> String in
            return model.name!
        }
        dropDown.dataSource = source
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.paidButton.setTitle(item, for: .normal)
            self?.paidBy = self?.members[index]
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
            "paid_by": paid_by,
            "timestamp": currentTimestamp,
            "trip_id" : tripId
            ] as [String:Any]
        
        service.addExpense(with: values) {
            let memberArr = self.members.filter {
                $0.id != paid_by
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
        return debts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: RelatedTableCell.self)
        cell.countTF.addTarget(self, action: #selector(countTFDidChange(_:)), for: .editingChanged)
        cell.countTF.tag = indexPath.row
        setupCell(cell, model: debts[indexPath.row])
        return cell
    }
    
    @objc private func countTFDidChange(_ sender: UITextField) {
        let total = Double(amountTF.text!) ?? 0.0
        debts[sender.tag].count = Int(sender.text ?? "0") ?? 0
        debts = modifyData(arr: debts, with: total)
        tableView.reloadData()
    }
    
    private func setupCell(_ cell: RelatedTableCell, model: DebtModel){
        cell.nameLB.text = model.name
        cell.countTF.text = "\(model.count ?? 1)"
        cell.amountLB.text = "\(model.amount ?? 0)"
    }
}
