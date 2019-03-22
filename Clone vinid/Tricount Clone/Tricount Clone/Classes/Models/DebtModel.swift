//
//  DebtModel.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import ObjectMapper

class DebtModel: Mappable {
    var id: String?
    var name: String?
    var uid: String?
    var amount: Double?
    var count: Int?
    var paid_id: String?
    
    func mapping(map: Map) {
        id <- map[DebtModel.firebaseIdKey]
        name <- map["name"]
        uid <- map["uid"]
        amount <- map["amount"]
        count <- map["count"]
        paid_id <- map["paid_id"]
    }
    
    init(name: String?, uid: String?, amount: Double?, count: Int?, paid_id: String?) {
        self.name = name
        self.uid = uid
        self.amount = amount
        self.count = count
        self.paid_id = paid_id
    }
    
    required init?(map: Map) {
        
    }
}
