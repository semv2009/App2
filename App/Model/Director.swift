//
//  Director.swift
//  App
//
//  Created by developer on 10.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Director: Person {

    @NSManaged var beginBusinessHours: NSDate?
    @NSManaged var endBusinessHours: NSDate?
    
    // MARK: - CoreDataModelable
    override class var entityName: String {
        return "Director"
    }
    
    override func attributes() -> AttributeManager {
        let manager = super.attributes()
        var attributes = [Attribute]()
        attributes.append(RangeTimeAttribute(
            name: "business hours",
            key: "beginBusinessHours",
            secondKey: "endBusinessHours",
            placeholder: "15:00",
            secondPlaceholder: "17:00",
            value: RangeTime(start: beginBusinessHours, end: endBusinessHours))
        )
        manager.sections.append(attributes)
        return manager
    }

}
