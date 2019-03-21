//
//  TripModel.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class TripModel: Mappable {
    var id: String?
    var uid: String?
    var name: String?
    var desc: String?
    var currency: String?
    
    func mapping(map: Map) {
        id <- map[TripModel.firebaseIdKey]
        uid <- map["uid"]
        name <- map["name"]
        desc <- map["desc"]
        currency <- map["currency"]
    }
    
    required init?(map: Map) {
        
    }
}
