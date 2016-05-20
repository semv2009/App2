//
//  Widget.swift
//  Custom View from Xib
//
//  Created by Paul Solt on 12/7/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

import UIKit

@IBDesignable class GalleryView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var view: UIView!
   
    @IBOutlet weak var photoImage: UIImageView!
    
    var nibName: String = "GalleryView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required init?(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        setup()
        photoImage.image = image
        configureScrollView()
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        addSubview(view)
    }
    
    func configureScrollView() {
        self.scrollView.frame = view.bounds
        scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 3, self.scrollView.frame.height)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        scrollView.contentOffset = CGPoint(x: 1111, y: 1111)
        scrollView.delegate = self
        setZoomScale()
        setupGestureRecognizer()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return photoImage
    }
   
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let imageViewSize = photoImage.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func setZoomScale() {
        let imageViewSize = photoImage.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        scrollView.minimumZoomScale = 1
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 2
        photoImage.contentMode = .ScaleAspectFit
        photoImage.frame = CGRectMake(0, 0, imageViewSize.width * scrollView.minimumZoomScale, imageViewSize.height * scrollView.minimumZoomScale)
    }

    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: "handleDoubleTap:")
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        if let view = nib.instantiateWithOwner(self, options: nil)[0] as? UIView {
            return view
        }
        return UIView()
    }
}
