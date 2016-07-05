//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 05/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController {

    // MARK: - Properties
    let model: AGTLibrary
    
    // MARK: - Initialization
    init(model: AGTLibrary) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   /*
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Books number in tag
        return model.
    }
*/
}
