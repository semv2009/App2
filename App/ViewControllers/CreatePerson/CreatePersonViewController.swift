//
//  CreatePersonViewController.swift
//  App
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class CreatePersonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var personSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    var person: Person?
    
    var doneButton: UIBarButtonItem!
    var stack: CoreDataStack
    
    var delegate: CreatePersonViewControllerDelegate?
    var attributes = [Attribute]()
    var manager = AttributeManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtons()
        configureView()
        configureSegmentedControl()
        configureKeyboardNotification()
    }
    
    init(coreDataStack stack: CoreDataStack) {
        self.stack = stack
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    // MARK: Navigator
    
    func configureView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "StringTableViewCell", bundle: nil), forCellReuseIdentifier: CellType.String.rawValue)
        tableView.registerNib(UINib(nibName: "NumberTableViewCell", bundle: nil), forCellReuseIdentifier: CellType.Number.rawValue)
        tableView.registerNib(UINib(nibName: "RangeTimeTableViewCell", bundle: nil), forCellReuseIdentifier: CellType.RangeTime.rawValue)
        tableView.registerNib(UINib(nibName: "AccountantTypeTableViewCell", bundle: nil), forCellReuseIdentifier:
           CellType.AccountantType.rawValue)
        
        if let person = person {
            title = "Update profile"
            manager = person.attributes()
        } else {
            title = "Create profile"
            updateTableView(FellowWorker.entityName)
            personSegmentedControl.selectedSegmentIndex = 0
        }
        doneButton.enabled = false
        tableView.sectionHeaderHeight = 20
    }
    
    func configureSegmentedControl() {
        if let person = person, entity = person.entity.name {
            switch entity {
            case Accountant.entityName:
                personSegmentedControl.selectedSegmentIndex = 2
            case Director.entityName:
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
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func done() {
        if let entity = personSegmentedControl.titleForSegmentAtIndex(personSegmentedControl.selectedSegmentIndex) {
            if let person = person {
                if person.entity.name == entity {
                    person.update(manager.dictionary())
                } else {
                    stack.mainQueueContext.deleteObject(person)
                    self.person = Person.createPerson(entity, stack: stack, manager: manager)
                    self.person?.sectionOrder = personSegmentedControl.selectedSegmentIndex - 1
                }
            } else {
                person = Person.createPerson(entity, stack: stack, manager: manager)
                self.person?.sectionOrder = personSegmentedControl.selectedSegmentIndex - 1
            }
            stack.mainQueueContext.saveContext()
            delegate?.createPersonViewController(didUpdatePerson: person)
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
        manager = Person.attributes(nameEntity, stack: stack, oldManger: manager)
        tableView.reloadData()
        isValid()
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return manager.sections.count ?? 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  manager.sections[section].count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let attribute = manager.attribute(forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(attribute.type.rawValue, forIndexPath: indexPath)
        if let cell = cell as? DataCell {
            cell.indexPath = indexPath
            cell.updateUI(attribute)
                .onChange {[unowned self] value, indexPath in
                    self.manager.setValue(forIndexPath: indexPath, value: value)
                    self.isValid()
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
             return tableView.sectionHeaderHeight
        }
        return tableView.sectionHeaderHeight
    }
    
    func isValid() {
        self.doneButton.enabled = (manager.isValid()) ? true : false
    }
    
    // MARK: Keyboard space
    
    func configureKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreatePersonViewController.keyboardNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreatePersonViewController.keyboardNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardNotification(notification: NSNotification) {
        let isShowing = notification.name == UIKeyboardWillShowNotification
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
            let endFrameHeight = endFrame?.size.height ?? 0.0
            let duration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.unsignedLongValue ?? UIViewAnimationOptions.CurveEaseInOut.rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            self.bottomSpacingConstraint?.constant = isShowing ? endFrameHeight : 0.0
            UIView.animateWithDuration(duration,
                                       delay: NSTimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
}

protocol CreatePersonViewControllerDelegate {
    func createPersonViewController(didUpdatePerson person: Person?)
}
