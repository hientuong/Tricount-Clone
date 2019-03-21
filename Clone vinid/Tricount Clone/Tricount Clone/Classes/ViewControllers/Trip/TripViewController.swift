//
//  TripViewController.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit
import Firebase

class TripViewController: ViewController {
    @IBOutlet weak var tableView: UITableView!
    var trips = [TripModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        navigationItem.title = "Tricount Clone"
        tableView.tableFooterView = UIView()
    }
    
    override func setupData() {
        let tripService = TripService()
        let uid = Auth.auth().currentUser!.uid
        tripService.getTrip(by: uid) { [weak self] tripArr in
            self?.trips = tripArr
            self?.tableView.reloadData()
        }
    }
}

extension TripViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: TripTableCell.self)
        let model = trips[indexPath.row]
        setupCell(cell, with: model)
        return cell
    }
    
    private func setupCell(_ cell: TripTableCell,with model: TripModel) {
        cell.nameLB.text = model.name
        cell.descLB.text = model.desc
    }
}

