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
}
