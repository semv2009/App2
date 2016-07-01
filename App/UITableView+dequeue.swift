//
//  UITableView+dequeue.swift
//  App
//
//  Created by developer on 01.07.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit
extension UITableView {
    func dequeueReusable(entityName: String, indexPath: NSIndexPath) -> PersonTableViewCell {
        switch entityName {
        case FellowWorker.entityName:
            if let cell = self.dequeueReusableCellWithIdentifier("FellowWorkerCell", forIndexPath: indexPath) as? FellowWorkerTableViewCell {
                return cell
            }
        case Director.entityName:
            if let cell = self.dequeueReusableCellWithIdentifier("DirectorCell", forIndexPath: indexPath) as? DirectorTableViewCell {
                return cell
            }
        case Accountant.entityName:
            if let cell = self.dequeueReusableCellWithIdentifier("AccountantCell", forIndexPath: indexPath) as? AccountantTableViewCell {
                return cell
            }
        default:
            break
        }
        return PersonTableViewCell()
    }
}
