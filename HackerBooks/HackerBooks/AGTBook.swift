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
    let image_url: URL
    let pdf_url: URL
    var favourite: Bool
    let image: AsyncImage
    var index: Int

    // MARK: - Computed properties
    var authorsDescription: String {
        get {
            return "Authors: " + authors.joined(separator: ", ")
        }
    }

    var tagsText: String {
        get {
            let capTags = tags.map({"\n -> " + $0.capitalized})
            return capTags.joined(separator: "\n")
        }
    }

    // MARK: - Initialization
    init(title: String, authors: [String],
        tags: [String], image_url: URL,
        pdf_url: URL, favourite: Bool,
        image: AsyncImage) {

            self.title = title
            self.authors = authors
            self.tags = tags
            self.image_url = image_url
            self.pdf_url = pdf_url
            self.favourite = favourite
            self.image = image
            self.index = 0
    }

    //MARK: - Proxies
    var proxyForComparison : String{
        get {
            return "\(title)\(image_url)\(pdf_url)"
        }
    }

    func syncDownload(_ imageUrl: URL) -> UIImage? {
        if let data = try? Data(contentsOf: imageUrl) {
            return UIImage(data: data)
        }
        return nil
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
    return lhs.title.lowercased() < rhs.title.lowercased()
}

