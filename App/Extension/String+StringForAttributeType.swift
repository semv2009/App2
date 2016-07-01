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
            if let value = attribute.value as? String {
                return value
            }
        case .Number:
            if let value = attribute.value as? Int {
                return "\(value)"
            }
        case .AccountantType:
            if let value = attribute.value as? Int, str = AccountantTypes.allAccountants.getElement(value)?.name {
                return str
            }
        case .RangeTime:
            if let value = attribute.value as? RangeTime, startTime = value.start, endTime = value.end {
            return "from \(startTime.getTimeFormat()) to  \(endTime.getTimeFormat())"
            }
        }
        return ""
    }
}
