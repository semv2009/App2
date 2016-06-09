//
//  DetailPersonTableViewController.swift
//  App
//
//  Created by developer on 15.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack
class DetailPersonTableViewController: UITableViewController, ShowPersonDelegate {
    
    var person: Person? {
        didSet {
            if let person = person, entity = person.entity.name {
                title = entity
                attributes = person.getListAttributes()
                tableView.reloadData()
            }
        }
    }
    
    var stack: CoreDataStack!
    
    var editButton: UIBarButtonItem!
    
    var attributes = [Attribute]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        createBarButtons()
    }
    
    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    
    // MARK: Navigator
    
    func configureView() {
        tableView.delegate = self
        tableView.registerNib(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailCell")
    }
    
    func createBarButtons() {
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        editButton =  UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: #selector(DetailPersonTableViewController.edit))
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc private func edit() {
        let createVC = CreatePersonViewController(coreDataStack: stack)
        createVC.person = person
        createVC.showDelegate = self
        showViewController(UINavigationController(rootViewController: createVC), sender: self)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  attributes.count ?? 0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell =  cell as? DetailTableViewCell else { fatalError("Cell is not registered") }
        let attribute = attributes[indexPath.row]
        cell.updateUI(attribute)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath)) as? DetailTableViewCell else { fatalError("Cell is not registered") }
        return cell
    }
    
}

protocol ShowPersonDelegate {
    var person: Person? { get set }
}
