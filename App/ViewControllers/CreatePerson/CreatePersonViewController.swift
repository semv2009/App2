//
//  CreatePersonViewController.swift
//  App
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class CreatePersonViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var personSegmentedControl: UISegmentedControl!
    
    weak var person: NSManagedObject?
    weak var newPerson: NSManagedObject?
    
    var doneButton: UIBarButtonItem!
    var stack: CoreDataStack!
    
    var attributes = [AttributeInfo]()
    
    var deleteDelegate: DeleteDelegate?
    var showDelegate: ShowPersonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentedControl(person)
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
        tableView.registerNib(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "DataCell")
        if let person = person, entity = person.entity.name {
            title = "Update profile"
            //fsdfdsfdsfs
            switch entity {
            case Accountant.entityName:
                self.newPerson = Accountant(managedObjectContext: self.stack.mainQueueContext)
                if let newPerson = self.newPerson {
                    newPerson.copyData(person)
                }
            case Leadership.entityName:
                self.newPerson = Leadership(managedObjectContext: self.stack.mainQueueContext)
                if let newPerson = self.newPerson {
                    newPerson.copyData(person)
                }
            case FellowWorker.entityName:
                self.newPerson = FellowWorker(managedObjectContext: self.stack.mainQueueContext)
                if let newPerson = self.newPerson {
                    newPerson.copyData(person)
                }
            default:
                break
            }
            
            attributes = newPerson!.getAttributes()
        } else {
            title = "Create profile"
            newPerson = FellowWorker(managedObjectContext: self.stack.mainQueueContext)
            if let newPerson = newPerson {
                attributes = newPerson.getAttributes()
            }
        }
    }
    
    
    func configureSegmentedControl(person: NSManagedObject?) {
        
        
        if let person = person, entity = person.entity.name {
            switch entity {
            case Accountant.entityName:
                personSegmentedControl.selectedSegmentIndex = 2
            case Leadership.entityName:
                personSegmentedControl.selectedSegmentIndex = 1
            case FellowWorker.entityName:
                personSegmentedControl.selectedSegmentIndex = 0
            default:
                break
            }
        }
        
    }
    
    func createBarButtons() {
        self.navigationController?.navigationBar.translucent = false
        self.edgesForExtendedLayout = UIRectEdge.None
        doneButton =  UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(CreatePersonViewController.done))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(CreatePersonViewController.dismiss))
    }
    
    @objc private func dismiss() {
        if let newPerson = newPerson {
            self.stack.mainQueueContext.deleteObject(newPerson)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func done() {
        if let newPerson = newPerson {
            for cell in tableView.visibleCells {
                if let personCell = cell as? DataTableViewCell {
                    newPerson.setValue(personCell.value, forKey: personCell.attribute.name)
                }
            }
            if let person = person {
                deleteDelegate?.deletePersons.append(person)
            }
            showDelegate?.person = newPerson
        } else {
            if let person = person {
                for cell in tableView.visibleCells {
                    if let personCell = cell as? DataTableViewCell {
                        person.setValue(personCell.value, forKey: personCell.attribute.name)
                    }
                }
                showDelegate?.person = person
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: -Segment controller action
    
    @IBAction func changeValueSegmentController(sender: UISegmentedControl) {
        let select = sender.selectedSegmentIndex
        if let nameSegment = personSegmentedControl.titleForSegmentAtIndex(select) {
            updateTableView(nameSegment)
        }
    }
    
    func updateTableView(nameEntity: String) {
        if let newPerson = newPerson {
            switch nameEntity {
            case Accountant.entityName:
                let selectPerson = Accountant(managedObjectContext: self.stack.mainQueueContext)
                selectPerson.copyData(newPerson)
                self.stack.mainQueueContext.deleteObject(newPerson)
                self.newPerson = selectPerson
                attributes = selectPerson.getAttributes()
            case Leadership.entityName:
                let selectPerson = Leadership(managedObjectContext: self.stack.mainQueueContext)
                selectPerson.copyData(newPerson)
                self.stack.mainQueueContext.deleteObject(newPerson)
                self.newPerson = selectPerson
                attributes = selectPerson.getAttributes()
            case FellowWorker.entityName:
                let selectPerson = FellowWorker(managedObjectContext: self.stack.mainQueueContext)
                selectPerson.copyData(newPerson)
                self.stack.mainQueueContext.deleteObject(newPerson)
                self.newPerson = selectPerson
                attributes = selectPerson.getAttributes()
            default:
                break
            }
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  attributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = (tableView.dequeueReusableCellWithIdentifier("DataCell", forIndexPath: indexPath)) as? DataTableViewCell else { fatalError("Cell is not registered") }
        if let newPerson = newPerson {
            cell.updateUI(attributes[indexPath.row], person: newPerson)
            cell.dataTextField.delegate = self
        }
        return cell
    }
}

struct  AttributeInfo {
    var name: String
    var order: Int
    var description: String
    var type: TypeAttribute
}

enum TypeAttribute: Int {
    case String = 700
    case Date = 900
    case Number = 300
}
