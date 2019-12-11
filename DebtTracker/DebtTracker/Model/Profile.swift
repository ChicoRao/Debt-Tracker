//
//  Profile.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-11.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import Foundation

class Profile {
    
    var name: String
    
    var totalAmount: Int
    
    //var transactionArr: [Transaction]
    
    init() {
        name = ""
        totalAmount = 0
    }
    
    init(name: String, totalAmt: Int) {
        self.name = name
        self.totalAmount = totalAmt
    }
    
    func getName() -> String {
        return name
    }
    
    func getTotalAmt() -> Int {
        return totalAmount
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setTotalAmt(totalAmt: Int) {
        self.totalAmount = totalAmt
    }
    
    //func gettotalAmt
}
