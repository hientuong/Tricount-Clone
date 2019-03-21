//
//  MemberModel.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class MemberModel: Mappable {
    var id: String?
    var name: String?
    var id_trip: String?
    
    init(name: String) {
        self.name = name
    }
    
    func mapping(map: Map) {
        id <- map[MemberModel.firebaseIdKey]
        name <- map["name"]
        id_trip <- map["id_trip"]
    }
    
    required init?(map: Map) {
        
    }
}
