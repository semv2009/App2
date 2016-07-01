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

    
    var indexOfPage = 0
    var scrollWidth: CGFloat = 0
    var move = true
    
    var manager: ImageViewManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = ImageViewManager(cacheCount: 3, imagesPath: "/Images", view: view)
        configureNavigationBar()
        addImageViewsToScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        if scrollWidth != self.scrollView.frame.width {
            move = false
            configureScrollView()
            if !manager.isEmpty {
                manager.updateViews(self.scrollView.frame.width, height: self.scrollView.frame.height)
            }
            scrollWidth = self.scrollView.frame.width
            self.scrollView.contentOffset.x = CGFloat(indexOfPage) * scrollView.frame.width
        }
        move = true
        switchNavigationButtons()
    }
    
    func configureNavigationBar() {
        title = "Gallery"
        self.edgesForExtendedLayout = UIRectEdge.None
        
        nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(GalleryViewController.moveToNextPage))
        previousButton = UIBarButtonItem(title: "Previous", style: .Plain, target: self, action: #selector(GalleryViewController.moveToPreviousPage))
        
        navigationItem.rightBarButtonItem = nextButton
        navigationItem.leftBarButtonItem = previousButton
        
    }
    
    func configureScrollView() {
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.frame.width * CGFloat(manager.count), height: self.scrollView.frame.height)
        self.scrollView.delegate = self
    }
    
    func switchNavigationButtons() {
        if let _ = manager.views.getElement(indexOfPage + 1) {
            nextButton.enabled = true
        } else {
            nextButton.enabled = false
        }
        
        if let _ = manager.views.getElement(indexOfPage - 1) {
            previousButton.enabled = true
        } else {
            previousButton.enabled = false
        }
        move = true
    }

    func addImageViewsToScrollView() {
        if !manager.isEmpty {
            for view in manager.views {
                self.scrollView.addSubview(view)
            }
        }
    }
    
    // MARK: ScrollView Actions
    
    func moveToNextPage() {
         if let nextView = manager.views.getElement(indexOfPage + 1) {
            move = false
            manager.resetRightImage(indexOfPage + 1)
            indexOfPage += 1
            nextView.resetScale()
            switchNavigationButtons()
            UIView.animateWithDuration(0.2) {
                self.scrollView.scrollRectToVisible(nextView.frame, animated: false)
            }
        }
    }
    
    func moveToPreviousPage() {
        if let previousView = manager.views.getElement(indexOfPage - 1) {
            move = false
            manager.resetLeftImage(indexOfPage - 1)
            indexOfPage -= 1
            previousView.resetScale()
            UIView.animateWithDuration(0.2) {
                self.scrollView.scrollRectToVisible(previousView.frame, animated: false)
            }
            switchNavigationButtons()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        getIndex(scrollView.contentOffset.x)
    }
    
    func getIndex(content: CGFloat) {
        if move && view.frame.width == scrollWidth {
            let content = content + scrollView.frame.size.width / 2
            let newindex = Int(content / scrollView.frame.size.width)
            if indexOfPage - newindex > 0 {
                manager.resetLeftImage(newindex)
            } else if indexOfPage - newindex < 0 {
                manager.resetRightImage(newindex)
            }
            indexOfPage = Int((content) / scrollView.frame.size.width)
            switchNavigationButtons()
        }
    }
}
