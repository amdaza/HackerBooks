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
    
    @IBOutlet weak var tagTitleLabel: UILabel!
    
    @IBOutlet weak var tagList: UITextView!
    
    @IBOutlet weak var favStateLabel: UILabel!
   
    @IBOutlet weak var favSwitch: UISwitch!

    
    var model: AGTBook
    
    // MARK: - INIT
    
    init(model: AGTBook) {
        self.model = model
        
        super.init(nibName: "BookViewController", bundle: nil)
    }
    
    func syncModelWithView() {
        photoView.image = model.syncDownload(model.image_url)
        
        title = model.title
        
        tagTitleLabel.text = "Tags"
        tagList.text = model.tagsText
        
        favStateLabel.text = (model.favourite) ? "Favourite" : "Not favourite"
        favSwitch.on = model.favourite
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @IBAction func displayReader(sender: AnyObject) {
        // Create pdf view controller
        let pdfVC = PDFViewController(model: model)
        
        // Push to navigation controller
        navigationController?.pushViewController(pdfVC, animated: true)
    }
    
    @IBAction func changeFavourite(sender: AnyObject) {
        
        //model.favourite = favSwitch.on
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Quit translucent navigation bar (it hides content)
        self.navigationController?.navigationBar.translucent = false
        
        // Tag list styles
        tagList.textAlignment = .Left
        tagList.editable = false
        
        // Sync
        syncModelWithView()
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


extension BookViewController: LibraryTableViewControllerDelegate {
    func libraryTableViewController(vc: LibraryTableViewController,
        didSelectBook book: AGTBook) {
            
            // Update model
            model = book
            
            print("upsate model")
            print(book)
            
            // Sync
            syncModelWithView()
    }
}
