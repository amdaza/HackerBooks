//
//  Book+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData


@objc
public class Book: NSManagedObject {
    
    static let entityName = "Book"
    
    convenience init(title: String, inContext context: NSManagedObjectContext) {
        
        // We need Notebook entity
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName,
                                                in: context)!
        
        // Super call
        self.init(entity: entity, insertInto: context)

        self.title = title
    }
    
    // TODO: Create one with authors and bookTags
}

//MARK: - KVO
extension Book {
    @nonobjc static let observableKeys = ["name", "notes"]
    
    func setupKVO(){
        // Subscribe notifications to some properties
        for key in Book.observableKeys {
            self.addObserver(self, forKeyPath: key, options: [],
                             context: nil)
        }
    }
    
    func teardownKVO(){
        // Unsubscribe
        for key in Book.observableKeys {
            self.removeObserver(self, forKeyPath: key)
        }
    }
    
    // Listener for changes
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey : Any]?,
                                      context: UnsafeMutableRawPointer?) {
        //modificationDate = NSDate()
    }
}

//MARK: - Lifecycle
extension Book {
    
    // Called only once
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        setupKVO()
    }
    
    // Called many times
    public override func awakeFromFetch() {
        super.awakeFromFetch()
        
        setupKVO()
    }
    
    public override func willTurnIntoFault() {
        super.willTurnIntoFault()
        
        teardownKVO()
    }
    
    
}



