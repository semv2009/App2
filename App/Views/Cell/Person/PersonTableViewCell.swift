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
        let attributes = person.getListAttributes()
        if let name = attributes[0].keys[0]?.value as? String {
            nameLabel.text = name
        }
        removeOldView()
        configureStackView(attributes)
    }
    
    func removeOldView() {
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func configureStackView(attributes: [Attribute]) {
        for attribute in attributes {
            if attribute.name != "full name" {
                let personDetailView = PersonDetailView()
                personDetailView.updateUI(attribute)
                stack.addArrangedSubview(personDetailView)
            }
        }
    }
}
