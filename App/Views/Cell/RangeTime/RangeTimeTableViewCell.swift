//
//  RangeTimeTableViewCell
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
    
    var startTimePiсker: UIDatePicker!
    var endTimePiсker: UIDatePicker!
    
    var rangeTime: RangeTime!
    
    func updateUI(name: String, rangeTime: RangeTime?) -> RangeTimeTableViewCell {
        startTimePiсker = UIDatePicker()
        endTimePiсker = UIDatePicker()
        
        addToolBar(startTime)
        addToolBar(endTime)
        configureTimePikers()
        nameLabel.text = name
        
        if let start = rangeTime?.start {
            startTimePiсker.date = start
            startTime.text = start.getTimeFormat()
        } else {
            startTimePiсker.date = NSDate()
            startTime.text = ""
        }
        if let end = rangeTime?.end {
            endTimePiсker.date = end
            endTime.text = end.getTimeFormat()
        } else {
            endTimePiсker.date = NSDate()
            endTime.text = ""
        }
        
        self.rangeTime = rangeTime
        return self
    }
    
    func cellSetup(setup: (cell: RangeTimeTableViewCell) -> Void) {
        setup(cell: self)
    }
    
    func editingChanged(datePiker: UIDatePicker) {
        if datePiker == startTimePiсker {
            rangeTime.start = datePiker.date
            startTime.text = datePiker.date.getTimeFormat()
        } else {
            rangeTime.end = datePiker.date
            endTime.text = datePiker.date.getTimeFormat()
        }
        onChange?(value: rangeTime, indexPath: indexPath!)
    }
    
    func editingText(textField: UITextField) {
        if textField == startTime {
            rangeTime.start = nil
        } else {
            rangeTime.end = nil
        }
        onChange?(value: rangeTime, indexPath: indexPath!)
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
