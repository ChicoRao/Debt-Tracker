//
//  Transaction.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-11.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import Foundation

class Transaction {
    
    var amount: Int
    
    var detail: String
    
    init() {
        amount = 0
        detail = ""
    }
    
    init(amount: Int, detail: String) {
        self.amount = amount
        self.detail = detail
    }
        
}
