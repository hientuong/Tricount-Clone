//
//  AddExpenseViewController.swift
//  Tricount
//
//  Created by Hien Tuong on 3/19/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit
import DropDown
import PKHUD

class AddExpenseViewController: ViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var paidButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePickerTF: UITextField!
    
    // MARK: - Properties
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
        amountTF.addTarget(self, action: #selector(tFDidChange(sender:)), for: .editingChanged)
        nameTF.addTarget(self, action: #selector(tFDidChange(sender:)), for: .editingChanged)
    }
    
    // MARK: - UI & Data
    override func setupUI() {
        navigationItem.title = "New expense"
        let saveItemButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveItemButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        tableView.tableFooterView = UIView()
        datePickerTF.text = FunctionHelpers.convert(date: Date())
        amountTF.keyboardType = .numberPad
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
    
    override func setupData() {
        let service = MemberService()
        
        HUD.show(.progress)
        
        service.getAllMember(by: trip!.id!) { [weak self] arr in
            HUD.hide()
            
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
    
    // MARK: - IBACtion
    @IBAction func showPaidDropDown(_ sender: Any) {
        dropDown.show()
    }
    
    // TODO: - Handle amount TF Change
    @objc private func tFDidChange(sender: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = isValid()
        if sender == amountTF { reloadDataWhenAmountChange() }
    }
    
    private func reloadDataWhenAmountChange() {
        let total = Double(amountTF.text!) ?? 0.0
        debts = modifyData(arr: debts, with: total)
        tableView.reloadData()
    }
    
    private func isValid() -> Bool {
        if nameTF.text!.isEmpty || amountTF.text!.isEmpty {
            return false
        }
        return true
    }
    
    private func modifyData(arr: [DebtModel], with total: Double) -> [DebtModel] {
        var count = 0
        for debt in arr {
            count += (debt.count ?? 0)
        }
        
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
    
    // TODO: - DatePicker
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
    
    // MARK: - Firebase Database
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
            for debt in self.debts {
                self.addDebt(trip: self.trip!, from: self.paidBy, with: debt)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addDebt(trip: TripModel, from paid_by: MemberModel,with debt: DebtModel) {
        guard
            let uid = debt.uid,
            let count = debt.count,
            let amount = debt.amount,
            let paid_id = paidBy.id,
            let trip_id = trip.id
            else { return }
        
        let values = [
            "uid" : uid,
            "amount": amount,
            "count" : count,
            "paid_id": paid_id,
            "trip_id": trip_id,
            ] as [String:Any]
        
        let service = DebtService()
        service.addDebt(with: values)
    }
}

extension AddExpenseViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return debts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: RelatedTableCell.self)
        cell.countTF.addTarget(self, action: #selector(countTFDidChange(_:)), for: .editingChanged)
        cell.countTF.tag = indexPath.row
        cell.countTF.keyboardType = .numberPad
        setupCell(cell, model: debts[indexPath.row])
        return cell
    }
    
    // TODO: - Handler countTF change
    @objc private func countTFDidChange(_ sender: UITextField) {
        debts[sender.tag].count = Int(sender.text!)
        reloadDataWhenAmountChange()
    }
    
    // TODO: - setupCell
    private func setupCell(_ cell: RelatedTableCell, model: DebtModel){
        cell.nameLB.text = model.name
        let count = (model.count != nil) ? "\(model.count!)" : ""
        cell.countTF.text = count
        cell.amountLB.text = "đ" + String(format: "%g", model.amount ?? 0.0)//"\(model.amount ?? 0)"
    }
}
