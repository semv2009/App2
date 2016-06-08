//
//  Leadership.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Leadership: Person {
    @NSManaged var beginBusinessHours: NSDate?
    @NSManaged var endBusinessHours: NSDate?
    
    // MARK: - CoreDataModelable
    override class var entityName: String {
        return "Leadership"
    }
    
    override func getListAttributes() -> [Attribute] {
        var attributes = super.getListAttributes()
        attributes.append(Attribute(
            name: "business hours",
            type: .RangeTime,
            keys: [Key(name: "beginBusinessHours", value: beginBusinessHours),
                   Key(name: "endBusinessHours", value: endBusinessHours)])
        )
        return attributes
    }
}
