//
//  DebtService.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class DebtService {
    private let ref = Database.database().reference()
    
    func addDebt(with values: [String:Any]) {
        ref
            .child("debts")
            .childByAutoId()
            .setValue(values)
    }
    
    func getAllDebt(by trip_id: String,_ completion: @escaping ([DebtModel]) -> Void) {
        ref
            .child("debts")
            .queryOrdered(byChild: "trip_id")
            .queryEqual(toValue: trip_id)
            .observe(.value) { snapshot in
                let debts = Mapper<DebtModel>().mapArray(snapshot: snapshot)
                completion(debts)
        }
    }
}
