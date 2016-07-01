//
//  AccountantAttribute.swift
//  App
//
//  Created by developer on 30.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class AccountantAttribute: Attribute {
    
    override func isValid() -> Bool {
        self.valid = false
        if let value = value as? Int {
            if case 0...AccountantTypes.allAccountants.count - 1 = value {
                self.valid =  true
            }
        }
        return self.valid
    }
    
    override var type: CellType {
        return CellType.AccountantType
    }
}
