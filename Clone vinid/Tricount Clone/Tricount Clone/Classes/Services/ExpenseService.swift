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
    let ref = Database.database().reference()
    func getExpense(with trip_id: String,_ completion: @escaping ([ExpenseModel]) -> Void) {
        ref
            .child("expenses")
            .queryOrdered(byChild: "trip_id")
            .queryEqual(toValue: trip_id)
            .observe(.value) { snapshot in
                let arr = Mapper<ExpenseModel>().mapArray(snapshot: snapshot)
                completion(arr)
        }
    }
    
    func addExpense(with values: [String:Any], _ completion: @escaping () -> Void) {
        ref
            .child("expenses")
            .childByAutoId()
            .setValue(values) { (err, ref) in
                if let err = err {
                    print("data could not be saved: \(err)")
                    return
                }
                completion()
        }
    }
}
