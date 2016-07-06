//
//  AGTTag.swift
//  HackerBooks
//
//  Created by Alicia Daza on 07/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation

class AGTTag: Hashable, Comparable {
    
    let tag: String
    var hashValue: Int {
        return self.tag.hashValue
    }
    
    init (tag: String) {
        self.tag = tag
    }
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get {
            return tag
        }
    }
    
    var proxyForSorting: String {
        get {
            let fav = (tag == "favourites") ? "A" : "Z"
            
            return "\(fav)\(tag)"
        }
    }

}

// MARK: - Equatable
func ==(lhs: AGTTag, rhs: AGTTag) -> Bool {
        
        guard (lhs !== rhs) else {
            return true
        }
        return lhs.proxyForComparison == rhs.proxyForComparison
        
}

// MARK: - Comparable
func <(lhs: AGTTag, rhs: AGTTag) -> Bool {
        
        return lhs.proxyForSorting < rhs.proxyForSorting
}

