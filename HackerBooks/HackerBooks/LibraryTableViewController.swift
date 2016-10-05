//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 05/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit
import CoreData

let BookDidChangeNotification = "Selected book did change"
let BookKey = "bookKey"
let FavouriteKey = "favKey"

class LibraryTableViewController: CoreDataTableViewController {

    // MARK: - Properties

    var delegate: LibraryTableViewControllerDelegate?

    var orderIndex: Int = 0
  
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get book
        let book : Book
        
        switch orderIndex {
        case 0:
            let bookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
            book = bookTag.book!
            
        case 1:
            book = fetchedResultsController?.object(at: indexPath) as! Book
            
        default:
            let bookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
            book = bookTag.book!
        }
        
        
        // Get image
        book.image?.getImage()
        
        
        // Cell type
        let cellId = "LibraryCell"
        
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            // Optional empty, create one
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        // Fav cell
        if (book.favourite){
            cell?.backgroundColor = UIColor.orange
        } else {
            cell?.backgroundColor = UIColor.clear
        }
        
        // Syncronize book and cell
        cell?.imageView?.image = book.image?.image
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text = book.authorsDescription
        
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HackerBooks"

        // Trying UISegmentedControl
        //let frame = UIScreen.mainScreen().bounds
        let items = ["HackerBooks by Tags", "HackerBooks by Name"]
        let sc = UISegmentedControl(items: items)

        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(LibraryTableViewController.segmentedControlValueChanged(_:)), for: .valueChanged)
        

        self.navigationItem.titleView = sc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {

            // Get book
        let book : Book

        
            switch orderIndex {
            case 0:
                let bookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
                book = bookTag.book!

            case 1:
                book = fetchedResultsController?.object(at: indexPath) as! Book

            default:
                let bookTag = fetchedResultsController?.object(at: indexPath) as! BookTag
                book = bookTag.book!
            }

            // Notify delegate
            delegate?.libraryTableViewController(self, didSelectBook: book)

            // Send same info via notification
            let nc = NotificationCenter.default
            let notif = Notification(name: Notification.Name(rawValue: BookDidChangeNotification),
                object: self, userInfo: [BookKey: book])

            nc.post(notif)
 
 
        let bookVC = BookViewController(model: book)
        
        navigationController?.pushViewController(bookVC, animated: true)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch orderIndex {
            case 0:
                // Tags in library
            print(fetchedResultsController?.sections?.count)
                return fetchedResultsController?.sections?.count ?? 0

            case 1:
                return 1

            default:
                // Tags in library
                return fetchedResultsController?.sections?.count ?? 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch orderIndex {
        case 0:
            // Books number in tag
            return (fetchedResultsController?.sections?[section].numberOfObjects)!

        case 1:
            return (fetchedResultsController?.fetchedObjects?.count)!

        default:
            // Books number in tag
            return (fetchedResultsController?.sections?[section].numberOfObjects)!
        }
    }

    override func tableView(_ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {

            switch orderIndex {
            case 0:
                let bookTag = fetchedResultsController?.sections?[section].objects?.first as! BookTag
                return bookTag.tag?.name?.capitalized
                

            case 1:
                return "Books by name"

            default:
                let bookTag = fetchedResultsController?.sections?[section].objects?.first as! BookTag
                return bookTag.tag?.name?.capitalized
            }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Subscribe
        let nc = NotificationCenter.default

        // Subscribe to image updates
        nc.addObserver(self, selector: #selector(LibraryTableViewController.libraryDidChange(_:)), name: NSNotification.Name(rawValue: ImageDidChangeNotification), object: nil)

        // Subscribe to favourite updates
        nc.addObserver(self, selector: #selector(LibraryTableViewController.libraryDidChange(_:)), name: NSNotification.Name(rawValue: FavouriteDidChangeNotification), object: nil)

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Unsuscribe from all notifications
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }


    @objc func libraryDidChange(_ notification: Notification) {

        self.tableView.reloadData()

    }

    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl){
        self.orderIndex = sender.selectedSegmentIndex
        
        if let  context = fetchedResultsController?.managedObjectContext {
            
            // Create fetchRequest
            let fr = NSFetchRequest<Book>(entityName: Book.entityName)
            fr.fetchBatchSize = 50 // de 50 en 50
        
            fr.sortDescriptors = [NSSortDescriptor(key: "title",
                                               ascending: false)]
        
            
            // Create fetchedResultsCtrl
            let frc = NSFetchedResultsController(fetchRequest: fr,
                                                 managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            
            
            /////////
            
            let fr2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
            let primarySortDescriptor = NSSortDescriptor(key: "tag.name", ascending: true)
            let secondarySortDescriptor = NSSortDescriptor(key: "book.title", ascending: true)
            fr2.sortDescriptors = [primarySortDescriptor, secondarySortDescriptor]
            //fr2.sortDescriptors = [primarySortDescriptor]
            
            let frc2 = NSFetchedResultsController(
                fetchRequest: fr2,
                managedObjectContext: context,
                sectionNameKeyPath: "tag.name",
                cacheName: nil)
            
            /////////
            
            switch orderIndex {
            case 0:
                self.fetchedResultsController = frc2 as? NSFetchedResultsController<NSFetchRequestResult>
                
            case 1:
                self.fetchedResultsController = frc as? NSFetchedResultsController<NSFetchRequestResult>
                
            default:
                self.fetchedResultsController = frc as? NSFetchedResultsController<NSFetchRequestResult>
            }

        
        }
        
        
        

        self.tableView.reloadData()
    }
 
}

protocol LibraryTableViewControllerDelegate {

    func libraryTableViewController(_ vc: LibraryTableViewController,
        didSelectBook book: Book)
}
