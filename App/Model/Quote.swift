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
        let text = xml["text"].value
        let idString = xml["id"].value
        let dateString = xml["date"].value
        let idInt = Int(idString ?? "0")
        let date = dateFormatter.dateFromString(dateString ?? "")
        self.date = date ?? NSDate()
        self.idQuote = idInt ?? 0
        self.text = text ?? ""
    }
}
