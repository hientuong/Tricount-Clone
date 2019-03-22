//
//  TripTabbarController.swift
//  Tricount Clone
//
//  Created by Hien Tuong on 3/21/19.
//  Copyright © 2019 Hien Tuong. All rights reserved.
//

import UIKit

class TripTabbarController: UITabBarController {

    var trip: TripModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let expenseVc = self.viewControllers?.first as! ExpensesViewController
        expenseVc.trip = trip
    
        let balanceVc = self.viewControllers?.last as! BalancesViewController
        balanceVc.trip = trip
    }
}
