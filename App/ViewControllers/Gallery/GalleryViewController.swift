//
//  GalleryViewController.swift
//  App
//
//  Created by developer on 05.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import SnapKit

class GalleryViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var viewC: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var indexPage = 0
    var contentOffsetX: CGFloat = 0
    var arrayImageView = [UIImageView]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        // Do any additional setup after loading the view, typically from a nib.
        //1
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(GalleryViewController.moveToNextPage))

        
    }
    
    override func viewDidLayoutSubviews() {
        let screenSize: CGRect = view.bounds
        self.scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height

       
        for i in 0...3 {
            let d = CGFloat(Double(i))
            let image = UIImage(named: "\(i)")!
            let newView = GalleryView(frame: CGRectMake(scrollViewWidth * d, 0, scrollViewWidth, scrollViewHeight))
            let imageView = UIImageView(frame: CGRectMake(scrollViewWidth * d, 0,(image.size.width), image.size.height))
            imageView.image = image
            arrayImageView.append(imageView)
           
            newView.photoImage.image = image
            setZoomScale(newView.photoImage, ddddd: d)
            //setZoomScale(imageView, ddddd: d)
            self.scrollView.addSubview(newView)
        }

        //center(arrayImageView[0])
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, 0)
        self.scrollView.delegate = self
        
    }
    
    func setZoomScale(imageView: UIImageView, ddddd: CGFloat) {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        //scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
        imageView.contentMode = .ScaleAspectFit
        imageView.frame = CGRectMake(scrollView.bounds.width * ddddd, 0, imageViewSize.width * scrollView.minimumZoomScale, imageViewSize.height * scrollView.minimumZoomScale)
    }
    
    
    func moveToNextPage () {
        print("Next")
        // Move to next page
        let pageWidth: CGFloat = CGRectGetWidth(self.scrollView.frame)
        let maxWidth: CGFloat = pageWidth * 4
        let contentOffset: CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth {
            slideToX = 0
        }
        self.scrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)), animated: true)
    }
    
    //MARK: UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("Hay")
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
    }
    
  
    func center(imageView: UIImageView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        imageView.setNeedsDisplay()
        //scrollView.reloadInputViews()
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x - contentOffsetX == scrollView.bounds.width{
            contentOffsetX = scrollView.contentOffset.x
            indexPage += 1
            print("index = \(indexPage)")
            //center(arrayImageView[indexPage])
        }
        
        if scrollView.contentOffset.x - contentOffsetX == -scrollView.bounds.width{
            contentOffsetX = scrollView.contentOffset.x
            indexPage -= 1
            print("index = \(indexPage)")
            //center(arrayImageView[indexPage])
        }
    }
}
