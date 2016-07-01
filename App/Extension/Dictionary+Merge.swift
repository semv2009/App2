//
//  Dictionary+Merge.swift
//  App
//
//  Created by developer on 30.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
extension Dictionary {
    mutating func update(other: Dictionary) {
        for (key, value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
