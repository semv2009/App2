//
//  ImageViewManager.swift
//  App
//
//  Created by developer on 01.07.16.
//  Copyright © 2016 developer. All rights reserved.
//

import Foundation
import UIKit

class ImageViewManager {
    var images = [String]()
    var views = [GalleryView]()
    
    var cacheCount: Int
    var middle: Int
    var leftBorder: Int
    var rightBorder: Int
    
    init(cacheCount: Int, imagesPath: String, view: UIView) {
        self.cacheCount = cacheCount
        self.middle = cacheCount / 2 + 1
        self.leftBorder = middle
        self.rightBorder = cacheCount - middle
        
        listImages(forImagePath: imagesPath)
        addImageViews(view)
        loadCasheImages()
    }
    
    
    func listImages(forImagePath imagesPath: String) {
        let fileManager = NSFileManager.defaultManager()
        let str = NSBundle.mainBundle().resourcePath
        let resource = str! + imagesPath
        do {
            let contents = try fileManager.contentsOfDirectoryAtPath(resource)
            for image in contents {
                let imagePath = resource + "/\(image)"
                images.append(imagePath)
            }
        } catch {
        }
    }
    
    func addImageViews(view: UIView) {
        if !images.isEmpty {
            for index in 0...images.count - 1 {
                if  let newView = GalleryView(frame: view.frame, imagePath: images[index]) {
                    views.append(newView)
                }
            }
        }
    }
    
    func loadCasheImages() {
        if !images.isEmpty {
            for index in 0...cacheCount - 1 {
                views.getElement(index)?.loadImage()
            }
        }
    }
    
    func updateViews(width: CGFloat, height: CGFloat) {
        for i in 0...views.count - 1 {
            let index = CGFloat(Double(i))
            views[i].configureScrollView()
            views[i].frame = CGRect.init(x: width * index, y: 0, width: width, height: height)
        }
    }
    
    func resetLeftImage(index: Int) {
        if index < images.count - rightBorder - 1 && index >= leftBorder - 1 {
            views.getElement(index + rightBorder + 1)?.removeImage()
            views.getElement(index - leftBorder + 1)?.loadImage()
        }
        views.getElement(index + 1)?.resetScale()
    }
    
    func resetRightImage(index: Int) {
        if index > leftBorder - 1 && index < images.count - rightBorder {
            views.getElement(index - leftBorder)?.removeImage()
            views.getElement(index + rightBorder)?.loadImage()
        }
        views.getElement(index - 1)?.resetScale()
    }
    
    var isEmpty: Bool {
        return images.isEmpty
    }
    
    var count: Int {
        return views.count
    }
}
