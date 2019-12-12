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
    
    var transactionArr: [Transaction]
    
    init() {
        name = ""
        totalAmount = 0
        transactionArr = [Transaction]()
    }
    
    init(name: String, totalAmt: Int) {
        self.name = name
        self.totalAmount = totalAmt
        transactionArr = [Transaction]()
    }
    
    func addDetails(amount: Int, detail: String) {
        if transactionArr.count > 0 {
            transactionArr[transactionArr.count-1].setAmt(amount: amount)
            transactionArr[transactionArr.count-1].setDetail(detail: detail)
        }else {
            transactionArr[0].setAmt(amount: amount)
            transactionArr[0].setDetail(detail: detail)
        }
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
