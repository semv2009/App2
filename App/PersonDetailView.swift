//
//  Widget.swift
//  Custom View from Xib
//
//  Created by Paul Solt on 12/7/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit
import BNRCoreDataStack

@IBDesignable class PersonDetailView: UIView {

    var view: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var nibName: String = "PersonDetailView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        if let view = nib.instantiateWithOwner(self, options: nil)[0] as? UIView {
            return view
        }
        return UIView()
    }
    
    func updateUI(attribute: AttributeInfo, person: NSManagedObject) {
        nameLabel.text = attribute.description
        
        switch attribute.type {
        case .Date:
            if let value = person.valueForKey(attribute.name) as? NSDate {
                valueLabel.text = value.getTimeFormat()
            } else {
                valueLabel.text = ""
            }
        case .Number:
            if let value = person.valueForKey(attribute.name) as? Int {
                valueLabel.text = "\(value)"
            } else {
                valueLabel.text = ""
            }
        case .String:
            if let value = person.valueForKey(attribute.name) as? String {
                valueLabel.text = value
            } else {
                valueLabel.text = ""
            }
        }
    }
    
    
}
