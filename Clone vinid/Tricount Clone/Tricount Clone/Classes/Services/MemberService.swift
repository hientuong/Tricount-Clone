//
//  MemberService.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class MemberService {
    private let ref = Database.database().reference()
    
    func addMember(with name: String, to trip_id: String ) {
        let values = [
            "name" : name,
            "trip_id": trip_id
            ] as [String:Any]
        
        ref
            .child("members")
            .childByAutoId()
            .setValue(values)
    }
    
    func getAllMember(by trip_id: String,_ completion: @escaping ([MemberModel]) -> Void){
        ref
            .child("members")
            .queryOrdered(byChild: "trip_id")
            .queryEqual(toValue: trip_id)
            .observe(.value) { snapshot in
                let arr = Mapper<MemberModel>().mapArray(snapshot: snapshot)
                completion(arr)
        }
    }
    
    func getMember(by key: String,_ completion: @escaping (MemberModel) -> Void){
        ref
            .child("members")
            .child(key)
            .observe(.value) { snapshot in
                let model = MemberModel(snapshot: snapshot)
                completion(model!)
        }
    }
}
