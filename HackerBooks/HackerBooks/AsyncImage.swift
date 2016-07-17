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
    let url: NSURL
    var loaded: Bool

    init(remoteUrl url: NSURL, defaultImage image: UIImage){
        self.url = url
        self.image = image
        self.loaded = false
    }

    func downloadImage() {

        let queue = dispatch_queue_create("downloadImages", nil)

        dispatch_async(queue) {
            if let data = NSData(contentsOfURL: self.url),
                let img = UIImage(data: data){

                dispatch_async(dispatch_get_main_queue()) {
                    self.image = img
                    self.loaded = true

                    // Notify
                    let nc = NSNotificationCenter.defaultCenter()
                    let notif = NSNotification(name: ImageDidChangeNotification, object: self,
                        userInfo: [ImageKey: self.url.path!])

                    nc.postNotification(notif)
                }
            } else {
                //throw HackerBooksError.resourcePointedByUrLNotReachable
            }
        }

        /*
        let request = NSURLRequest(URL: url)
        //let mainQueue = NSOperationQueue.mainQueue()

        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (dataRes, response, error) -> Void in
            if (error == nil),
            let data = dataRes,
            let img = UIImage(data: data) {
                self.image = img
                self.loaded = true

                // Notify
            } else {
                //throw HackerBooksError.resourcePointedByUrLNotReachable
            }

        })
        */
        /*
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue,
            completionHandler: { (response, dataRes, error) -> Void in
                if (error == nil),
                let data = dataRes,
                let img = UIImage(data: data) {
                    self.image = img
                    self.loaded = true

                   // Notify
                } else {
                    //throw HackerBooksError.resourcePointedByUrLNotReachable
                }


        })*/

    }

    func getImage() {
        if (!loaded) {

            // Get cache url
            if let cacheUrl = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory,
                inDomains: .UserDomainMask).first, // First because it returns an array

            // Get image filename
            let imageFileName = url.lastPathComponent {

                let destination = cacheUrl.URLByAppendingPathComponent(imageFileName)

                // Check if image exists before downloading it
                if destination.path != nil &&
                    NSFileManager().fileExistsAtPath(destination.path!) {

                    // File exists at path

                    if let data = NSData(contentsOfURL: destination) {
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