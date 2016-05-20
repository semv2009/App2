//
//  PersonTableViewController.swift
//  App
//
//  Created by developer on 05.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack
import CoreData

class PersonTableViewController: UITableViewController, DeleteDelegate {
    
    var stack: CoreDataStack!
    var deletePersons = [NSManagedObject?]()
    
    private lazy var fetchedResultsController: FetchedResultsController<Person> = {
        let fetchRequest = NSFetchRequest(entityName: Person.entityName)
        
        let nameSortDescriptor = NSSortDescriptor(key: "fullName", ascending:  true)
        let sectionSortDescriptor = NSSortDescriptor(key: "entity.name", ascending:  true)
        let orderSortDescriptor = NSSortDescriptor(key: "order", ascending:  true)
    
        fetchRequest.sortDescriptors = [sectionSortDescriptor, orderSortDescriptor, nameSortDescriptor]
        
        let frc = FetchedResultsController<Person>(fetchRequest: fetchRequest, managedObjectContext: self.stack.mainQueueContext, sectionNameKeyPath: "entity.name")
        
        frc.setDelegate(self.frcDelegate)
        return frc
    }()
    
    private lazy var frcDelegate: PersonsFetchedResultsControllerDelegate = {
        return PersonsFetchedResultsControllerDelegate(tableView: self.tableView)
    }()
    
    
    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for person in deletePersons {
            if let person = person {
                self.stack.mainQueueContext.deleteObject(person)
            }
        }
        tableView.reloadData()
    }
    
    func configureView() {
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        title = "List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PersonTableViewController.showCreatePersonViewController))
        tableView.registerNib(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonCell")
        tableView.sectionHeaderHeight = 48.0
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    func showCreatePersonViewController() {
        let createPersonVC = CreatePersonViewController(coreDataStack: stack)
        createPersonVC.deleteDelegate = self
        showViewController(UINavigationController(rootViewController: createPersonVC), sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].objects.count ?? 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let sections = fetchedResultsController.sections, name = sections[section].name {
            let headerView = PersonHeaderView()
            headerView.updateUI(name)
            return headerView
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("PersonCell", forIndexPath: indexPath)) as? PersonTableViewCell else { fatalError("Cell is not registered") }
        if let person = fetchedResultsController.getObject(indexPath) as? Person {
            cell.updateUI(person)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    //
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            guard let person = fetchedResultsController.getObject(indexPath) as? Person else { fatalError("Don't get task from fetchedResultsController") }
            if let section = fetchedResultsController.sections?[indexPath.section] {
                let toIndexPath = NSIndexPath(forItem: section.objects.count - 1, inSection: indexPath.section)
                fetchedResultsController.changeOrderPersons(moveRowAtIndexPath: indexPath, toIndexPath:  toIndexPath)
                self.stack.mainQueueContext.deleteObject(person)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
   
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        fetchedResultsController.changeOrderPersons(moveRowAtIndexPath: fromIndexPath, toIndexPath: toIndexPath)
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.tableView.editing {return .Delete}
        return .None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let person = fetchedResultsController.getObject(indexPath)
        let createVC = DetailPersonTableViewController(coreDataStack: stack)
        createVC.person = person
        createVC.deleteDelegate = self
        showViewController(createVC, sender: self)
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
}

class PersonsFetchedResultsControllerDelegate: FetchedResultsControllerDelegate {
    
    private weak var tableView: UITableView?
    
    // MARK: - Lifecycle FetchedResultsController
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<Person>) {
        tableView?.reloadData()
    }
    
    func fetchedResultsControllerWillChangeContent(controller: FetchedResultsController<Person>) {
        tableView?.beginUpdates()
    }
    
    func fetchedResultsControllerDidChangeContent(controller: FetchedResultsController<Person>) {
        tableView?.endUpdates()
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Person>,
                                  didChangeObject change: FetchedResultsObjectChange<Person>) {
        switch change {
        case let .Insert(_, indexPath):
            
            if let person = controller.getObject(indexPath) as? Person, section = controller.sections {
                print("Sort entity = \(person.entitySort)")
                person.order = section[indexPath.section].objects.count - 1
            }
            tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Delete(_, indexPath):
            tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        case let .Move(_, fromIndexPath, toIndexPath):
            tableView?.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
            
        case let .Update(_, indexPath):
            tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    func fetchedResultsController(controller: FetchedResultsController<Person>,
                                  didChangeSection change: FetchedResultsSectionChange<Person>) {
        switch change {
        case let .Insert(_, index):
            tableView?.insertSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
            
        case let .Delete(_, index):
            tableView?.deleteSections(NSIndexSet(index: index), withRowAnimation: .Automatic)
        }
    }
}

protocol DeleteDelegate {
    var deletePersons: [NSManagedObject?] { get set }
}
