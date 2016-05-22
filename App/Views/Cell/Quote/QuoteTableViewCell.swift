//
//  TableViewCell.swift
//  ToDoList
//
//  Created by developer on 06.04.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textlabel: UILabel!
    
    func updateUI(quote: Quote) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm"
        dateLabel.text = dateFormatter.stringFromDate(quote.date)
        textlabel.text = quote.text
    }
}
