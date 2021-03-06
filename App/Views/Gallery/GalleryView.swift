//
//  GalleryView.swift
//  App
//
//  Created by developer on 08.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit

@IBDesignable class GalleryView: UIView, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var view: UIView!
   
    @IBOutlet weak var photoImage: UIImageView!
    let imagePath: String
    
    var nibName: String = "GalleryView"
    
    override init(frame: CGRect) {
        imagePath = ""
        super.init(frame: frame)
        setup()
    }
    
    required init?(frame: CGRect, imagePath: String) {
        self.imagePath = imagePath
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        imagePath = ""
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
    
    func configureScrollView() {
        self.scrollView.frame = view.bounds
        scrollView.backgroundColor = UIColor.whiteColor()
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.scrollView.frame.height)
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        scrollView.delegate = self
        setZoomScale()
        setupGestureRecognizer()
    }
    
    // MARK: ScrollView Delete
    
    func setZoomScale() {
        let imageViewSize = photoImage.bounds.size
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2
        scrollView.zoomScale = 1
        photoImage.contentMode = .ScaleAspectFit
        photoImage.frame = CGRect.init(x: 0, y: 0, width: imageViewSize.width * scrollView.minimumZoomScale, height: imageViewSize.height * scrollView.minimumZoomScale)
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(GalleryView.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    func resetScale() {
        scrollView.zoomScale = 1.0
    }
    
    func loadImage() {
        photoImage.image = UIImage(contentsOfFile: imagePath)
    }
    
    func removeImage() {
        photoImage.image = nil
    }

    // MARK: ScrollView Delete
    
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
}
