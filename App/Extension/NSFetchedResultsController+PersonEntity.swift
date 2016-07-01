//
//  FetchedResultsController+PersonEntity.swift
//  App
//
//  Created by developer on 11.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

extension NSFetchedResultsController {
    func getObject(indexPath: NSIndexPath) -> Person {
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        if let person = sections[indexPath.section].objects![indexPath.row] as? Person {
            return person
        }
        return Person()
    }
    
    func getNameSection(indexPath: NSIndexPath) -> String? {
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].name
    }
    
    
    func checkSort(indexPath: NSIndexPath) -> Bool {
        if let  sections = self.sections {
            for object in sections[indexPath.section].objects! {
                if let person = object as? Person {
                    if person.order != -1 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func maxOrder(indexPath: NSIndexPath) -> Int {
        var order = -1
        if let  sections = self.sections {
            for object in sections[indexPath.section].objects! {
                if let person = object as? Person {
                    if let value = person.order?.integerValue {
                        order = max(order, value)
                    }
                }
            }
        }
        return order
    }
    
    func printSection() {
        var index = 0
        if let  sections = self.sections {
            for section in sections {
                print("Section index = \(index) name = \(section.name)")
                index += 1
                for object in section.objects! {
                    if let person = object as? Person {
                        print(person)
                    }
                }
            }
            
        }
    }
}
