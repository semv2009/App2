//
//  TableViewCell.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateUI(person: Person) {
        nameLabel.text = person.fullName
        removeOldView()
        configureStackView(person)
    }
    
    func removeOldView() {
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func configureStackView(person: Person) {
        let attributes = person.getAttributes()
        for attribute in attributes {
            if attribute.name != "fullName" {
                if !person.isEmptyValue(attribute.name, typeAttribute: attribute.type) {
                    let personDetailView = PersonDetailView()
                    personDetailView.updateUI(attribute, person: person)
                    stack.addArrangedSubview(personDetailView)
                }
            }
        }
    }
}
