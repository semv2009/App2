//
//  Employee.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Employee: Person {
    @NSManaged var beginLunchTime: NSDate?
    @NSManaged var endLunchTime: NSDate?
    @NSManaged var workplace: NSNumber?
    
    // MARK: - CoreDataModelable
    override class var entityName: String {
        return "Employee"
    }
    
    override func getListAttributes() -> [Attribute] {
        var attributes = super.getListAttributes()
        attributes.append(Attribute(
            name: "lunch time",
            type: .RangeTime,
            keys: [Key(name: "beginLunchTime", value: beginLunchTime),
                   Key(name: "endLunchTime", value: endLunchTime)])
        )
        attributes.append(Attribute(
            name: "workplace",
            type: .Number,
            keys: [Key(name: "workplace", value: workplace)])
        )
        return attributes
    }
}
