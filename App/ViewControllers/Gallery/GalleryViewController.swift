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
    
    var nextButton: UIBarButtonItem!
    var previousButton: UIBarButtonItem!

    
    var indexPage = 0
    var contentOffsetX: CGFloat = 0
    var startIndex = 0
    var views = [GalleryView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(view.bounds)
        UINavigationBar.appearance().backgroundColor = UIColor(red: 100, green: 100, blue: 100, alpha: 0.2)
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        
        nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(GalleryViewController.moveToNextPage))
        previousButton = UIBarButtonItem(title: "Previous", style: .Plain, target: self, action: #selector(GalleryViewController.moveToPreviousPage))

        navigationItem.rightBarButtonItem = nextButton
        navigationItem.leftBarButtonItem = previousButton

        for i in 0...14 {
//            var image: UIImage? = UIImage(named: "\(i)")
//            var imageData: NSData? = UIImagePNGRepresentation(image!)!
//            image = nil
            let newView = GalleryView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height))
            //imageData = nil
            views.append(newView)
            self.scrollView.addSubview(newView)
        }
        views[0].setImage("0")
        clearImage(0)
    }
    
    func clearImage(index: Int) {
        if index - 2 > -1 {
            views[index - 2].setImage(nil)
        }
        
        if index + 2 < views.count {
            views[index + 2].setImage(nil)
        }
        
        if index + 1 < views.count {
            views[index + 1].setImage("\(index + 1)")
        }
        
        if index - 1 > -1 {
            views[index - 1].setImage("\(index - 1)")
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        print("Screen \(view.frame)")
        let screenSize: CGRect = view.bounds
        self.scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height

       
        for i in 0...14 {
            print("Hello")
            let index = CGFloat(Double(i))
            views[i].frame =   CGRectMake(scrollViewWidth * index, 0, scrollViewWidth, scrollViewHeight)
            views[i].configureScrollView()
        }
        
        //self.scrollView.scrollRectToVisible(views[indexPage].frame, animated: false)

        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * CGFloat(views.count), self.scrollView.frame.height)
        self.scrollView.delegate = self
        
        print("X = \(scrollView.contentOffset.x)")
        print("Index = \(indexPage)")
        print("View = \(views[indexPage].frame)")
        self.scrollView.scrollRectToVisible(views[indexPage].frame, animated: false)
        contentOffsetX = scrollView.contentOffset.x
    }

    func moveToNextPage() {
        print("Next")
        print("---->\(indexPage)")
        //views[indexPage].photoImage.image = nil
        if indexPage + 1 < views.count {
            clearImage(indexPage + 1)
            views[indexPage + 1].resetScale()
        }
        let pageWidth: CGFloat = CGRectGetWidth(self.scrollView.frame)
        let maxWidth: CGFloat = pageWidth * CGFloat(views.count)
        let contentOffset: CGFloat = self.scrollView.contentOffset.x
        let slideToX = contentOffset + pageWidth
        if  contentOffset + pageWidth != maxWidth {
            self.scrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)), animated: true)
        }
    }
    
    func moveToPreviousPage() {
        print("Previous")
        print("---->\(indexPage)")
         //views[indexPage].photoImage.image = nil
        if indexPage - 1 > -1{
             clearImage(indexPage - 1)
            views[indexPage - 1].resetScale()
        }
       
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        startIndex = index
        let pageWidth: CGFloat = CGRectGetWidth(self.scrollView.frame)
        let maxWidth: CGFloat = pageWidth * CGFloat(views.count)
        let contentOffset: CGFloat = self.scrollView.contentOffset.x
        let slideToX = contentOffset - pageWidth
        if  contentOffset - pageWidth != -pageWidth {
            self.scrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)), animated: true)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
       // print("fdsfsd")
//        if scrollView.contentOffset.x - contentOffsetX == scrollView.bounds.width {
//            contentOffsetX = scrollView.contentOffset.x
//            indexPage += 1
//            print(indexPage)
//            views[indexPage-1].resetScale()
//        }
//        
//        if scrollView.contentOffset.x - contentOffsetX == -scrollView.bounds.width {
//            contentOffsetX = scrollView.contentOffset.x
//            indexPage -= 1
//            print(indexPage)
//            views[indexPage+1].resetScale()
//        }
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        //print("Start")
        print(scrollView.contentOffset.x)
        //print("Index start = \(Int(scrollView.contentOffset.x / scrollView.frame.size.width))")
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        startIndex = index
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //print("Index end = \(index)")
        indexPage = index
        if index == startIndex {
            if index + 1 != views.count {
                views[index+1].resetScale()
            }
        } else {
            if index - 1 != -1 {
                views[index - 1].resetScale()
            }
        }
        print("End \(index))")
        clearImage(index)
        print("End")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        print("Begin")
        print("Index start = \(Int(scrollView.contentOffset.x / scrollView.frame.size.width))")
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //clearImage(index)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        indexPage = index
        print(indexPage)
        print("Stop")
    }
}
