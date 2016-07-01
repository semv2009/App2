//
//  Attribute.swift
//  App
//
//  Created by developer on 29.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class Attribute {
    var name: String
    var placeholder: String
    var key: String
    var value: AnyObject?
    var valid: Bool
    
    init(name: String, key: String, placeholder: String, value: AnyObject?, valid: Bool = true) {
        self.name = name
        self.value = value
        self.key = key
        self.placeholder = placeholder
        self.valid = valid
    }
    
    func isValid() -> Bool {
        self.valid = false
        if let _ = value {
            self.valid =  true
        }
        return self.valid
    }
    
    var type: CellType {
        return CellType.String
    }
    
    func dictionary() -> [String : AnyObject?] {
        return [key : value]
    }

}
