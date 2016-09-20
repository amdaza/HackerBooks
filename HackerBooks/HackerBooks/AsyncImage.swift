//
//  AsyncImage.swift
//  HackerBooks
//
//  Created by Alicia Daza on 16/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

let ImageDidChangeNotification = "Book image did change"
let ImageKey = "imageKey"

class AsyncImage {

    var image: UIImage?
    let url: URL
    var loaded: Bool

    init(remoteUrl url: URL, defaultImage image: UIImage){
        self.url = url
        self.image = image
        self.loaded = false
    }

    func downloadImage() {

        let queue = DispatchQueue(label: "downloadImages", attributes: [])

        queue.async {
            if let data = try? Data(contentsOf: self.url),
                let img = UIImage(data: data){

                DispatchQueue.main.async {
                    self.image = img
                    self.loaded = true

                    // Notify
                    let nc = NotificationCenter.default
                    let notif = Notification(name: Name(rawValue: ImageDidChangeNotification), object: self,
                        userInfo: [ImageKey: self.url.path!])

                    nc.post(notif)
                }
            } else {
                //throw HackerBooksError.resourcePointedByUrLNotReachable
            }
        }
    }

    func getImage() {
        if (!loaded) {

            // Get cache url
            if let cacheUrl = FileManager.default.urls(for: .cachesDirectory,
                in: .userDomainMask).first, // First because it returns an array

            // Get image filename
            let imageFileName = url.lastPathComponent {

                let destination = cacheUrl.appendingPathComponent(imageFileName)

                // Check if image exists before downloading it
                if destination.path != nil &&
                    FileManager().fileExists(atPath: destination.path!) {

                    // File exists at path

                    if let data = try? Data(contentsOf: destination) {
                        self.image = UIImage(data: data)
                    }
                } else {
                    // File doesn't exists. Download
                    downloadImage()
                }
            }

        }
    }

}
