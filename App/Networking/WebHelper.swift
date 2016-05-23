//
//  WebHelper.swift
//  App
//
//  Created by developer on 16.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import Alamofire
import AEXML

class WebHelper {
    private static let dataUrl: String = "http://storage.space-o.ru/testXmlFeed.xml"
    
    
    static func getQuotes (success success: (result: [Quote]) -> Void, failed: (error: NSError?) -> Void) {
        Alamofire.request(.GET, dataUrl)
            .response { request, response, data, error in
                if let error = error {
                    failed(error: error)
                    return
                } else {
                    do {
                        if let data = data {
                            var quotesArray = [Quote]()
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "dd/MM/yyyy, hh:mm"
                            let xmlDoc = try AEXMLDocument(xmlData: data)
                            if let quotes = xmlDoc.root["quotes"]["quote"].all {
                                for quote in quotes {
                                    quotesArray.append(Quote(xml: quote))
                                }
                            }
                            success(result: quotesArray)
                        }
                    } catch {
                        failed(error: nil)
                    }
                }
        }
    }
}
