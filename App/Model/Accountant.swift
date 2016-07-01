//
//  Accountant.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class Accountant: Employee {
    @NSManaged var type: NSNumber?
    
    // MARK: - CoreDataModelable
    override class var entityName: String {
        return "Accountant"
    }
    
    override func attributes() -> AttributeManager {
        let manager = super.attributes()
        var attributes = [Attribute]()
        attributes.append(AccountantAttribute(
            name: "type",
            key: "type",
            placeholder: "Manager",
            value: type)
        )
        manager.sections.append(attributes)
        return manager
    }
}

struct AccountantData {
    let name: String
    let index: Int
}

struct AccountantTypes {
    static let Financial = AccountantData(name: "Financial", index: 0)
    static let Management = AccountantData(name: "Management", index: 1)
    static let Project = AccountantData(name: "Project", index: 2)
    
    static func accountantType(forIndex index: Int) -> AccountantData {
        switch index {
        case 0: return Financial
        case 1: return Management
        case 2: return Project
        default: return Financial
        }
    }
    
    static let allAccountants: [AccountantData] = [Financial, Management, Project]
}
