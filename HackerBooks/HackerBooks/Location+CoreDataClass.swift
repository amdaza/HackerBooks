//
//  Location+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData


public class Location: NSManagedObject {
    
    static let entityName = "Location"
    
    convenience init(latitude: Double, longitude: Double,
                     inContext context: NSManagedObjectContext) {
        // Get entity description
        let ent = NSEntityDescription.entity(forEntityName: Location.entityName,
                                             in: context)!
        
        // Call super
        self.init(entity: ent, insertInto: context)
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    convenience init(note: Note,
            latitude: Double, longitude: Double,
            inContext context: NSManagedObjectContext) {
        // Get entity description
        let ent = NSEntityDescription.entity(forEntityName: Location.entityName,
                                             in: context)!
        
        // Call super
        self.init(entity: ent, insertInto: context)
        
        self.addToNotes(note)
        self.latitude = latitude
        self.longitude = longitude
    }
}
