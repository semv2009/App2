//
//  StringAttribute.swift
//  App
//
//  Created by developer on 29.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class StringAttribute: Attribute {
    
    override func isValid() -> Bool {
        self.valid = false
        if let _ = value as? String {
            self.valid =  true
        }
        return self.valid
    }
    
    override var type: CellType {
        return CellType.String
    }
}
