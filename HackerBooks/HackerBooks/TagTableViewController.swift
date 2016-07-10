//
//  TagTableViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 10/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class TagTableViewController: UITableViewController {
    
    // MARK: - Properties
    let model: AGTBook
    
    // MARK: - Initialization
    init(model: AGTBook) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tags"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Tags in book
        return model.tags.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cell type
        let cellId = "TagsCell"
        
        // Get tag name
        let tag = model.tags[indexPath.row]
        
        // Create cell
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            // Optional empty, create one
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        // Syncronize book and cell
        cell?.textLabel?.text = tag
        
        return cell!
    }


}
