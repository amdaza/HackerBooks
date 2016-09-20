//
//  LibraryTableViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 05/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

let BookDidChangeNotification = "Selected book did change"
let BookKey = "bookKey"
let FavouriteKey = "favKey"

class LibraryTableViewController: UITableViewController {

    // MARK: - Properties
    let model: AGTLibrary

    var delegate: LibraryTableViewControllerDelegate?

    var orderIndex: Int = 0

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
        //self.title = "HackerBooks"

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
            var book: AGTBook

            switch orderIndex {
            case 0:
                book = model.book(atIndex: (indexPath as NSIndexPath).row,
                    forTag: model.tags[(indexPath as NSIndexPath).section])

            case 1:
                book = model.books[(indexPath as NSIndexPath).row]

            default:
                book = model.book(atIndex: (indexPath as NSIndexPath).row,
                    forTag: model.tags[(indexPath as NSIndexPath).section])
            }

            // Notify delegate
            delegate?.libraryTableViewController(self, didSelectBook: book)

            // Send same info via notification
            let nc = NotificationCenter.default
            let notif = Notification(name: Name(rawValue: BookDidChangeNotification),
                object: self, userInfo: [BookKey: book])

            nc.post(notif)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        switch orderIndex {
            case 0:
                // Tags in library
                return model.tagsCount

            case 1:
                return 1

            default:
                // Tags in library
                return model.tagsCount
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch orderIndex {
        case 0:
            // Books number in tag
            return model.bookCountForTag(model.tags[section])

        case 1:
            return model.booksCount

        default:
            // Books number in tag
            return model.bookCountForTag(model.tags[section])
        }
    }

    override func tableView(_ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {

            switch orderIndex {
            case 0:
                return model.tags[section].tag

            case 1:
                return "Books by name"

            default:
                return model.tags[section].tag
            }
    }

    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Get book
        var book: AGTBook

        switch orderIndex {
        case 0:
            book = model.book(atIndex: (indexPath as NSIndexPath).row, forTag: model.tags[(indexPath as NSIndexPath).section])

        case 1:
            book = model.books[(indexPath as NSIndexPath).row]

        default:
            book = model.book(atIndex: (indexPath as NSIndexPath).row, forTag: model.tags[(indexPath as NSIndexPath).section])
        }


        // Get image
        book.image.getImage()


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
        cell?.imageView?.image = book.image.image
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text = book.authorsDescription

        return cell!
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

        self.tableView.reloadData()
    }
}

protocol LibraryTableViewControllerDelegate {

    func libraryTableViewController(_ vc: LibraryTableViewController,
        didSelectBook book: AGTBook)
}
