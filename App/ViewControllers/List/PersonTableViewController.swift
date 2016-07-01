import UIKit
import BNRCoreDataStack
import CoreData

class PersonTableViewController: UITableViewController {
    
    var stack: CoreDataStack
    var editingMode = false
    
    private lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: Person.entityName)
        let sectionsSortDescriptor = NSSortDescriptor(key: "sectionOrder", ascending: true)
        let nameSortDescriptor = NSSortDescriptor(key: "fullName", ascending: true)
        let orderSortDescriptor = NSSortDescriptor(key: "order", ascending: true)
        fetchRequest.sortDescriptors = [sectionsSortDescriptor, orderSortDescriptor, nameSortDescriptor]
        var frc =  NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.stack.mainQueueContext, sectionNameKeyPath: "sectionOrder", cacheName: nil)
        frc.delegate = self
        return frc
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
        performFetch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureView() {
        title = "List"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(PersonTableViewController.showCreatePersonViewController))
        navigationItem.leftBarButtonItem = self.editButtonItem()
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "PersonTableViewCell", bundle: nil), forCellReuseIdentifier: "PersonCell")
        tableView.registerNib(UINib(nibName: "FellowWorkerTableViewCell", bundle: nil), forCellReuseIdentifier: "FellowWorkerCell")
        tableView.registerNib(UINib(nibName: "DirectorTableViewCell", bundle: nil), forCellReuseIdentifier: "DirectorCell")
        tableView.registerNib(UINib(nibName: "AccountantTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountantCell")
        tableView.sectionHeaderHeight = 48.0
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        editingMode = editing
    }
    
    func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch objects: \(error)")
        }
    }
    
    func showCreatePersonViewController() {
        self.setEditing(false, animated: true)
        let createPersonVC = CreatePersonViewController(coreDataStack: stack)
        showViewController(UINavigationController(rootViewController: createPersonVC), sender: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if fetchedResultsController.sections?.count > 0 {
            navigationItem.leftBarButtonItem?.enabled = true
        } else {
            self.setEditing(false, animated: true)
            navigationItem.leftBarButtonItem?.enabled = false
        }
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let object = fetchedResultsController.getObject(NSIndexPath(forRow: 0, inSection: section))
        let headerView = PersonHeaderView()
        headerView.updateUI(object.entity.name!)
        return headerView
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let person = fetchedResultsController.getObject(indexPath)
        let cell = tableView.dequeueReusable(person.entity.name!, indexPath: indexPath)
        cell.updateUI(person)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            editingMode = false
            let person = fetchedResultsController.getObject(indexPath)
            self.stack.mainQueueContext.deleteObject(person)
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        editingMode = true
        let person = fetchedResultsController.getObject(fromIndexPath)
        if let sections = fetchedResultsController.sections, var persons = sections[fromIndexPath.section].objects as? [Person] {
            if fromIndexPath != toIndexPath {
                persons.removeAtIndex(fromIndexPath.row)
                persons.insert(person, atIndex: toIndexPath.row)
                
                var index = -1
                for sortPerson in persons {
                    index += 1
                    sortPerson.order = index
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.tableView.editing {return .Delete}
        return .None
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.setEditing(false, animated: true)
        let detailVC = DetailPersonTableViewController(coreDataStack: stack)
        detailVC.person = fetchedResultsController.getObject(indexPath)
        showViewController(detailVC, sender: self)
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    
}
// MARK: - Lifecycle FetchedResultsController

extension PersonTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if editingMode {return}
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if editingMode {return}
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if editingMode {return}
        switch type {
        case .Insert:
            if let indexPath = newIndexPath {
                let person = controller.getObject(indexPath)
                let maxOrder = controller.maxOrder(indexPath)
                if maxOrder > 0 {
                    person.order = maxOrder + 1
                }
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
        case .Update:
            if let indexPath = indexPath {
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                    atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        if editingMode {return}
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        default:
            break
        }
    }
}
