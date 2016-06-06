//
//  Array+SafeGetElement.swift
//  App
//
//  Created by developer on 06.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
extension Array {
    func getElement(index: Int) -> Element? {
        if index < self.count && index > -1 {
            return self[index]
        }
        return nil
    }
}
