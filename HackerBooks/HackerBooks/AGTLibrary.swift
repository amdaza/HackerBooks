//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Alicia Daza on 03/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class AGTLibrary {

    // MARK: - Properties
    
    // Books array
    var books: NSMutableArray = NSMutableArray()
    
    // Array of tags, alphabetic order. No tags repeated
    var tags: NSMutableArray = NSMutableArray()
    
    // Books number
    
    var booksCount: Int {
        get {
            let count: Int = self.books.count
            return count
        }
    }
    
    // Books in tag count
    // If not exists, return 0
    //func bookCountForTag (tag: String?) -> Int

    
    // Array of books (AGTBooks) in tag
    // One book can be in one or more tags.
    // If tag hasn't books, return nil
    //func booksForTag (tag: String?) -> [AGTBook]?


    // Get book at index position in some tag
    // If index or tag don't exist, return nil
    //func bookAtIndex(index: Int) -> AGTBook?
}