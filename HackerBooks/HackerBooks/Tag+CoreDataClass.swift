//
//  Tag+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData


public class Tag: NSManagedObject, Comparable {
    
    static let entityName = "Tag"
    static let favouriteName = "favourites"
    
    convenience init(name: String, inContext context: NSManagedObjectContext) {
        // Get entity description
        let ent = NSEntityDescription.entity(forEntityName: Tag.entityName,
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
            let fav = (name == Tag.favouriteName) ? "A" : "Z"
            
            return "\(fav)\(name)"
        }
    }
    
    
    // MARK: Static get & update functions
    
    // Get Tag if exists, nil if it doesn't
    public static func getIfExists(tagName: String,
                              inContext context: NSManagedObjectContext) -> Tag? {
        
        // Check if Tag already exists
        let req = NSFetchRequest<Tag>(entityName: Tag.entityName)
        req.predicate = NSPredicate(format: "name == %@", tagName)
        
        if let result = try? context.fetch(req),
            result.count > 0 {
            
            return result.first!
        } else {
            return nil
        }
    }
    
    // Get or insert
    // Get if exist, insert if it doesn't
    // Return created or updated tag
    public static func getOrInsert(withName tagName: String,
                              inContext context: NSManagedObjectContext) -> Tag {
        
        guard let tag = Tag.getIfExists(tagName: tagName,
                                        inContext: context) else {
            // Create new Tag
            return Tag(name: tagName, inContext: context)
        }
        
        // Already exists, return
        return tag
    }
    
    // Check if Tag exists
    public static func exists(tagName: String,
                              inContext context: NSManagedObjectContext) -> Bool {
        
        if (Tag.getIfExists(tagName: tagName,
                               inContext: context) != nil) {
            return true
        } else {
            return false
        }
    }
    
}

// MARK: - Equatable
public func ==(lhs: Tag, rhs: Tag) -> Bool {
    
    guard (lhs !== rhs) else {
        return true
    }
    return lhs.proxyForComparison == rhs.proxyForComparison
    
}

// MARK: - Comparable
public func <(lhs: Tag, rhs: Tag) -> Bool {
    
    return lhs.proxyForSorting < rhs.proxyForSorting
}

