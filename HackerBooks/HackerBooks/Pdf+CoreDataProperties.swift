//
//  Pdf+CoreDataProperties.swift
//  HackerBooks
//
//  Created by Home on 5/10/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData

extension Pdf {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pdf> {
        return NSFetchRequest<Pdf>(entityName: "Pdf");
    }

    @NSManaged public var loaded: Bool
    @NSManaged public var pdfData: NSData?
    @NSManaged public var remoteUrl: String?
    @NSManaged public var book: Book?

}
