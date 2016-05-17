//
//  FellowWorker.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class FellowWorker: Employee {

    // MARK: - CoreDataModelable
    override class var entityName: String {
        return "FellowWorker"
    }
}
