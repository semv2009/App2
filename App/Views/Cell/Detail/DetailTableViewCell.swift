//
//  TableViewCell.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    
    func updateUI(attribute: AttributeInfo, person: NSManagedObject) {
        
        nameLabel.text = attribute.description
        
        switch attribute.type {
        case .Date:
            if let value = person.valueForKey(attribute.name) as? NSDate {
                valueLabel.text = value.getTimeFormat()
            } else {
                valueLabel.text = ""
            }
        case .Number:
            if let value = person.valueForKey(attribute.name) as? Int {
                valueLabel.text = "\(value)"
            } else {
                valueLabel.text = ""
            }
        case .String:
            if let value = person.valueForKey(attribute.name) as? String {
                valueLabel.text = value
            } else {
                valueLabel.text = ""
            }
        }
    }
}
