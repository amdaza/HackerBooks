//
//  Tag+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData


public class Tag: NSManagedObject {

    //MARK: - Proxies
    var proxyForComparison : String{
        get {
            return name!
        }
    }
    
    var proxyForSorting: String {
        get {
            let fav = (name == "favourites") ? "A" : "Z"
            
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

