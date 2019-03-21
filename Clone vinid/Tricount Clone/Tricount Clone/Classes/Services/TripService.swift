//
//  TripService.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase
import RxFirebase
import ObjectMapper

class TripService {
    func getTrip(by uid: String,_ completion: @escaping ([TripModel]) -> Void){
        let ref = Database.database().reference()
            .child("trips")
            .queryOrdered(byChild: "uid")
            .queryEqual(toValue: uid)
        
        var tripArr = [TripModel]()
        ref.observe(.value) { snapshot in
            let trips = Mapper<TripModel>().mapArray(snapshot: snapshot)
            completion(trips)
        }
    }
}
