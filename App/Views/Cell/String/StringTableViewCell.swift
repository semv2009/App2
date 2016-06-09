//
//  StringTableViewCell
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class StringTableViewCell: DataCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    var attribute: Attribute!
    
    
    override func updateUI(attribute: Attribute) {
        self.attribute = attribute
        addToolBar(dataTextField)
        dataTextField.addTarget(self, action: #selector(StringTableViewCell.editingChanged), forControlEvents: .EditingChanged)
        nameLabel.text = attribute.name
        if let data = attribute.keys[0]?.value as? String {
             dataTextField.text = data
        } else {
            dataTextField.text = ""
        }
        valid()
    }
    
    func editingChanged(textField: UITextField) {
       if let text = textField.text {
            if text.characters.count > 0 {
                self.attribute.keys[0]?.value = textField.text
            } else {
                self.attribute.keys[0]?.value = nil
            }
        }
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
