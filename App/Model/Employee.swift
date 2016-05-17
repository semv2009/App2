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
}
