//
//  DataTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import CoreData

class RangeTimeTableViewCell: DataCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    
    var startTimePiсker = UIDatePicker()
    var endTimePiсker = UIDatePicker()
    
    var attribute: Attribute!
    
    override func updateUI(attribute: Attribute) {
        self.attribute = attribute
        addToolBar(startTime)
        addToolBar(endTime)
        configureTimePikers()
        nameLabel.text = attribute.name
        
        if let date = attribute.keys[0]?.value as? NSDate {
            startTimePiсker.date = date
            startTime.text = date.getTimeFormat()
        } else {
            startTimePiсker.date = NSDate()
            startTime.text = ""
        }
        if let date = attribute.keys[1]?.value as? NSDate {
            endTimePiсker.date = date
            endTime.text = date.getTimeFormat()
        } else {
            endTimePiсker.date = NSDate()
            endTime.text = ""
        }
        valid()
    }
    
    func editingChanged(datePiker: UIDatePicker) {
        if datePiker == startTimePiсker {
            self.attribute.keys[0]?.value = datePiker.date
            startTime.text = datePiker.date.getTimeFormat()
        } else {
            self.attribute.keys[1]?.value = datePiker.date
            endTime.text = datePiker.date.getTimeFormat()
        }
        valid()
        self.checkAllValid?()
    }
    
    func editingText(textField: UITextField) {
        if textField == startTime {
            attribute.keys[0]?.value = nil
        } else {
            attribute.keys[1]?.value = nil
        }
        valid()
        self.checkAllValid?()
    }
    
    func valid() {
        if startTime.text?.characters.count > 0 && endTime.text?.characters.count > 0 {
            if attribute.isValid() {
                setValidLabel(.Valid, label: nameLabel)
            } else {
                setValidLabel(.NotValid, label: nameLabel)
            }
        } else {
            setValidLabel(.Blank, label: nameLabel)
        }

    }
    
    func configureTimePikers() {
        startTimePiсker.datePickerMode = .Time
        startTime.inputView = startTimePiсker
        
        endTimePiсker.datePickerMode = .Time
        endTime.inputView = endTimePiсker
        
        startTime.addTarget(self, action: #selector(RangeTimeTableViewCell.editingText), forControlEvents: .EditingChanged)
        endTime.addTarget(self, action: #selector(RangeTimeTableViewCell.editingText), forControlEvents: .EditingChanged)
        
        startTimePiсker.addTarget(self, action: #selector(RangeTimeTableViewCell.editingChanged), forControlEvents: .ValueChanged)
        endTimePiсker.addTarget(self, action: #selector(RangeTimeTableViewCell.editingChanged), forControlEvents: .ValueChanged)
    }
}
