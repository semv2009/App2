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
                attributeType = property.1.valueForKey("attributeType") as? Int {
          
                if let order = Int(attributeOrder), var type = TypeAttribute(rawValue: attributeType) {
                    if let typeString =  userInfo?.valueForKey("extensionType") as? String, typeInt = Int(typeString) {
                        type = TypeAttribute(rawValue: typeInt)!
                    }
                    attributes.append(AttributeInfo(name: attributeName, order: order, description: attributeDescription, type: type))
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
    
    func isEmptyValue(name: String, typeAttribute: TypeAttribute) -> Bool {
        if let value = self.valueForKey(name) {
            if TypeAttribute.String ==  typeAttribute {
                return isEmptyStringValue(value)
            }
            return false
        }
        return true
    }
    
    func isEmptyStringValue(value: AnyObject) -> Bool {
        if let value = value as? String {
            if value.characters.count > 0 {
                return false
            }
        }
        return true
    }
}
