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
    typealias TagsArray = [AGTTag]
    typealias HackBookLibrary = [AGTTag: [Int]]

    // MARK: - Properties

    // Books array
    var books: BooksArray = BooksArray()

    // Array of tags, alphabetic order. No tags repeated
    var tags: TagsArray = TagsArray()


    // Library, useful as an index for accessing books by tag
    var library: HackBookLibrary = HackBookLibrary()

    var defaultImage: UIImage?

    // Initialization
    init (withBooks bs: BooksArray) {

        // Add books to structures
        books = bs

        books = books.sort { $0 < $1 }

        var bookIndex = 0

        for book in books {

            // Add tags
            for tag in book.tags{
                let agtTag = AGTTag(tag: tag)

                // Check new tags
                if(!tags.contains(agtTag)){
                    // Add tag
                    tags.append(agtTag)

                    // Add empty array to tag in library
                    library[agtTag] = [Int]()
                }

                // Add book to library
                library[agtTag]?.append(bookIndex)

            }

            // Save index in book model (used in fav defaults)
            book.index = bookIndex

            // Iterate index
            bookIndex++

        }


        // Favourites
        let defaults = NSUserDefaults.standardUserDefaults()

        let favTag = AGTTag(tag: "favourites")
        library[favTag] = [Int]()

        if let favBooksIndexes = defaults.objectForKey(FavouriteKey) as? [Int]{

            for index in favBooksIndexes {
                // Set fav to model
                books[index].favourite = true

                // Add to favourites tag
                library[favTag]?.append(index)

            }

            tags.append(favTag)

        } else {
            library[favTag] = [Int]()
        }

        // Subscribe
        let nc = NSNotificationCenter.defaultCenter()

        // Subscribe to favourite updates
        nc.addObserver(self, selector: "favouriteDidChange:", name: FavouriteDidChangeNotification, object: nil)

        // Order tags
        tags.sortInPlace({ $0 < $1 })

    }

    // Books number

    var booksCount: Int {
        get {
            let count: Int = self.books.count
            return count
        }
    }

    // Books number

    var tagsCount: Int {
        get {
            let count: Int = self.tags.count
            return count
        }
    }

    // Books in tag count
    // If not exists, return 0
    func bookCountForTag (tag: AGTTag?) -> Int {
        guard let count = library[tag!]?.count else {

                return 0
        }
        return count
    }


    // Array of books (AGTBooks) in tag
    // One book can be in one or more tags.
    // If tag hasn't books, return nil
    func booksForTag (tag: AGTTag?) -> [AGTBook] {
        var result = [AGTBook]()

        guard let tagString = tag,
            bookIndexes = library[tagString]
           // result = Array(library[tagString]!)
        else {
            return result

        }

        //return Array<Int>(booksSet)

        for bookIndex in bookIndexes {
            result.append(books[bookIndex])
        }

        return result

    }

    func book(atIndex index: Int, forTag agtTag: AGTTag) -> AGTBook {

        // Book at index position for tag
        let bookIndexes = library[agtTag]!
        let bookIndex = bookIndexes[index]

        return books[bookIndex]
    }

    @objc func favouriteDidChange(notification: NSNotification) {

        let info = notification.userInfo!

        let bookIndex = info[FavouriteKey] as! Int
        let favTag = AGTTag(tag: "favourites")

        if(library[favTag]!.contains(bookIndex)){
            // Delete

            if(library[favTag]?.count == 1){
                tags = tags.filter() { $0 != favTag }
            }

            // Set not fav to model
            books[bookIndex].favourite = false

            // Add to favourites tag
            library[favTag] = library[favTag]?.filter() { $0 != bookIndex }

            print("deleted fav to library \(bookIndex)")



        } else {
            // Insert

            if(library[favTag]?.count == 0){
                tags.append(favTag)

                // Order tags
                tags.sortInPlace({ $0 < $1 })
            }

            // Set fav to model
            books[bookIndex].favourite = true

            // Add to favourites tag
            library[favTag]!.append(bookIndex)

            print("added fav to library \(bookIndex)")
        }

        print("this is library[favTag]")
        print(library[favTag])
    }


}