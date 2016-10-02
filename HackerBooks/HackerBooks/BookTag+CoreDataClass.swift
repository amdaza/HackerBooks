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
    
    // MARK: - Upsert -> update or insert
    // Update if exist, insert if it doesn't
    // Return created or updated BookTag
    public static func upsert(withTag tag: Tag,
                              withBook book: Book,
                              inContext context: NSManagedObjectContext) -> BookTag {
        
        // Check if BookTag already exists
        let req2 = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        
        let tagPredicate = NSPredicate(format: "tag = %@", tag)
        let bookPredicate = NSPredicate(format: "book = %@", book)
        let andPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:
            [tagPredicate, bookPredicate])
        req2.predicate = andPredicate
        
        let result2 = try! context.fetch(req2)
        
        if result2.count > 0 {
            // Get bookTag
            return result2.first!
        } else {
            // Create bookTag
            return BookTag(book: book, tag: tag, inContext: context)
        }
        
    }

}
