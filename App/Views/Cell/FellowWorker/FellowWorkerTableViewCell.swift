//
//  PersonTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class FellowWorkerTableViewCell: PersonTableViewCell {
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var workplaceLabel: UILabel!
    
    override func updateUI(person: Person) {
        if let fellowWorker = person as? FellowWorker {
            if let salary = fellowWorker.salary {
                salaryLabel.text = "\(salary)"
            }
            
            fullNameLabel.text = fellowWorker.fullName
            
            if let start = fellowWorker.beginLunchTime?.getTimeFormat(), end = fellowWorker.endLunchTime?.getTimeFormat() {
                timeLabel.text = start + " - " + end
            }
            if let workplace = fellowWorker.workplace {
                workplaceLabel.text = "\(workplace)"
            }
            
        }
    }
}
