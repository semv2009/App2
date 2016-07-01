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
    var dataPiсker = UIPickerView()
    var dataArray = [AccountantData]()
    
    func updateUI(name: String, value: Int?) -> AccountantTypeTableViewCell {
        addToolBar(dataTextField)
        dataTextField.addTarget(self, action: #selector(AccountantTypeTableViewCell.editingChanged), forControlEvents: .EditingChanged)
        nameLabel.text = name
        dataArray = AccountantTypes.allAccountants
        dataPiсker.delegate = self
        dataTextField.inputView = dataPiсker
        
        if let value = value {
            dataPiсker.selectRow(value, inComponent: 0, animated: false)
            dataTextField.text = dataArray[value].name
        } else {
            dataTextField.text = ""
            dataPiсker.selectRow(0, inComponent: 0, animated: false)
        }
        return self
    }
    
    func cellSetup(setup: (cell: AccountantTypeTableViewCell) -> Void) {
        setup(cell: self)
    }
    
    func editingChanged(textField: UITextField) {
        if let indexPath = indexPath {
            onChange?(value: nil, indexPath: indexPath)
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
        if let indexPath = indexPath {
            onChange?(value: row, indexPath: indexPath)
        }
    }
}
