//
//  FunctionHelpers.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation

let dateFormat = "dd/MM/yyyy"

class FunctionHelpers {
    static func convert(timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let s = formatter.string(from: date)
        return s
    }
    
    static func convert(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        let s = formatter.string(from: date)
        return s
    }
}
