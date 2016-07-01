//
//  AttributeManager.swift
//  App
//
//  Created by developer on 30.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
class AttributeManager {
    var sections = [[Attribute]]()
    
    func attribute(forIndexPath indexPath: NSIndexPath) -> Attribute {
        return sections[indexPath.section][indexPath.row]
    }
    
    func setValue(forIndexPath indexPath: NSIndexPath, value: AnyObject?) {
        sections[indexPath.section][indexPath.row].value = value
    }
    
    func update(manager: AttributeManager) {
        for section in sections {
            for attribute in section {
                if let value =  manager.value(forName: attribute.name) {
                     attribute.value = value
                }
            }
        }
    }
    
    func value(forName name: String) -> AnyObject? {
        for section in sections {
            for attribute in section {
                if attribute.name == name {
                    return attribute.value
                }
            }
        }
        return nil
    }
    
    func isValid() -> Bool {
        for section in sections {
            for attribute in section {
                if !attribute.isValid() {
                    return false
                }
            }
        }
        return true
    }
    
    func dictionary() -> [String : AnyObject?] {
        var dictionary = [String : AnyObject?]()
        for section in sections {
            for attribute in section {
                dictionary.update(attribute.dictionary())
            }
        }
        return dictionary
    }
}
