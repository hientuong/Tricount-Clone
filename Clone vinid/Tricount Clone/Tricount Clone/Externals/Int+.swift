//
//  Int+.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/26/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import Foundation

extension Int {
    func formatToMoney() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = "."
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        return formattedNumber ?? ""
    }
}
