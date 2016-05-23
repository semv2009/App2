//
//  DetailTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//
import UIKit
import BNRCoreDataStack

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func updateUI(attribute: AttributeInfo, value: AnyObject?) {
        nameLabel.text = attribute.description
        valueLabel.text = String.value(forAttribute: attribute.type, value: value)
    }
}
