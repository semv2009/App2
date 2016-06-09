//
//  String+toStringForAttributeType.swift
//  App
//
//  Created by developer on 18.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

extension String {
    static func value(attribute: Attribute) -> String {
        switch attribute.type {
        case .String:
            if let value = attribute.keys[0]?.value as? String {
                return value
            }
        case .Number:
            if let value = attribute.keys[0]?.value as? Int {
                return "\(value)"
            }
        case .AccountantType:
            if let value = attribute.keys[0]?.value as? Int, str = TypeAccountants.allAccountants.getElement(value)?.name {
                return str
            }
        case .RangeTime:
            if let startTime = attribute.keys[0]?.value as? NSDate,
                   endTime = attribute.keys[1]?.value as? NSDate {
                return "from \(startTime.getTimeFormat()) to  \(endTime.getTimeFormat())"
            }
        }
        return ""
    }
    
}
