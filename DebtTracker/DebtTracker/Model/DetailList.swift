//
//  Transaction.swift
//  DebtTracker
//
//  Created by Rico Chao on 2019-12-11.
//  Copyright © 2019 Rico Chao. All rights reserved.
//

import Foundation

public class DetailList: NSObject, NSCoding {
    
    public var detailList: [Detail] = []
    
    enum Key:String {
        case detailList = "detailList"
    }
    
    init(details: [Detail]) {
        self.detailList = detailList
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(detailList, forKey: Key.detailList.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mDetailList = aDecoder.decodeObject(forKey: Key.detailList.rawValue) as! [Detail]
        
        self.init(detailList: mDetailList)
    }

}
