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
    
    func getListAttributes() -> [Attribute] {
        var attributes = [Attribute]()
        attributes.append(Attribute(
            name: "full name",
            type: .String,
            keys: [Key(name: "fullName", value: fullName)])
        )
        attributes.append(Attribute(
            name: "salary",
            type: .Number,
            keys: [Key(name: "salary", value: salary)])
        )
        return attributes
    }
    
    static func createPerson(entity: String, stack: CoreDataStack, attributes: [Attribute]) -> Person? {
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
            person.update(attributes)
        }
        return person
    }
    
    func update(attributes: [Attribute]) {
        for attribute in attributes {
            for key in attribute.keys {
                if let key = key {
                    self.setValue(key.value, forKey: key.name)
                }
            }
        }
    }
    
    static func getListAttributes(entityName: String, stack: CoreDataStack, oldAttribute: [Attribute]? = nil) -> [Attribute] {
        var attributes = [Attribute]()
        switch entityName {
        case Accountant.entityName:
            attributes = Accountant(managedObjectContext: stack.newChildContext()).getListAttributes()
        case Director.entityName:
            attributes = Director(managedObjectContext: stack.newChildContext()).getListAttributes()
        case FellowWorker.entityName:
            attributes = FellowWorker(managedObjectContext: stack.newChildContext()).getListAttributes()
        default:
            break
        }
        if let oldAttribute = oldAttribute {
            copyOldAttributes(attributes, oldAttributes: oldAttribute)
        }
        return attributes
    }
    
    static func copyOldAttributes(newAttributes: [Attribute], oldAttributes: [Attribute]) {
        for newAttribute in newAttributes {
            for oldAttribute in oldAttributes {
                if oldAttribute.name == newAttribute.name {
                    compare(newAttribute, old: oldAttribute)
                }
            }
        }
    }
    
    static func compare(new: Attribute, old: Attribute) {
        for newkey in new.keys {
            for oldKey in old.keys {
                if let newkey = newkey, oldKey = oldKey {
                    if newkey.name == oldKey.name {
                        newkey.value = oldKey.value
                    }
                }
            }
        }
    }
}

class Attribute {
    var name: String
    var type: TypeCell
    var keys: [Key?]
    var valid: Bool
    
    init(name: String, type: TypeCell, keys: [Key?], valid: Bool = true) {
        self.name = name
        self.type = type
        self.keys = keys
        self.valid = valid
    }
    
    func isValid() -> Bool {
        self.valid = false
        switch type {
        case .Number, .String, .AccountantType:
            if let _ = keys[0]?.value {
                self.valid =  true
            }
        case .RangeTime:
            if let startTime = keys[0]?.value as? NSDate, endTime = keys[1]?.value as? NSDate {
                if startTime.compare(endTime) == NSComparisonResult.OrderedAscending {
                    self.valid = true
                }
            }
        }
        return self.valid
    }
}

enum TypeCell: String {
    case String = "StringCell"
    case Number = "NumberCell"
    case RangeTime = "RangeTimeCell"
    case AccountantType = "AccountantTypeCell"
}

class Key {
    var name: String
    var value: AnyObject?
    
    init(name: String, value: AnyObject? = nil) {
        self.name = name
        self.value = value
    }
}
