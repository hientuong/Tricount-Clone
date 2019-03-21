//
//  ExpenseService.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class ExpenseService {
    func getExpense(with trip_id: String,_ completion: @escaping ([ExpenseModel]) -> Void) {
        Database.database().reference()
            .child("expenses")
            .queryOrdered(byChild: "trip_id")
            .queryEqual(toValue: trip_id)
            .observe(.value) { snapshot in
                let arr = Mapper<ExpenseModel>().mapArray(snapshot: snapshot)
                completion(arr)
        }
    }
    
    func addExpense(with values: [String:Any], _ completion: @escaping () -> Void) {
        Database.database().reference()
            .child("expenses")
            .childByAutoId()
            .setValue(values) { (err, ref) in
                if let err = err {
                    print("data could not be saved: \(err)")
                }
                completion()
        }
    }
}
