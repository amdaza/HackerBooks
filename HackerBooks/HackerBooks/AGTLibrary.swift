//
//  AGTLibrary.swift
//  HackerBooks
//
//  Created by Alicia Daza on 03/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class AGTLibrary {
    
    // MARK: - Utility types
    typealias BooksArray = [AGTBook]
    typealias TagsSet = Set<String>
    typealias BookIndexes = Set<Int>
    typealias HackBookLibrary = [String: BookIndexes]
    
    // MARK: - Properties
    
    // Books array
    var books: BooksArray = BooksArray()
    
    // Array of tags, alphabetic order. No tags repeated
    var tags: TagsSet = TagsSet()
    
    
    // Library, useful as an index for accessing books by tag
    var library: HackBookLibrary = HackBookLibrary()
    
    // Initialization
    init (withBooks bs: BooksArray) {
        
        // Add books to structures
        books = bs
        var bookIndex = 0
        
        for book in books {
            
            // Add tags
            for tag in book.tags{
                
                // Check new tags
                if(!tags.contains(tag)){
                    
                    tags.insert(tag)
                    
                    // Add to library
                    library[tag] = BookIndexes()
                }
                
                // Add book to library
                library[tag]?.insert(bookIndex)
                
                //guard
                
            }
            
            bookIndex++
            
        }
        
    }
    
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