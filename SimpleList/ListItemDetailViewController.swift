//
//  ListItemDetailViewController.swift
//  SimpleList
//
//  Created by Connor Krupp on 10/2/15.
//  Copyright © 2015 Connor Krupp. All rights reserved.
//

import UIKit

class ListItemDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var dateDueLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var listItem: ListItem?
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let listItem = listItem {
            dateCreatedLabel.text = listItem.createDate.description
            dateDueLabel.text = listItem.dueDate.description
            descriptionTextView.text = listItem.desc
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
