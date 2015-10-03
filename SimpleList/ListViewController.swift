//
//  ListViewController.swift
//  SimpleList
//
//  Created by Connor Krupp on 10/2/15.
//  Copyright © 2015 Connor Krupp. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    @IBOutlet weak var listTableView: UITableView!
    
    var listItems = [ListItem]() {
        didSet {
            listItems.sortInPlace {
                $0.createDate.compare($1.createDate) == NSComparisonResult.OrderedDescending
            }
        }
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadListData()
        listTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "standardCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: IBActions
    
    @IBAction func add(sender: UIBarButtonItem) {
        
        // Temporary item for Core Data testing
        let testItem = ListItem(
            title: "Test Title \(listItems.count)",
            desc: "Test Description",
            createDate: NSDate(),
            dueDate: NSDate(timeIntervalSinceNow: NSTimeInterval(200))
        )
        
        saveData(testItem)
        listTableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("standardCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = listItems[indexPath.row].title
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toDetail", sender: self)
    }
    
    // MARK: UIStoryboardSegue Handling
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDetail" {
            let destinationViewController = segue.destinationViewController as! ListItemDetailViewController
            let indexPath = listTableView.indexPathForSelectedRow!
            destinationViewController.listItem = listItems[indexPath.row]
        }
    }
    
    // MARK: Data Handling
    
    func saveData(listItem: ListItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("ListItem", inManagedObjectContext:managedContext)
        let managedListItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        managedListItem.setValue(listItem.title, forKey: "title")
        managedListItem.setValue(listItem.desc, forKey: "desc")
        managedListItem.setValue(listItem.createDate, forKey: "createDate")
        managedListItem.setValue(listItem.dueDate, forKey: "dueDate")
        
        do {
            try managedContext.save()
            listItems.append(listItem)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func loadListData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ListItem")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            // Map each NSManagedObject to its ListItem equivalent
            listItems = results.map {
                ListItem(managedListItem: ($0 as! NSManagedObject))
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

}

