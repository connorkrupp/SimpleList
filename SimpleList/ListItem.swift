//
//  ListItem.swift
//  SimpleList
//
//  Created by Connor Krupp on 10/2/15.
//  Copyright © 2015 Connor Krupp. All rights reserved.
//

import Foundation
import CoreData

struct ListItem {
    
    // MARK: Properties
    
    var title: String
    var desc: String
    var createDate: NSDate
    var dueDate: NSDate
    
    // MARK: Initializers
    
    init(title: String, desc: String, createDate: NSDate, dueDate: NSDate) {
        self.title = title
        self.desc = desc
        self.createDate = createDate
        self.dueDate = dueDate
    }
    
    init(managedListItem: NSManagedObject) {
        self.title = managedListItem.valueForKey("title") as! String
        self.desc = managedListItem.valueForKey("desc") as! String
        self.createDate = managedListItem.valueForKey("createDate") as! NSDate
        self.dueDate = managedListItem.valueForKey("dueDate") as! NSDate
    }
}