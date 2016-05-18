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

struct SimpleData {
    let name: String
    let index: Int
}

struct TypeAccountants {
    static let Financial = SimpleData(name: "Financial", index: 0)
    static let Management = SimpleData(name: "Management", index: 1)
    static let Project = SimpleData(name: "Project", index: 2)
    
    static func getTypeAccountant(index index: Int) -> SimpleData {
        switch index {
        case 0: return Financial
        case 1: return Management
        case 2: return Project
        default: return Financial
        }
    }
    
    static let allAccountants: [SimpleData] = [Financial, Management, Project]
}
