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

    
    let model: AGTBook
    
    // MARK: - INIT
    
    init(model: AGTBook) {
        self.model = model
        
        super.init(nibName: "BookViewController", bundle: nil)
    }
    
    func syncModelWithView() {
        photoView.image = model.syncDownload(model.image_url)
        
        title = model.title
        
        tagTitleLabel.text = "Tags"
        tagList.textAlignment = .Center
        tagList.text = model.tagsText
        
        favStateLabel.text = (model.favourite) ? "Favourite" : "Not favourite"
        favSwitch.on = model.favourite
        
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
