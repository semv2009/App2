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
    func getObject(indexPath: NSIndexPath) -> T {
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].objects[indexPath.row]
    }
    
    func getNameSection(indexPath: NSIndexPath) -> String? {
        guard let sections = self.sections else { fatalError("Don't get sessions from fetchedResultsController") }
        return sections[indexPath.section].name
    }
    
    
    func checkSort(indexPath: NSIndexPath) -> Bool {
        if let  sections = self.sections {
            for object in sections[indexPath.section].objects {
                if let person = object as? Person {
                    if person.order != -1 {
                        return true
                    }
                }
            }
        }
        return false
    }
}
