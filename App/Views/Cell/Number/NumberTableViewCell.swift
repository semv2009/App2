//
//  NumberTableViewCell
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
    
    func updateUI(name: String, value: Int?) -> NumberTableViewCell {
        addToolBar(dataTextField)
        dataTextField.addTarget(self, action: #selector(NumberTableViewCell.editingChanged), forControlEvents: .EditingChanged)
        dataTextField.keyboardType = .NumbersAndPunctuation
        nameLabel.text = name
        
        if let value = value {
            dataTextField.text =  "\(value)"
        } else {
            dataTextField.text =  ""
        }
        return self
    }
    
    func cellSetup(setup: (cell: NumberTableViewCell) -> Void) {
        setup(cell: self)
    }
    
    func editingChanged(textField: UITextField) {
        if let text = textField.text, indexPath = indexPath {
            let number: Int? = Int(text)
            onChange?(value: number, indexPath: indexPath)
        }
    }
}
