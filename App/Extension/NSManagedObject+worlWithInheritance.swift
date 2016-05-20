//
//  NSManagedObject+getAttribute.swift
//  App
//
//  Created by developer on 10.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    func getAttributes() -> [AttributeInfo] {
        var attributes = [AttributeInfo]()
        let propertyes = self.entity.attributesByName
        for property in propertyes {
            let attributeName = property.0
            let userInfo = property.1.valueForKey("userInfo")
            if let attributeOrder = userInfo?.valueForKey("order") as? String,
                attributeDescription =  userInfo?.valueForKey("description") as? String,
                attributeType = property.1.valueForKey("attributeType") as? Int,
                attributeOptinal = property.1.valueForKey("isOptional") as? Int {
          
                if let order = Int(attributeOrder), var type = TypeAttribute(rawValue: attributeType) {
                    if let typeString =  userInfo?.valueForKey("extensionType") as? String, typeInt = Int(typeString) {
                        type = TypeAttribute(rawValue: typeInt)!
                    }
                    attributes.append(AttributeInfo(name: attributeName, order: order, description: attributeDescription, type: type, optional: attributeOptinal))
                }
            }
        }
        attributes.sortInPlace({$0.order < $1.order})
        return attributes
    }

    func copyData(person: NSManagedObject) {
        let attributes = self.getAttributes()
        for attribute in attributes {
            if let _ = person.entity.attributesByName[attribute.name], value = person.valueForKey(attribute.name) {
                self.setValue(value, forKey: attribute.name)
            }
        }
    }
    
    func checkOptionAttributes() -> Bool {
        let attributes = self.getAttributes()
        for attribute in attributes {
            if attribute.optional == 0 {
                if valueForKey(attribute.name) == nil {
                    return false
                }
            }
        }
        return true
    }
    
    func isEmptyValue(name: String, typeAttribute: TypeAttribute) -> Bool {
        if let _ = self.valueForKey(name) {
            return false
        }
        return true
    }
}
