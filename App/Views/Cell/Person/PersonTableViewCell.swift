//
//  PersonTableViewCell.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateUI(person: Person) {
        let manager = person.attributes()
        if let name = manager.value(forName: "full name") as? String {
            nameLabel.text = name
        }
        removeOldView()
        configureStackView(manager)
    }
    
    func removeOldView() {
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func configureStackView(manager: AttributeManager) {
        for section in manager.sections {
            for attribute in section {
                if attribute.name != "full name" {
                    let personDetailView = PersonDetailView()
                    personDetailView.updateUI(attribute)
                    stack.addArrangedSubview(personDetailView)
                }
            }
        }
    }
}
