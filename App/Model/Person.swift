//
//  Person.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Person: NSManagedObject, CoreDataModelable {
    @NSManaged var fullName: String?
    @NSManaged var salary: Int
    @NSManaged var order: Int
    
    
    
    // MARK: - CoreDataModelable
    class var entityName: String {
        return "Person"
    }
    
    var descriptionName: String {
        guard let description = entity.valueForKey("userInfo")?.valueForKey("description") as? String else { fatalError("Have't description entity") }
        return description
    }
}
