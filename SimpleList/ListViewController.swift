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
    var listItems = [ListItem]()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
    
    // MARK: Data Handling
    
    func saveData(item: ListItem) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("ListItem", inManagedObjectContext:managedContext)
        let listItem = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        listItem.setValue(item.title, forKey: "title")
        listItem.setValue(item.desc, forKey: "desc")
        listItem.setValue(item.createDate, forKey: "createDate")
        listItem.setValue(item.dueDate, forKey: "dueDate")
        
        do {
            try managedContext.save()
            listItems.append(item)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func loadData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ListItem")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            for listItem in results {
                listItems.append(ListItem(managedListItem: listItem as! NSManagedObject))
            }
            listItems.sortInPlace {
                $0.createDate.compare($1.createDate) == NSComparisonResult.OrderedDescending
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    


}

