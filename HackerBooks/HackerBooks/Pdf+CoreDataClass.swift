//
//  Pdf+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData


public class Pdf: NSManagedObject {
    
    static let entityName = "Pdf"

    convenience init(book: Book, remoteUrl: String,
                     inContext context: NSManagedObjectContext) {
        // Get entity description
        let ent = NSEntityDescription.entity(forEntityName: Pdf.entityName,
                                             in: context)!
        
        // Call super
        self.init(entity: ent, insertInto: context)
        
        self.book = book
        self.remoteUrl = remoteUrl
    }
    
    convenience init(book: Book,
                     pdfData: NSData,
                     inContext context: NSManagedObjectContext) {
        
        let ent = NSEntityDescription.entity(forEntityName: Pdf.entityName,
                                             in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        // Add note
        self.book = book
        
        // Transform UIImage into data and set it
        self.pdfData = pdfData
        
    }
}
