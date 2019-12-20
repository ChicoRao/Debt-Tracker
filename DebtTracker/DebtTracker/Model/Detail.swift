//
//  Detail.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-19.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import Foundation

public class Detail: NSObject, NSCoding {
    
    public var amount: String = ""
    public var occasion: String = ""
    
    enum Key:String {
        case amount = "amount"
        case occasion = "occasion"
    }
    
    init(amount: String, occasion: String) {
        self.amount = amount
        self.occasion = occasion
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(amount, forKey: Key.amount.rawValue)
        aCoder.encode(occasion, forKey: Key.occasion.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mAmount = aDecoder.decodeObject(forKey: Key.amount.rawValue) as! String
        let mOccasion = aDecoder.decodeObject(forKey: Key.occasion.rawValue) as! String
        
        self.init(amount: mAmount, occasion: mOccasion)
    }

}
