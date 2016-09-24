//
//  AsyncData.swift
//  HackerBooks
//
//  Created by Alicia on 24/9/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import UIKit

let DataDidChangeNotification = "Async data did change"
let DataKey = "dataKey"

class AsyncData {
    
    var data: Data
    let url: URL
    var loaded: Bool
    
    init(remoteUrl url: URL, defaultData data: Data){
        self.url = url
        self.data = data
        self.loaded = false
    }
    
    func downloadData() {
        
        let queue = DispatchQueue(label: "downloadData", attributes: [])
        
        queue.async {
            if let data = try? Data(contentsOf: self.url){
                
                DispatchQueue.main.async {
                    self.data = data
                    self.loaded = true
                    
                    // Notify
                    let nc = NotificationCenter.default
                    let notif = Notification(name: Notification.Name(rawValue: DataDidChangeNotification), object: self,
                                             userInfo: [DataKey: self.url.path])
                    
                    nc.post(notif)
                }
            } else {
                //throw HackerBooksError.resourcePointedByUrLNotReachable
            }
        }
    }
    
    func getData() {
        if (!loaded) {
            
            // Get cache url
            if let cacheUrl = FileManager.default.urls(for: .cachesDirectory,
                                                       in: .userDomainMask).first{ // First because it returns an array
                
                // Get Data filename
                let dataFileName = url.lastPathComponent //{
                
                let destination = cacheUrl.appendingPathComponent(dataFileName)
                
                // Check if image exists before downloading it
                if FileManager().fileExists(atPath: destination.path) {
                    
                    // File exists at path
                    
                    if let data = try? Data(contentsOf: destination) {
                        self.data = data
                    }
                } else {
                    // File doesn't exists. Download
                    downloadData()
                }
            }
            
        }
    }
    
}

