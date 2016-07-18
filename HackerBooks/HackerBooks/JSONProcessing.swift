//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Alicia Daza on 04/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Aliases
typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]

// MARK: - Decodification
func decode(agtBook json: JSONDictionary, defaultImage defImage: UIImage) throws -> AGTBook {

    // Validate dictionary
    guard let imageString = json["image_url"] as? String,
        imageUrl = NSURL(string: imageString) else {
            throw HackerBooksError.wrongURLFormatForJSONResource
    }

    guard let pdfString = json["pdf_url"] as? String,
        pdfUrl = NSURL(string: pdfString) else {
            throw HackerBooksError.wrongURLFormatForJSONResource
    }


    guard let authorsString = json["authors"] as? String

    else {
        throw HackerBooksError.wrongURLFormatForJSONResource
    }
    let authors = authorsString.componentsSeparatedByString(", ")


    guard let tagsString = json["tags"] as? String

    else {
        throw HackerBooksError.wrongURLFormatForJSONResource
    }
    let tags = tagsString.componentsSeparatedByString(", ")


    let asyncImage = AsyncImage(remoteUrl: imageUrl, defaultImage: defImage)

    // CHANGE FAVOURITE
    if let title = json["title"] as? String {
        return AGTBook(title: title, authors: authors, tags: tags,
            image_url: imageUrl, pdf_url: pdfUrl, favourite: false,
            image: asyncImage)
    } else {
        throw HackerBooksError.wrongJSONFormat
    }

}


func decode(agtBook json: JSONDictionary?) throws -> AGTBook {

    if case .Some(let jsonDict) = json{
        if let defaultImage = defaultImageSyncDownload(){

            return try decode(agtBook: jsonDict, defaultImage: defaultImage)

        } else {
            throw HackerBooksError.missingDefaultImage
        }

    } else {
        throw HackerBooksError.nilJSONObject
    }

}


// MARK: - Loading
func loadFromLocalFile(fileName name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray {

    if let url = bundle.URLForResource(name),
        data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray,
        array = maybeArray {

            return array

    } else {
        throw HackerBooksError.jsonParsingError
    }
}



func getJSON(remoteUrl url: String) throws -> JSONArray {
    if let jsonUrl = NSURL(string: url),

    // Get Documents url
    let documentsUrl = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first, // First because it returns an array

    // Get json filename
    let jsonFileName = jsonUrl.lastPathComponent {

        let destination = documentsUrl.URLByAppendingPathComponent(jsonFileName)

        // Check if file exists before downloading it
        if destination.path != nil
            && NSFileManager().fileExistsAtPath(destination.path!) {
            // File exists at path

            if let data = NSData(contentsOfURL: destination){

                return try getJSONArray(fromData: data)

            } else {
                throw HackerBooksError.jsonParsingError
            }

        } else {
            // File doesn't exists. Download from url

            if let data = NSData(contentsOfURL: jsonUrl) {
                data.writeToURL(destination, atomically: true)

                return try getJSONArray(fromData: data)

            } else {
                throw HackerBooksError.jsonDownloadingError
            }

        }
    } else {
        throw HackerBooksError.resourcePointedByUrLNotReachable
    }

}


func getJSONArray(fromData data: NSData) throws -> JSONArray {
    if let maybeArray = try? NSJSONSerialization.JSONObjectWithData(data,
        options: NSJSONReadingOptions.MutableContainers) as? JSONArray,

        array = maybeArray {

            return array

    } else {
        throw HackerBooksError.jsonParsingError
    }
}


func defaultImageSyncDownload() -> UIImage? {
    let imageName = "book-default.png"
    if let url = NSBundle.mainBundle().URLForResource(imageName),
        let data = NSData(contentsOfURL: url),
        let image = UIImage(data: data) {

            return image
    }
    return nil
}


