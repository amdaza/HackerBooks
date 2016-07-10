//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 10/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var favStateLabel: UILabel!
    
    @IBOutlet weak var tagsTable: UITableView!
   
    
    @IBOutlet weak var favSwitch: UISwitch!

    
    let model: AGTBook
    let tagTableController: TagTableViewController
    
    // MARK: - INIT
    
    init(model: AGTBook) {
        self.model = model
        self.tagTableController = TagTableViewController(model: model)
        
        super.init(nibName: "BookViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @IBAction func displayReader(sender: AnyObject) {
        //let
    }
    
    @IBAction func changeFavourite(sender: AnyObject) {
        
        //model.favourite = favSwitch.on
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

}
