//
//  Mapper+.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import ObjectMapper
import Firebase

extension Mapper {
    func mapArray(snapshot: DataSnapshot) -> [N] {
        return snapshot.children.map { (child) -> N? in
            if let childSnap = child as? DataSnapshot {
                return N(snapshot: childSnap)
            }
            return nil
            //flatMap here is a trick
            //to filter out `nil` values
            }.flatMap { $0 }
    }
}
