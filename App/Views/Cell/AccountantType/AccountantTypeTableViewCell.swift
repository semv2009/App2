//
//  AccountantTypeTableViewCell
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class AccountantTypeTableViewCell: DataCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dataTextField: UITextField!
    var attribute: Attribute!
    var dataPiсker = UIPickerView()
    var dataArray = [SimpleData]()
    
    override func updateUI(attribute: Attribute) {
        self.attribute = attribute
        addToolBar(dataTextField)
        dataTextField.addTarget(self, action: #selector(AccountantTypeTableViewCell.editingChanged), forControlEvents: .EditingChanged)
        nameLabel.text = attribute.name
        dataArray = TypeAccountants.allAccountants
        dataPiсker.delegate = self
        dataTextField.inputView = dataPiсker
        
        if let value = attribute.keys[0]?.value as? Int {
            dataPiсker.selectRow(value, inComponent: 0, animated: false)
            dataTextField.text = dataArray[value].name
        } else {
            dataTextField.text = ""
            dataPiсker.selectRow(0, inComponent: 0, animated: false)
        }
        valid()
    }
    
    func editingChanged(textField: UITextField) {
        valid()
        self.attribute.keys[0]?.value = nil
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

extension AccountantTypeTableViewCell: UIPickerViewDelegate {
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
        self.attribute.keys[0]?.value = row
        setValidLabel(.Valid, label: nameLabel)
        self.checkAllValid?()
    }
}
