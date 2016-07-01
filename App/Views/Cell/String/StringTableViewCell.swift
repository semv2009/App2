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
    
    func updateUI(name: String, value: String?) -> StringTableViewCell {
        addToolBar(dataTextField)
        dataTextField.addTarget(self, action: #selector(StringTableViewCell.editingChanged), forControlEvents: .EditingChanged)
        nameLabel.text = name
        dataTextField.text = value
        return self
    }

    func cellSetup(setup: (cell: StringTableViewCell) -> Void) {
        setup(cell: self)
    }
    
    func editingChanged(textField: UITextField) {
        if let indexPath = indexPath {
            self.onChange?(value: textField.text, indexPath: indexPath)
        }
    }
}
