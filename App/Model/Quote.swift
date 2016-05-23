//
//  Quote.swift
//  App
//
//  Created by developer on 16.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import AEXML

struct Quote {
    var idQuote: Int
    var date: NSDate
    var text: String
    
    init(xml: AEXMLElement) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
        idQuote = 0
        date = NSDate()
        text = ""
        if let text = xml["text"].value,
            idString = xml["id"].value,
            dateString = xml["date"].value,
            idInt = Int(idString),
            date = dateFormatter.dateFromString(dateString) {
            self.date = date
            self.idQuote = idInt
            self.text = text
        }
    }
}
