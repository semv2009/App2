//
//  MainTabViewController.swift
//  App
//
//  Created by developer on 05.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class MainTabViewController: UITabBarController {
    
    var stack: CoreDataStack
    
    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listController = UINavigationController(rootViewController: PersonTableViewController(coreDataStack: stack))
        let galleryController = UINavigationController(rootViewController: GalleryViewController())
        let serviceController = UINavigationController(rootViewController: ServiceViewController())
        let controllers = [listController, galleryController, serviceController]
        viewControllers = controllers
        
        listController.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(imageLiteral: "List"),
            tag: 1)
        galleryController.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(imageLiteral: "Gallery"),
            tag: 1)
        serviceController.tabBarItem = UITabBarItem(
            title: "Service",
            image: UIImage(imageLiteral: "Service"),
            tag: 1)
    }
}
