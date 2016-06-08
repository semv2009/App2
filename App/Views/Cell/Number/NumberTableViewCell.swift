//
//  DataTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class NumberTableViewCell: DataCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    var attribute: Attribute!
    
    override func updateUI(attribute: Attribute) {
        self.attribute = attribute
        addToolBar(dataTextField)
        dataTextField.addTarget(self, action: #selector(NumberTableViewCell.editingChanged), forControlEvents: .EditingChanged)
        nameLabel.text = attribute.name
        if let data = attribute.keys[0]?.value as? Int {
            dataTextField.text = "\(data)"
        } else {
            dataTextField.text = ""
        }
        valid()
    }
    
    func editingChanged(textField: UITextField) {
        let number: Int? = Int(textField.text!)
        self.attribute.keys[0]?.value = number
        valid()
        self.checkAllValid?()
    }
    
    func valid() {
        if dataTextField.text?.characters.count > 0 {
            if attribute.isValid() {
                setValidLabel(.Valid, label: nameLabel)
            } else {
                setValidLabel(.NotValid, label: nameLabel)
            }
        } else {
            setValidLabel(.Blank, label: nameLabel)
        }
    }
}
