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

extension FetchedResultsController {
    func getObject(indexPath: NSIndexPath) -> NSManagedObject {
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].objects[indexPath.row]
    }
    
    func getNameSection(indexPath: NSIndexPath) -> String? {
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].name
    }
    
    func changeOrderPersons(moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        var begin: Int
        var end: Int
        if fromIndexPath.row > toIndexPath.row {
            begin = toIndexPath.row
            end = fromIndexPath.row - 1
            for index in begin...end {
                let indexPath = NSIndexPath(forRow: index, inSection: toIndexPath.section)
                if let movePerson = self.getObject(indexPath) as? Person {
                    let order = movePerson.order
                    movePerson.order = order + 1
                }
            }
            
        } else if fromIndexPath.row < toIndexPath.row {
            begin = fromIndexPath.row + 1
            end = toIndexPath.row
            for index in begin...end {
                let indexPath = NSIndexPath(forRow: index, inSection: toIndexPath.section)
                if let movePerson = self.getObject(indexPath) as? Person {
                    let order = movePerson.order
                    movePerson.order = order - 1
                }
            }
            
        }
        
        if let movePerson = self.getObject(fromIndexPath) as? Person {
            movePerson.order = toIndexPath.row + 1
        }
    }
    
    func checkSort(indexPath: NSIndexPath) -> Bool {
        if let  sections = self.sections {
            for object in sections[indexPath.section].objects {
                if let person = object as? Person {
                    if person.order != 0 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func changeSortAfterDelete(fromRowAtIndexPath fromRowAtIndexPath: NSIndexPath, endIndexPath: NSIndexPath) {
        let start = fromRowAtIndexPath.row
        let end = endIndexPath.row
        for index in start...end {
            let indexPath = NSIndexPath(forRow: index, inSection: fromRowAtIndexPath.section)
            if let person = self.getObject(indexPath) as? Person {
                person.order -= 1
            }
        }
    }
    
}
