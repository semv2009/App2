//
//  PersonTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class DirectorTableViewCell: PersonTableViewCell {
    
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var salaryLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func updateUI(person: Person) {
        if let director = person as? Director {
            if let salary = director.salary {
                salaryLabel.text = "\(salary)"
            }
            
            if let name = director.fullName {
                fullNameLabel.text = "name: " + name
            }
            
            if let start = director.beginBusinessHours?.getTimeFormat(), end = director.endBusinessHours?.getTimeFormat() {
                timeLabel.text = start + " - " + end
            }
        }
    }
}
