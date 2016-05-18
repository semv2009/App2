//
//  String+toStringForAttributeType.swift
//  App
//
//  Created by developer on 18.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation

extension String {
    static func value(forAttribute type: TypeAttribute, value: AnyObject?) -> String {
        switch type {
        case .Date:
            if let value = value as? NSDate {
                return value.getDayFormat()
            }
        case .Number:
            if let value = value as? Int {
                return "\(value)"
            }
        case .String:
            if let value = value as? String {
                return value
            }
        case .Time:
            if let value = value as? NSDate {
                return value.getTimeFormat()
            }
        case .TypeAccountan:
            if let value = value as? Int {
                return TypeAccountants.getTypeAccountant(index: value).name
            }
        }
        return ""
    }
}
