//
//  EZLoadingActivity.swift
//  App
//
//  Created by developer on 16.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import EZLoadingActivity

extension EZLoadingActivity {
    public static func hideWithText(text: String, success: Bool?, animated: Bool) {
        if let success = success {
            if success {
                Settings.SuccessText = text
            } else {
                Settings.FailText = text
            }
        }
        hide(success: success, animated: animated)
    }
}
