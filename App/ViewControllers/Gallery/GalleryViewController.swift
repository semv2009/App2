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

        for i in 0...3 {
            let image = UIImage(named: "\(i)")!
            let newView = GalleryView(frame: CGRectMake(0, 0, view.bounds.width, view.bounds.height), image: image)
            views.append(newView!)
            self.scrollView.addSubview(newView!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        print("Screen \(view.frame)")
        let screenSize: CGRect = view.bounds
        self.scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        let scrollViewWidth: CGFloat = self.scrollView.frame.width
        let scrollViewHeight: CGFloat = self.scrollView.frame.height

       
        for i in 0...3 {
            print("Hello")
            let index = CGFloat(Double(i))
            views[i].frame = CGRectMake(scrollViewWidth * index, 0, scrollViewWidth, scrollViewHeight)
        }
        
        self.scrollView.scrollRectToVisible(views[indexPage].frame, animated: false)

        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * 4, self.scrollView.frame.height)
        self.scrollView.delegate = self
        
        print("X = \(scrollView.contentOffset.x)")
        print("Index = \(indexPage)")
        print("View = \(views[indexPage].frame)")
        self.scrollView.scrollRectToVisible(views[indexPage].frame, animated: true)
        contentOffsetX = scrollView.contentOffset.x
    }

    func moveToNextPage() {
        print("Next")
        let pageWidth: CGFloat = CGRectGetWidth(self.scrollView.frame)
        let maxWidth: CGFloat = pageWidth * 4
        let contentOffset: CGFloat = self.scrollView.contentOffset.x
        let slideToX = contentOffset + pageWidth
        if  contentOffset + pageWidth != maxWidth {
            self.scrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)), animated: true)
        }
    }
    
    func moveToPreviousPage() {
        print("Previous")
        let pageWidth: CGFloat = CGRectGetWidth(self.scrollView.frame)
        let maxWidth: CGFloat = pageWidth * 4
        let contentOffset: CGFloat = self.scrollView.contentOffset.x
        let slideToX = contentOffset - pageWidth
        if  contentOffset - pageWidth != -pageWidth {
            self.scrollView.scrollRectToVisible(CGRectMake(slideToX, 0, pageWidth, CGRectGetHeight(self.scrollView.frame)), animated: true)
        }
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
       // print("fdsfsd")
        if scrollView.contentOffset.x - contentOffsetX == scrollView.bounds.width {
            contentOffsetX = scrollView.contentOffset.x
            indexPage += 1
            print(indexPage)
            views[indexPage-1].resetScale()
        }
        
        if scrollView.contentOffset.x - contentOffsetX == -scrollView.bounds.width {
            contentOffsetX = scrollView.contentOffset.x
            indexPage -= 1
            print(indexPage)
            views[indexPage+1].resetScale()
        }
        
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        print("Start")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(scrollView.contentOffset.x)
        print("End")
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        
        print("Hay")
    }
}
