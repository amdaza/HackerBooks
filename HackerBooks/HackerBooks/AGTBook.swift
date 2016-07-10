//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Alicia Daza on 03/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class AGTBook : Comparable {
    
    let title: String
    var authors: [String]
    var tags: [String]
    let image_url: NSURL
    let pdf_url: NSURL
    let favourite: Bool
    
    // MARK: - Computed properties
    var authorsDescription: String {
        get {
            return "Authors: " + authors.joinWithSeparator(", ")
        }
    }
    
    // MARK: - Initialization
    init(title: String, authors: [String],
        tags: [String], image_url: NSURL,
        pdf_url: NSURL, favourite: Bool) {
            
            self.title = title
            self.authors = authors
            self.tags = tags
            self.image_url = image_url
            self.pdf_url = pdf_url
            self.favourite = favourite
    }
    
    //MARK: - Proxies
    var proxyForComparison : String{
        get {
            return "\(title)\(image_url)\(pdf_url)"
        }
    }
   
}

// Mark: - Equatable
func ==(lhs: AGTBook, rhs: AGTBook) -> Bool {
    guard (lhs !== rhs) else {
        return true
    }
    return lhs.proxyForComparison == rhs.proxyForComparison
}

// Mark: - Comparable
func <(lhs: AGTBook, rhs: AGTBook) -> Bool {
    return lhs.title.lowercaseString < rhs.title.lowercaseString
}

