//
//  Widget.swift
//  Custom View from Xib
//
//  Created by Paul Solt on 12/7/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit

@IBDesignable class PersonHeaderView: UIView {

    var view: UIView!

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    
    var nibName: String = "PersonHeaderView"
    
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
    
    func updateUI(sectionName: String) {
        headerTitle.text = sectionName
        headerImage.image = UIImage(imageLiteral: sectionName)
    }
}
