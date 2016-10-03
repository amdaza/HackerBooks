//
//  Photo+CoreDataClass.swift
//  HackerBooks
//
//  Created by Home on 22/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc
public class Photo: NSManagedObject {
    
    static let entityName = "Photo"
    
    
    // MARK: - Computed properties
    var image : UIImage? {
        get {
            guard let data = photoData else {
                return nil
            }
            return UIImage(data: data as Data)!
        }
        
        set {
            guard let img = newValue else {
                photoData = nil
                return
            }
            photoData = UIImageJPEGRepresentation(img, 0.9) as NSData?
        }
    }
    
    // MARK: - Convenience inits for Notes
    convenience init(note: Note,
                     image: UIImage,
                     inContext context: NSManagedObjectContext) {
        
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName,
                                             in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        // Add note
        addToNotes(note)
        
        // Transform UIImage into data and set it
        self.image = image
        self.loaded = false
        
    }
    
    convenience init(note: Note, inContext context: NSManagedObjectContext) {
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        self.addToNotes(note)
        self.loaded = false
    }
    
    // MARK: - Convenience inits for books
    convenience init(book: Book,
                     remoteUrl: String,
                     inContext context: NSManagedObjectContext) {
        // Get entity description
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName,
                                             in: context)!
        
        // Call super
        self.init(entity: ent, insertInto: context)
        
        self.addToBooks(book)
        self.remoteUrl = remoteUrl
        self.loaded = false
    }
    
    convenience init(book: Book,
                     remoteUrl: String,
                     image: UIImage,
                     inContext context: NSManagedObjectContext) {
        
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName,
                                             in: context)!
        
        self.init(entity: ent, insertInto: context)
        
        // Add Pdf
        self.addToBooks(book)
        self.remoteUrl = remoteUrl
        self.image = image
        self.loaded = false
        
    }
    
    // MARK: Static get & update functions for Book
    
    // Get Photo if exists, nil if it doesn't
    public static func getIfExists(remoteUrl: String,
                                   inContext context: NSManagedObjectContext) -> Photo? {
        
        // Check if Pdf already exists
        let req = NSFetchRequest<Photo>(entityName: Photo.entityName)
        req.predicate = NSPredicate(format: "remoteUrl == %@", remoteUrl)
        
        if let result = try? context.fetch(req),
            result.count > 0 {
            
            return result.first!
        } else {
            return nil
        }
    }
    
    // Get or insert
    // Get if exist, insert if it doesn't
    // Return created or updated Photo
    public static func getOrInsert(book: Book,
                                   remoteUrl: String,
                                   inContext context: NSManagedObjectContext) -> Photo {
        
        guard let photo = Photo.getIfExists(remoteUrl: remoteUrl,
                                     inContext: context) else {

            // Create Photo
            return Photo(book: book,
                       remoteUrl: remoteUrl,
                       inContext: context)
        }
        
        // Already exists, return
        return photo
    }
    
    // Get or insert with image
    // Get if exist, insert if it doesn't
    // Return created or updated Photo
    public static func getOrInsert(book: Book,
                                   remoteUrl: String,
                                   image: UIImage,
                                   inContext context: NSManagedObjectContext) -> Photo {
        
        guard let photo = Photo.getIfExists(remoteUrl: remoteUrl,
                                            inContext: context) else {
                                                
                                                // Create Photo
                                                return Photo(book: book,
                                                             remoteUrl: remoteUrl,
                                                             image: image,
                                                             inContext: context)
        }
        
        // Already exists, return
        return photo
    }
    
    // MARK: - Get Async Data
    
    func downloadImage() {
        
        let queue = DispatchQueue(label: "downloadData", attributes: [])
        
        queue.async {
            if let url = URL(string: self.remoteUrl!),
                let data = try? Data(contentsOf: url),
                let img = UIImage(data: data){
                
                DispatchQueue.main.async {
                    self.image = img
                    self.loaded = true
                   /*
                    // Notify
                    let nc = NotificationCenter.default
                    let notif = Notification(name: Notification.Name(rawValue: ImageDidChangeNotification), object: self,
                                             userInfo: [ImageKey: self.remoteUrl.path])
                    
                    nc.post(notif)
                    */
                }
            } else {
                //throw HackerBooksError.resourcePointedByUrLNotReachable
    
            }
        }
    }
    
    func getImage() {
        if (!loaded) {
            
            // File doesn't exists. Download
            downloadImage()
            
            
        }
    }

}
