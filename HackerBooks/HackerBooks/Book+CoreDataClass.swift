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
public class Book: NSManagedObject, Comparable {
    
    static let entityName = "Book"
    
    
    // MARK: - Computed properties
    var authorsDescription: String {
        get {
            var authorsDesc = "";
            
            if (authors != nil && (authors?.count)! > 0) {
                
                let authorsArray = Array(authors!) as! [String]
                    
                authorsDesc = "Authors: " + authorsArray.joined(separator: ", ")
                
            }
            return authorsDesc
 
        }
    }
    
    var tagsText: String {
        get {
            var tagsTxt = "";
            
            if (bookTags != nil && (bookTags?.count)! > 0) {
                
                for bookTag in bookTags! {
                    let bt = bookTag as! BookTag
                    tagsTxt += "\n -> " + (bt.tag?.name!.capitalized)! + "\n"
                }
                
                // Remove last "\n"
                let index = tagsTxt.index(tagsTxt.endIndex, offsetBy: -2)
                tagsTxt = tagsTxt.substring(to: index)
            }
            return tagsTxt
        }
    }
    
    convenience init(title: String, inContext context: NSManagedObjectContext) {
        
        // We need Notebook entity
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName,
                                                in: context)!
        
        // Super call
        self.init(entity: entity, insertInto: context)

        self.title = title
    }
    
    convenience init(title: String,
                     imageUrl: String, pdfUrl: String,
                     image: NSData, pdf: NSData,
                     favourite: Bool,
                     inContext context: NSManagedObjectContext) {
        
        // We need Notebook entity
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName,
                                                in: context)!
        
        // Super call
        self.init(entity: entity, insertInto: context)
        
        self.title = title
    }
    
    
    

    
    // MARK: - Proxies
    var proxyForComparison : String{
        get {
            return "\(title)\(authorsDescription)\(tagsText)"
        }
    }
    
    
    func addTag(tagName: String,
                inContext context: NSManagedObjectContext) {
        
        let tag = Tag.getOrInsert(withName: tagName,
                             inContext: context)
        
        let bookTag = BookTag.getOrInsert(withTag: tag,
                                     withBook: self,
                                     inContext: context)
        
        // Add bookTag to Book ???
        self.addToBookTags(bookTag)
    }
    
    func deleteTag(tagName: String,
                   inContext context: NSManagedObjectContext) {

        if let tag = Tag.getIfExists(tagName: tagName,
                                     inContext: context){
            
            if let bookTag = BookTag.getIfExists(withTag: tag,
                                                 withBook: self, inContext: context) {
                
                // Delete bookTag from Book
                self.removeFromBookTags(bookTag)
                
                context.delete(bookTag)
            }
        }
    }
    
    func addAuthor(authorName: String,
                inContext context: NSManagedObjectContext) {
        
        let author = Author.getOrInsert(withName: authorName,
                             inContext: context)

        self.addToAuthors(author)
    }
    
    func deleteAuthor(authorName: String,
                   inContext context: NSManagedObjectContext) {
        
        if let author = Author.getIfExists(name: authorName,
                                       inContext: context){
            
            // Delete author from book
            self.removeFromAuthors(author)
        }
    }

}


// MARK: - Equatable
public func ==(lhs: Book, rhs: Book) -> Bool {
    guard (lhs !== rhs) else {
        return true
    }
    return lhs.proxyForComparison == rhs.proxyForComparison
}

// MARK: - Comparable
public func <(lhs: Book, rhs: Book) -> Bool {
    return lhs.title!.lowercased() < rhs.title!.lowercased()
}

// MARK: - KVO
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

// MARK: - Lifecycle
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



