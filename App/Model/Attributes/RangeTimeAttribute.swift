//
//  RangeTimeAttribute.swift
//  App
//
//  Created by developer on 29.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class RangeTimeAttribute: Attribute {
    var secondKey: String
    var secondPlaceholder: String
    
    init(name: String, key: String, secondKey: String, placeholder: String, secondPlaceholder: String, value: AnyObject?) {
        self.secondKey = secondKey
        self.secondPlaceholder = secondPlaceholder
        super.init(name: name, key: key, placeholder: placeholder, value: value)
    }
    
    override func isValid() -> Bool {
        self.valid = false
        if let val = value as? RangeTime, start = val.start, end = val.end {
            if start.compare(end) == NSComparisonResult.OrderedAscending {
                self.valid = true
            }
        }
        return self.valid
    }
    
    override var type: CellType {
        return CellType.RangeTime
    }
    
    override func dictionary() -> [String : AnyObject?] {
        let rangeTime = value as? RangeTime
        return [key : rangeTime?.start, secondKey : rangeTime?.end]
    }
}
