//
//  DataCell.swift
//  App
//
//  Created by developer on 06.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class DataCell: UITableViewCell {
    var checkAllValid: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func addTarget(editingChanged editingChanged: (() -> Void)?) {
        self.checkAllValid = editingChanged
    }
    
    func updateUI(attribute: Attribute) {
        switch attribute.type {
        case .String:
            if let cell = self as? StringTableViewCell {
                cell.updateUI(attribute)
            }
        case .Number:
            if let cell = self as? NumberTableViewCell {
                cell.updateUI(attribute)
            }
        case .RangeTime:
            if let cell = self as? RangeTimeTableViewCell {
                cell.updateUI(attribute)
            }
        case .AccountantType:
            if let cell = self as? AccountantTypeTableViewCell {
                cell.updateUI(attribute)
            }
        }
    }
    
    func setValidLabel(valid: StateValid, label: UILabel) {
        switch valid {
        case .Blank:
            label.textColor = UIColor.blackColor()
        case .Valid:
            label.textColor = UIColor.greenColor()
        case .NotValid:
            label.textColor = UIColor.redColor()
        }
    }

}

extension DataCell: UITextFieldDelegate {
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 90/255, green: 100/255, blue: 217/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(DataTableViewCell.donePressed))
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

enum StateValid {
    case Valid
    case NotValid
    case Blank
}
