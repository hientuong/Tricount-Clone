//
//  ExpenseModel.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import ObjectMapper

class ExpenseModel: Mappable {
    var id: String?
    var name: String?
    var amount: String?
    var paid_by: String?
    var trip_id: String?
    var timestamp: Double?
    
    func mapping(map: Map) {
        id <- map[ExpenseModel.firebaseIdKey]
        paid_by <- map["paid_by"]
        name <- map["name"]
        amount <- map["amount"]
        trip_id <- map["trip_id"]
        timestamp <- map["timestamp"]
    }
    
    required init?(map: Map) {
        
    }
}
