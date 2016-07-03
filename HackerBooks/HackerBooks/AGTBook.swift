//
//  AGTBook.swift
//  HackerBooks
//
//  Created by Alicia Daza on 03/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class AGTBoook {
    
    let title: String
    let authors: NSMutableArray
    let tags: NSMutableArray
    let image_url: NSURL
    let pdf_url: NSURL
    
    // MARK: - Initialization
    init(title: String, authors: NSMutableArray,
        tags: NSMutableArray, image_url: NSURL,
        pdf_url: NSURL) {
            
            self.title = title
            self.authors = authors
            self.tags = tags
            self.image_url = image_url
            self.pdf_url = pdf_url
    }
}
