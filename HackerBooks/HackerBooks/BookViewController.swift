//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Alicia Daza on 10/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit
import CoreData

let FavouriteDidChangeNotification = "Favourite book did change"

class BookViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!

    @IBOutlet weak var tagTitleLabel: UILabel!

    @IBOutlet weak var tagList: UITextView!

    @IBOutlet weak var favStateLabel: UILabel!

    @IBOutlet weak var favSwitch: UISwitch!


    var model: Book
    
    let cds = CoreDataStack(modelName: "Model")!

    // MARK: - INIT

    init(model: Book) {
        self.model = model

        super.init(nibName: "BookViewController", bundle: nil)
    }

    
    func syncModelWithView() {
        photoView.image = model.image?.image

        title = model.title

        tagTitleLabel.text = "Tags"
        tagList.text = model.tagsText

        favStateLabel.text = (model.favourite) ? "Favourite" : "Not favourite"
        favSwitch.isOn = model.favourite

    }
 

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @IBAction func displayReader(_ sender: AnyObject) {
        // Create pdf view controller
        let pdfVC = PDFViewController(model: model)

        // Push to navigation controller
        navigationController?.pushViewController(pdfVC, animated: true)
    }

    @IBAction func changeFavourite(_ sender: AnyObject) {

        if(favSwitch.isOn) {
            
            // Add to favourites
            self.addTag(tagName: Tag.favouriteName)
            model.favourite = true
            
        } else {
            // Delete from favourites
            self.deleteTag(tagName: Tag.favouriteName)
            model.favourite = false
        }

/*
        // Notify
        let nc = NotificationCenter.default
        let notif = Notification(name: Notification.Name(rawValue: FavouriteDidChangeNotification), object: self,
            userInfo: [FavouriteKey: model.index])

        nc.post(notif)
*/
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Quit translucent navigation bar (it hides content)
        self.navigationController?.navigationBar.isTranslucent = false

        // Tag list styles
        tagList.textAlignment = .left
        tagList.isEditable = false

        // Load image (if not loaded yet)
        model.image?.getImage()

        // Subscribe to notifications
        let nc = NotificationCenter.default

        nc.addObserver(self, selector: #selector(BookViewController.imageDidChange(_:)), name: NSNotification.Name(rawValue: ImageDidChangeNotification), object: nil)


        // Sync
        syncModelWithView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Unsuscribe from all notifications
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }

    @objc func imageDidChange(_ notification: Notification) {
        let info = (notification as NSNotification).userInfo!

        let urlString = info[ImageKey] as! String

        if urlString == model.image?.remoteUrl {
            photoView.image = model.image?.image
        }
    }
    
    func addTag(tagName: String) {
        
        let tag : Tag
        let bookTag : BookTag
        
        // Check if Tag already exists
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.predicate = NSPredicate(format: "name == %@", tagName)
        let result = try! cds.context.fetch(req)
        
        if result.count > 0 {
            // Get Tag
            tag = result.first!
        } else {
            // Create Tag
            tag = Tag(name: Tag.favouriteName, inContext: cds.context)
        }
        
        // Check if BookTag already exists
        let req2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        
        let tagPredicate = NSPredicate(format: "tag = %@", tag)
        let bookPredicate = NSPredicate(format: "book = %@", self.model)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
            [tagPredicate, bookPredicate])
        req2.predicate = andPredicate
        
        let result2 = try! cds.context.fetch(req2)
        
        if result2.count > 0 {
            // Get bookTag
            bookTag = result2.first!
        } else {
            // Create bookTag
            bookTag = BookTag(book: self.model, tag: tag, inContext: cds.context)
        }
        
        // Add bookTag to Book ????
        model.addToBookTags(bookTag)
    }
    
    func deleteTag(tagName: String) {
        
        // Check if Tag already exists
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.predicate = NSPredicate(format: "name == %@", tagName)
        let result = try! cds.context.fetch(req)
        
        if result.count > 0 {
        
            let tag = result.first! 
            let bookTag : BookTag
        
            // Check if BookTag already exists
            let req2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        
            let tagPredicate = NSPredicate(format: "tag = %@", tag)
            let bookPredicate = NSPredicate(format: "book = %@", self.model)
            let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
            [tagPredicate, bookPredicate])
            req2.predicate = andPredicate
        
            let result2 = try! cds.context.fetch(req2)
        
            if result2.count > 0 {
                // Get bookTag
                bookTag = result2.first!
                
                // Delete bookTag from Book
                model.removeFromBookTags(bookTag)
                
                cds.context.delete(bookTag)
            }
        }
    }
}


extension BookViewController: LibraryTableViewControllerDelegate {
    func libraryTableViewController(_ vc: LibraryTableViewController,
        didSelectBook book: Book) {

            // Update model
            model = book

            print(book.title)

            // Sync
            syncModelWithView()
    }
}
