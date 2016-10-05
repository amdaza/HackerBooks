//
//  NotesTableViewController.swift
//  HackerBooks
//
//  Created by Home on 5/10/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class NotesTableViewController: CoreDataTableViewController {
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get note
        let note = fetchedResultsController?.object(at: indexPath) as! Note
        
        // Cell type
        let cellId = "LibraryCell"
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            // Optional empty, create one
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
 
        
        // Syncronize book and cell
        cell?.imageView?.image = note.photo?.image
        cell?.textLabel?.text = note.creationDate?.description
        cell?.detailTextLabel?.text = "Modified: " + (note.modificationDate?.description)!
        
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notes"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        // Get note
        let note = fetchedResultsController?.object(at: indexPath) as! Note
        
        let noteVC = NoteViewController(model: note)
        
        navigationController?.pushViewController(noteVC, animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indx = IndexPath(row: 0, section: 0)
        
        if let aux = fetchedResultsController?.object(at: indx) as? Note,
            let bookTitle = aux.book?.title{
            
            self.title = "Notes in " + bookTitle
        }
        
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

}
