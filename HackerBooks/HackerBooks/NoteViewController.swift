//
//  NoteViewController.swift
//  HackerBooks
//
//  Created by Home on 5/10/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    // MARK: - Properties
    var model: Note
    
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBAction func saveNote(_ sender: AnyObject) {
        model.text = noteTextView.text
    }
    
    @IBAction func deleteNote(_ sender: AnyObject) {
        model.managedObjectContext?.delete(model)
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addPhoto(_ sender: AnyObject) {
        
        let pVC = PhotoViewController(model: model)
        navigationController?.pushViewController(pVC, animated: true)
    }
    
    // MARK: - Initialization
    init(model: Note) {
        self.model = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        noteTextView.text = model.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
