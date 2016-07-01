//
//  PersonTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class AccountantTableViewCell: PersonTableViewCell {
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var workplaceLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    
    override func updateUI(person: Person) {
        if let accountant = person as? Accountant {
            if let salary = accountant.salary {
                salaryLabel.text = "\(salary)"
            }
            
            fullNameLabel.text = accountant.fullName
            
            if let start = accountant.beginLunchTime?.getTimeFormat(), end = accountant.endLunchTime?.getTimeFormat() {
                timeLabel.text = start + " - " + end
            }
            
            if let workplce = accountant.workplace {
                workplaceLabel.text = "\(workplce)"
            }
            
            if let type = accountant.type?.integerValue {
                typeLabel.text = AccountantTypes.accountantType(forIndex: type).name
            }
        }
    }
}
