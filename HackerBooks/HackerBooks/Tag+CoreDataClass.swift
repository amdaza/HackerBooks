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

