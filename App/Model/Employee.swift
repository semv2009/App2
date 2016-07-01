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

    override func attributes() -> AttributeManager {
        let manager = super.attributes()
        var attributes = [Attribute]()
        attributes.append(RangeTimeAttribute(
            name: "lunch time",
            key: "beginLunchTime",
            secondKey: "endLunchTime",
            placeholder: "12:00",
            secondPlaceholder: "13:00",
            value: RangeTime(start: beginLunchTime, end: endLunchTime))
        )
        attributes.append(NumberAttribute(
            name: "workplace",
            key: "workplace",
            placeholder: "42",
            value: workplace)
        )
        manager.sections.append(attributes)
        return manager
    }
}
