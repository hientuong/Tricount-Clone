//
//  AddNewTripViewController.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit
import Firebase

class AddNewTripViewController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descTF: UITextField!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var ref: DatabaseReference!
    
    var members = [MemberModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    // MARK: - UI
    override func setupUI() {
        let saveItemButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.rightBarButtonItem = saveItemButton
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.title = "New Trip"
        
        titleTF.addTarget(self, action: #selector(titleTFDidChange), for: .editingChanged)
    }
    
    // MARK: - IBAction
    @IBAction func addMember(_ sender: Any) {
        guard let name = nameTF.text else { return }
        let model = MemberModel(name: name)
        members.append(model)
        tableView.reloadData()
        nameTF.text = ""
    }
    
    @objc private func save(){
        createNewTrip {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func titleTFDidChange(){
        navigationItem.rightBarButtonItem?.isEnabled = !(titleTF.text!.isEmpty)
    }
    
    // MARK: - Firebase DB
    private func createNewTrip(_ completion: @escaping () -> Void){
        guard
            let title = titleTF.text,
            let desc = descTF.text,
            let uid = Auth.auth().currentUser?.uid
            else { return }
        
        let values = [
            "uid": uid,
            "name" : title,
            "desc": desc,
            "participants": [],
            "currency": "VND"
            ] as [String : Any]
        
        let tripService = TripService()
        let memberService = MemberService()

        tripService.createNewTrip(with: values) { [weak self] ref in
            let key = ref.key
            for member in self!.members {
                memberService.addMember(with: member.name!, to: key!)
            }
            completion()
        }
    }
}

extension AddNewTripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MemberTableCell.self)
        cell.nameLB.text = members[indexPath.row].name
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteMember(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc private func deleteMember(sender: UIButton){
        members.remove(at: sender.tag)
        tableView.reloadData()
    }
}

