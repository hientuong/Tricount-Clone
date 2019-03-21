

//
//  BaseMappable.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import ObjectMapper
import Firebase

extension BaseMappable {
    static var firebaseIdKey : String {
        get {
            return "FirebaseIdKey"
        }
    }
    init?(snapshot: DataSnapshot) {
        guard var json = snapshot.value as? [String: Any] else {
            return nil
        }
        json[Self.firebaseIdKey] = snapshot.key as Any
        
        self.init(JSON: json)
    }
}
