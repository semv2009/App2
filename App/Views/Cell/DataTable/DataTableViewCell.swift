//
//  TableViewCell.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    

    
    var attribute: AttributeInfo!
    
    var datePiсker = UIDatePicker()
    
    func updateUI(attribute: AttributeInfo, person: NSManagedObject) {

        self.attribute = attribute
        nameLabel.text = attribute.description
        dataTextField.resignFirstResponder()
        switch attribute.type {
        case .Date:
            datePiсker.datePickerMode = .Time
            dataTextField.inputView = datePiсker
            datePiсker.addTarget(self, action: #selector(DataTableViewCell.datePickerChanged(_:)), forControlEvents: .ValueChanged)
            if let value = person.valueForKey(attribute.name) as? NSDate {
                dataTextField.text = value.getTimeFormat()
            } else {
                dataTextField.text = ""
            }
        case .Number:
            dataTextField.inputView = nil
            if let value = person.valueForKey(attribute.name) as? Int {
                dataTextField.text = "\(value)"
            } else {
                dataTextField.text = ""
            }
            dataTextField.keyboardType = .NumbersAndPunctuation
        case .String:
            dataTextField.inputView = nil
            if let value = person.valueForKey(attribute.name) as? String {
                dataTextField.text = value
            } else {
                dataTextField.text = ""
            }
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("HELLO")
        
        return true
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        dataTextField.text = datePiсker.date.getTimeFormat()
    }
    
    var value: AnyObject? {
        switch attribute.type {
        case .Date:
            if let text = dataTextField.text {
                if text.characters.count > 0 {
                    return datePiсker.date
                }
            }
            return nil
        case .Number:
            if let text = dataTextField.text {
                return Int(text)
            } else {
                return nil
            }
        case .String:
            return dataTextField.text
        }
    }
    
    
}
