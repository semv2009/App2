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
    var views = [GalleryView]()
    var move = true
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getListImages()
        configureNavigationBar()
        addImageView()
        loadFirstImage()
    }
    
    func loadFirstImage() {
        if !images.isEmpty {
            views[0].loadImage()
            resetRightImage(0)
        }
    }
    
    func addImageView() {
        if !images.isEmpty {
            for index in 0...images.count - 1 {
                if  let newView = GalleryView(frame: view.frame, imagePath: images[index]) {
                    views.append(newView)
                    self.scrollView.addSubview(newView)
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if scrollWidth != self.scrollView.frame.width {
            move = false
            configureScrollView()
            if !images.isEmpty {
                for i in 0...images.count - 1 {
                    let index = CGFloat(Double(i))
                    views[i].configureScrollView()
                    views[i].frame = CGRect.init(x: self.scrollView.frame.width * index, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
                }
            }
            scrollWidth = self.scrollView.frame.width
            self.scrollView.contentOffset.x = CGFloat(indexOfPage) * scrollView.frame.width
        }
        move = true
        switchNavigationButtons()
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
        }
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
    
    func switchNavigationButtons() {
        if let _ = views.getElement(indexOfPage + 1) {
            nextButton.enabled = true
        } else {
            nextButton.enabled = false
        }
        
        if let _ = views.getElement(indexOfPage - 1) {
            previousButton.enabled = true
        } else {
            previousButton.enabled = false
        }
    }

    func resetLeftImage(index: Int) {
        views.getElement(index + 2)?.removeImage()
        views.getElement(index - 1)?.loadImage()
        views.getElement(index + 1)?.resetScale()
    }
    
    func resetRightImage(index: Int) {
        views.getElement(index - 2)?.removeImage()
        views.getElement(index + 1)?.loadImage()
        views.getElement(index - 1)?.resetScale()
    }
    
    // MARK: ScrollView Actions
    
    func moveToNextPage() {
         if let nextView = views.getElement(indexOfPage + 1) {
            move = false
            resetRightImage(indexOfPage + 1)
            indexOfPage += 1
            nextView.resetScale()
            self.scrollView.scrollRectToVisible(nextView.frame, animated: true)
        }
    }
    
    func moveToPreviousPage() {
        if let previousView = views.getElement(indexOfPage - 1) {
            move = false
            resetLeftImage(indexOfPage - 1)
            indexOfPage -= 1
            previousView.resetScale()
            self.scrollView.scrollRectToVisible(previousView.frame, animated: true)
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
                resetLeftImage(newindex)
            } else if indexOfPage - newindex < 0 {
                resetRightImage(newindex)
            }
            indexOfPage = Int((content) / scrollView.frame.size.width)
        }
    }
}
