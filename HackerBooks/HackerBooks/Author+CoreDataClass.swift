//
//  Author+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData


public class Author: NSManagedObject {
    
    static let entityName = "Author"

    convenience init(name: String, inContext context: NSManagedObjectContext) {
        // Get entity description
        let ent = NSEntityDescription.entity(forEntityName: Author.entityName,
                                             in: context)!
        
        // Call super
        self.init(entity: ent, insertInto: context)
        
        self.name = name
    }
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get {
            return name!
        }
    }
    
    var proxyForSorting: String {
        get {
            return name!
        }
    }

    // MARK: Static get & update functions
    
    // Get Author if exists, nil if it doesn't
    public static func getIfExists(name: String,
                                   inContext context: NSManagedObjectContext) -> Author? {
        
        // Check if Author already exists
        let req = NSFetchRequest<Author>(entityName: Author.entityName)
        req.predicate = NSPredicate(format: "name == %@", name)
        
        if let result = try? context.fetch(req),
            result.count > 0 {
            
            return result.first!
        } else {
            return nil
        }
    }
    
    // Get or insert
    // Get if exist, insert if it doesn't
    // Return created or updated Author
    public static func getOrInsert(withName name: String,
                                   inContext context: NSManagedObjectContext) -> Author {
        
        if let author = Author.getIfExists(name: name,
                                     inContext: context) {
            // Get Author
            return author
            
        } else {
            // Create Author
            return Author(name: name, inContext: context)
        }
    }
    
    // Check if Author exists
    public static func exists(name: String,
                              inContext context: NSManagedObjectContext) -> Bool {
        
        if (Author.getIfExists(name: name,
                            inContext: context) != nil) {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Equatable
public func ==(lhs: Author, rhs: Author) -> Bool {
    
    guard (lhs !== rhs) else {
        return true
    }
    return lhs.proxyForComparison == rhs.proxyForComparison
    
}

// MARK: - Comparable
public func <(lhs: Author, rhs: Author) -> Bool {
    
    return lhs.proxyForSorting < rhs.proxyForSorting
}


