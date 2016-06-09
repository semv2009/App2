//
//  CreatePersonViewController.swift
//  App
//
//  Created by developer on 09.05.16.
//  Copyright © 2016 developer. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class CreatePersonViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var personSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    var person: Person?
    
    var doneButton: UIBarButtonItem!
    var stack: CoreDataStack!
    
    var showDelegate: ShowPersonDelegate?
    var attributes = [Attribute]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBarButtons()
        configureView()
        configureSegmentedControl(person)
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
        tableView.registerNib(UINib(nibName: "StringTableViewCell", bundle: nil), forCellReuseIdentifier: "StringCell")
        tableView.registerNib(UINib(nibName: "NumberTableViewCell", bundle: nil), forCellReuseIdentifier: "NumberCell")
        tableView.registerNib(UINib(nibName: "RangeTimeTableViewCell", bundle: nil), forCellReuseIdentifier: "RangeTimeCell")
        tableView.registerNib(UINib(nibName: "AccountantTypeTableViewCell", bundle: nil), forCellReuseIdentifier:
            "AccountantTypeCell")
        
        if let person = person {
            title = "Update profile"
            attributes = person.getListAttributes()
        } else {
            title = "Create profile"
        }
        doneButton.enabled = false
    }
    
    func configureSegmentedControl(person: Person?) {
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
        let entity = personSegmentedControl.titleForSegmentAtIndex(personSegmentedControl.selectedSegmentIndex)
        if let person = person {
            if person.entity.name == entity {
                person.update(attributes)
            } else {
                stack.mainQueueContext.deleteObject(person)
                self.person = Person.createPerson(entity!, stack: stack, attributes: attributes)
            }
        } else {
            person = Person.createPerson(entity!, stack: stack, attributes: attributes)
        }
        showDelegate?.person = person
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
        attributes = Person.getListAttributes(nameEntity, stack: stack, oldAttribute: attributes)
        checkAllAttributes()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  attributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let attribute = attributes[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(attribute.type.rawValue, forIndexPath: indexPath)
        if let cell = cell as? DataCell {
            cell.addTarget(
                editingChanged: {[unowned self] () in
                    self.checkAllAttributes()
                })
            cell.updateUI(attribute)
        }
        return cell
    }
    
    func checkAllAttributes() {
        var valid = true
        for attribute in self.attributes {
            valid = valid && attribute.isValid()
        }
        self.doneButton.enabled = valid
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

extension CreatePersonViewController: UITextFieldDelegate {
    
}
