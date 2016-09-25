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
        
    }
    
    convenience init(note: Note, inContext context: NSManagedObjectContext) {
        let ent = NSEntityDescription.entity(forEntityName: Photo.entityName, in: context)!
        
        self.init(entity: ent, insertInto: context)
        addToNotes(note)
    }
    
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
