//
//  BookTag+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData


public class BookTag: NSManagedObject {
    
    static let entityName = "BookTag"
    
    convenience init(book: Book, tag: Tag,
                     inContext context: NSManagedObjectContext) {
        // Get entity description
        let ent = NSEntityDescription.entity(forEntityName: BookTag.entityName,
                                             in: context)!
        
        // Call super
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        self.tag = tag
    }
    
    
    
    // MARK: Static get & update functions
    
    // Return BookTag, nil if doesn't exists
    public static func getIfExists(withTag tag: Tag,
                                   withBook book: Book,
                                   inContext context: NSManagedObjectContext) -> BookTag? {
        
        // Check if BookTag already exists
        let req2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        
        let tagPredicate = NSPredicate(format: "tag = %@", tag)
        let bookPredicate = NSPredicate(format: "book = %@", book)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
            [tagPredicate, bookPredicate])
        req2.predicate = andPredicate
        
        if let result2 = try? context.fetch(req2),
            result2.count > 0 {
            
            // Get bookTag
            return result2.first!
        } else {
            // Create bookTag
            return nil
        }
        
    }
    
    // Get or insert
    // Get if exist, insert if it doesn't
    // Return created or updated BookTag
    public static func getOrInsert(withTag tag: Tag,
                              withBook book: Book,
                              inContext context: NSManagedObjectContext) -> BookTag {
        
        guard let bookTag = BookTag.getIfExists(withTag: tag,
                                             withBook: book,
                                             inContext: context) else {
            
            // Create new bookTag
            return BookTag(book: book, tag: tag, inContext: context)
        }
        
        // Already exists, return
        return bookTag
        
    }
    
    // Check if BookTag exists
    public static func exists(withTag tag: Tag,
                              withBook book: Book,
                              inContext context: NSManagedObjectContext) -> Bool {
        
        if (BookTag.getIfExists(withTag: tag,
                                withBook: book,
                                inContext: context) != nil) {
            return true
        } else {
            return false
        }
    }
    
    

}
