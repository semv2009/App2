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
    var contentOffsetX: CGFloat = 0
    var scrollWidth = 0
    var startIndex = 0
    var views = [GalleryView]()
    var move = true
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListImages()
        configureNavigationBar()
        addImageView()
        
        
        views[0].loadImage()
        resetRightImage(0)
        
    }
    
    func addImageView() {
        for index in 0...images.count - 1 {
            if  let newView = GalleryView(frame: view.frame, imagePath: images[index]) {
                views.append(newView)
                self.scrollView.addSubview(newView)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        configureScrollView()
        
        for i in 0...14 {
            let index = CGFloat(Double(i))
            views[i].configureScrollView()
            views[i].frame = CGRect.init(x: self.scrollView.frame.width * index, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
        }
        
        disableNavigationButtons()
        
        if move {
            self.scrollView.scrollRectToVisible(views[indexOfPage].frame, animated: false)
        } else {
            move = true
        }
        contentOffsetX = scrollView.contentOffset.x
        
    }
    
    func getListImages() {
        let fileManager = NSFileManager.defaultManager()
        let str = NSBundle.mainBundle().resourcePath
        let resource = str! + "/Images"
        do {
            let contents = try fileManager.contentsOfDirectoryAtPath(resource)
            for image in contents {
                let imagePath = resource + "/\(image)"
                images.append(imagePath)
            }
        } catch {
            print("error")
        }
        print(images)
        print(images.count)
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
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.frame.width * CGFloat(views.count), height: self.scrollView.frame.height)
        self.scrollView.delegate = self
    }
    
    func enableNavigationButtons() {
        if indexOfPage + 1 < views.count {
            nextButton.enabled = true
        }
        if indexOfPage - 1 > -1 {
            previousButton.enabled = true
        }
    }
    
    func disableNavigationButtons() {
        if indexOfPage + 1 == views.count {
            nextButton.enabled = false
        }
        if indexOfPage - 1 == -1 {
             previousButton.enabled = false
        }
    }

    func resetLeftImage(index: Int) {
        
        if index + 2 < views.count {
            views[index + 2].removeImage()
        }
        if index - 1 > -1 {
            views[index - 1].loadImage()
        }
    }
    
    func resetRightImage(index: Int) {
        if index - 2 > -1 {
            views[index - 2].removeImage()
        }
        if index + 1 < views.count {
            views[index + 1].loadImage()
        }
    }
    
    // MARK: ScrollView Actions
    
    func moveToNextPage() {
        move = false
        nextButton.enabled = false
        if indexOfPage + 1 < views.count {
            resetRightImage(indexOfPage + 1)
            views[indexOfPage + 1].resetScale()
            indexOfPage += 1
            self.scrollView.scrollRectToVisible(views[indexOfPage].frame, animated: true)
        }
    }
    
    func moveToPreviousPage() {
        move = false
        previousButton.enabled = false
        if indexOfPage - 1 > -1 {
            resetLeftImage(indexOfPage - 1)
            views[indexOfPage - 1].resetScale()
            indexOfPage -= 1
            self.scrollView.scrollRectToVisible(views[indexOfPage].frame, animated: true)
        }
    }
    
     // MARK: ScrollView Delegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollView.userInteractionEnabled = false
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        startIndex = index
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        indexOfPage = index
        if index == startIndex {
            if index + 1 != views.count {
                views[index+1].resetScale()
            }
            
        } else {
            if index - 1 != -1 {
                views[index - 1].resetScale()
            }
        }
        
        if startIndex - index < 0 {
            resetRightImage(index)
        } else {
            resetLeftImage(index)
        }
        enableNavigationButtons()
        
        scrollView.userInteractionEnabled = true
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        enableNavigationButtons()
    }
}
