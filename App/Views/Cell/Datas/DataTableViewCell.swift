//
//  DataTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    
    var attribute: AttributeInfo!
    var person: NSManagedObject!
    //var switchSaveButtonDelegate: SwitchSaveButtonDelegate?
    
    lazy var datePiсker = UIDatePicker()
    var dataPiсker = UIPickerView()
    var dataArray = [SimpleData]()
    
    
    func updateUI(attribute: AttributeInfo, person: NSManagedObject) {
        //self.switchSaveButtonDelegate = delegate
        let value = person.valueForKey(attribute.name)
        self.attribute = attribute
        self.person = person
        nameLabel.text = attribute.description
        configureTextField(attribute.type, value: value)
    }
    
    func configureTextField(type: TypeAttribute, value: AnyObject?) {
        addToolBar(dataTextField)
        //dataTextField.text = String.value(forAttribute: attribute.type, value: value)
        switch type {
        case .Date:
            datePiсker.datePickerMode = .Date
            dataTextField.inputView = datePiсker
            if let value = value as? NSDate {
                datePiсker.date = value
            }
            datePiсker.addTarget(self, action: #selector(DataTableViewCell.datePickerChanged(_:)), forControlEvents: .ValueChanged)
            
        case .Number:
            dataTextField.inputView = nil
            dataTextField.keyboardType = .NumbersAndPunctuation
            
        case .String:
            dataTextField.inputView = nil
            
        case .TypeAccountan:
            dataArray = TypeAccountants.allAccountants
            dataPiсker.delegate = self
            dataTextField.inputView = dataPiсker
            if let value = value as? Int {
                dataPiсker.selectRow(value, inComponent: 0, animated: false)
            }
            
        case .Time:
            datePiсker.datePickerMode = .Time
            dataTextField.inputView = datePiсker
            if let value = value as? NSDate {
                datePiсker.date = value
            }
            datePiсker.addTarget(self, action: #selector(DataTableViewCell.datePickerChanged(_:)), forControlEvents: .ValueChanged)
        }

    }
    

    func datePickerChanged(sender: UIDatePicker) {
        dataTextField.text = datePiсker.date.getTimeFormat()
    }
    
    var value: AnyObject? {
        if let text = dataTextField.text {
            if text.characters.count == 0 {
                return nil
            }
        }
        
        switch attribute.type {
        case .Date, .Time:
            return datePiсker.date
        case .Number:
            if let text = dataTextField.text {
                return Int(text)
            }
        case .String:
            return dataTextField.text
        case .TypeAccountan:
            return dataPiсker.selectedRowInComponent(0)
        }
        
        return nil
    }
}

extension DataTableViewCell: UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataArray[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dataTextField.text = dataArray[row].name
    }
}

extension DataTableViewCell: UITextFieldDelegate {
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        person.setValue(value, forKey: attribute.name)
        //switchSaveButtonDelegate?.checkAllAttribute()
    }
}