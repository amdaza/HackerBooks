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
            model.addTag(tagName: Tag.favouriteName,
                         inContext: cds.context)
            model.favourite = true
            
        } else {
            // Delete from favourites
            model.deleteTag(tagName: Tag.favouriteName,
                            inContext: cds.context)
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
