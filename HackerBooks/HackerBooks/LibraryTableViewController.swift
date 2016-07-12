//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 05/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

let BookDidChangeNotification = "Selected book did change"
let BookKey = "key"

class LibraryTableViewController: UITableViewController {

    // MARK: - Properties
    let model: AGTLibrary
    
    var delegate: LibraryTableViewControllerDelegate?
    
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
        self.title = "HackerBooks"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView,
        didDeselectRowAtIndexPath indexPath: NSIndexPath) {
            
            print("Selected row")
            print(indexPath.row,indexPath.section)
        
            // Get book
            let book = model.book(atIndex: indexPath.row,
                forTag: model.tags[indexPath.section])
            
            print(book.title)
            
            
            // Notify delegate
            delegate?.libraryTableViewController(self, didSelectBook: book)
            
            // Send same info via notification
            let nc = NSNotificationCenter.defaultCenter()
            let notif = NSNotification(name: BookDidChangeNotification,
                object: self, userInfo: [BookKey: book])
            
            nc.postNotification(notif)
    
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Tags in library
        return model.tagsCount
    }
   
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Books number in tag
        return model.bookCountForTag(model.tags[section])
    }

    override func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        
        return model.tags[section].tag
    }

    override func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Cell type
        let cellId = "LibraryCell"
        
        let book = model.book(atIndex: indexPath.row, forTag: model.tags[indexPath.section])
        
        // Create cell
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            // Optional empty, create one
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        // Syncronize book and cell
        cell?.imageView?.image = book.syncDownload(book.image_url)
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text = book.authorsDescription
    
        return cell!
    }
    
    
    
    /*
    func syncDownload(imageUrl: String) -> UIImage? {
        guard let url = NSURL(string: imageUrl),
            data = NSData(contentsOfURL: url)
            else {
                return nil
        }
        
        return UIImage(data: data)
    }
*/
    
    /*
    func asyncDownload(imageUrl: String) -> UIImage? {
        //var image = nil
        
        let queue = dispatch_queue_create("downloads", nil)
        
        let url = NSURL(string: imageUrl)
        if url != nil {
            
            dispatch_async(queue){
                let data = NSData(contentsOfURL: url!)
                let img = UIImage(data: data!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    // self.imageView.image = image
                    //image = img
                }
            }
        }
        
        return nil
    }
*/

}

protocol LibraryTableViewControllerDelegate {
    
    func libraryTableViewController(vc: LibraryTableViewController,
        didSelectBook book: AGTBook)
}
