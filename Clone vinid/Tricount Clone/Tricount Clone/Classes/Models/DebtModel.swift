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
    var uid: String?
    var amount: Double?
    var count: Int?
    var paid_id: String?
    
    func mapping(map: Map) {
        id <- map[DebtModel.firebaseIdKey]
        uid <- map["uid"]
        amount <- map["amount"]
        count <- map["count"]
        paid_id <- map["paid_id"]
    }
    
    required init?(map: Map) {
        
    }
}
