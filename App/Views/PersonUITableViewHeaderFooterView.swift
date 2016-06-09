//
//  PersonUITableViewHeaderFooterView.swift
//  App
//
//  Created by developer on 09.06.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

class PersonUITableViewHeaderFooterView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    
    func updateUI(sectionName: String) {
        headerTitle.text = sectionName
        headerImage.image = UIImage(imageLiteral: sectionName)
    }

}
