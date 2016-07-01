//
//  DataCell.swift
//  App
//
//  Created by developer on 06.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    var onChange: ((value: AnyObject?, indexPath: NSIndexPath) -> Void)?
    var indexPath: NSIndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func onChange(onChange change: ((value: AnyObject?, indexPath: NSIndexPath) -> Void)?) {
        self.onChange = change
    }
    
    func updateUI(attribute: Attribute) -> DataCell {
        switch attribute.type {
        case .String:
            if let cell = self as? StringTableViewCell, attribute = attribute as? StringAttribute {
                let value = attribute.value as? String
                cell.updateUI(attribute.name, value: value)
                    .cellSetup { cell in
                        cell.dataTextField.placeholder = attribute.placeholder
                    }
            }
        case .Number:
            if let cell = self as? NumberTableViewCell, attribute = attribute as? NumberAttribute {
                let value = attribute.value as? Int
                cell.updateUI(attribute.name, value: value)
                    .cellSetup { cell in
                        cell.dataTextField.placeholder = attribute.placeholder
                    }
            }
        case .RangeTime:
            if let cell = self as? RangeTimeTableViewCell, attribute = attribute as? RangeTimeAttribute {
                let value = attribute.value as? RangeTime
                cell.updateUI(attribute.name, rangeTime: value)
                    .cellSetup { cell in
                        cell.startTime.placeholder = attribute.placeholder
                        cell.endTime.placeholder = attribute.secondPlaceholder
                }
            }
        case .AccountantType:
            if let cell = self as? AccountantTypeTableViewCell, attribute = attribute as? AccountantAttribute {
                let value = attribute.value as? Int
                cell.updateUI(attribute.name, value: value)
                    .cellSetup { cell in
                        cell.dataTextField.placeholder = attribute.placeholder
                    }
            }
        }
        return self
    }

}

extension DataCell: UITextFieldDelegate {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 90/255, green: 100/255, blue: 217/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DataCell.donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        self.contentView.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.contentView.endEditing(true)
        return true
    }
}
