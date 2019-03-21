//
//  MemberService.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import Firebase

class MemberService {
    func addMember(with name: String, to trip_id: String ) {
        let values = [
            "name" : name,
            "trip_id": trip_id
            ] as [String:Any]
        
        Database.database().reference()
            .child("members")
            .childByAutoId()
            .setValue(values)
    }
}
