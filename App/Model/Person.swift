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
    @NSManaged var salary: NSNumber?
    @NSManaged var order: NSNumber?
    @NSManaged var sectionOrder: Int
    
    // MARK: - CoreDataModelable
    class var entityName: String {
        return "Person"
    }
    
    var entitySort: Int {
        get {
            guard let sortStr = entity.valueForKey("userInfo")!.valueForKey("sort") as? String, sort = Int(sortStr) else { fatalError() }
            return sort
        }
        set {
            entity.userInfo?["sort"] = "\(newValue)"
        }
    }
    
    static func createPerson(entity: String, stack: CoreDataStack, manager: AttributeManager) -> Person? {
        var person: Person?
        switch entity {
        case Accountant.entityName:
            person = Accountant(managedObjectContext: stack.mainQueueContext)
        case Director.entityName:
            person = Director(managedObjectContext: stack.mainQueueContext)
        case FellowWorker.entityName:
            person = FellowWorker(managedObjectContext: stack.mainQueueContext)
        default:
            break
        }
        
        if let person = person {
            person.update(manager.dictionary())
        }
        return person
    }
    
    func update(values: [String : AnyObject?]) {
        for (key, value) in values {
            self.setValue(value, forKey: key)
        }
    }
    
    static func attributes(entityName: String, stack: CoreDataStack, oldManger: AttributeManager? = nil) -> AttributeManager {
        var manager: AttributeManager = AttributeManager()
        switch entityName {
        case Accountant.entityName:
            manager = Accountant(managedObjectContext: stack.newChildContext()).attributes()
        case Director.entityName:
            manager = Director(managedObjectContext: stack.newChildContext()).attributes()
        case FellowWorker.entityName:
            manager = FellowWorker(managedObjectContext: stack.newChildContext()).attributes()
        default:
            break
        }
        if let oldManger = oldManger {
            manager.update(oldManger)
        }
        return manager
    }

    func attributes() -> AttributeManager {
        var attributes = [Attribute]()
        attributes.append(StringAttribute(
            name: "full name",
            key: "fullName",
            placeholder: "John Snow",
            value: fullName)
        )
        attributes.append(NumberAttribute(
            name: "salary",
            key: "salary",
            placeholder: "35000",
            value: salary)
        )
        let manager = AttributeManager()
        manager.sections.append(attributes)
        return manager
    }
}

enum CellType: String {
    case String = "StringCell"
    case Number = "NumberCell"
    case RangeTime = "RangeTimeCell"
    case AccountantType = "AccountantTypeCell"
}
