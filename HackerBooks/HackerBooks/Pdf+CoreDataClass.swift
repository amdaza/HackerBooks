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
        self.loaded = false
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
        self.loaded = false
        
    }
    
    func downloadPdf() {
        
        let queue = DispatchQueue(label: "downloadData", attributes: [])
        
        queue.async {
            if let url = URL(string: self.remoteUrl!),
                let data = try? Data(contentsOf: url) {
                
                DispatchQueue.main.async {
                    self.pdfData = NSData(data: data)
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
    
    func getPdf() {
        if (!loaded) {
            
            // File doesn't exists. Download
            downloadPdf()
            
            
        }
    }
}
