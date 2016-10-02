//
//  JSONProcessing.swift
//  HackerBooks
//
//  Created by Alicia Daza on 04/07/16.
//  Updated to V2 by Alicia Daza on 02/10/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - Aliases
typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]

// MARK: - Decodification
func decode(jsonDict: JSONDictionary,
            defaultImage defImage: NSData,
            defaultPdf defPdf: NSData,
            context: NSManagedObjectContext) throws {
    
    let book: Book

    // Validate dictionary
    guard let imageString = jsonDict["image_url"] as? String,
        let imageUrl : URL = URL(string: imageString) else {
            throw HackerBooksError.wrongURLFormatForJSONResource
    }

    guard let pdfString = jsonDict["pdf_url"] as? String,
        let pdfUrl = URL(string: pdfString) else {
            throw HackerBooksError.wrongURLFormatForJSONResource
    }


    //let asyncImage = AsyncImage(remoteUrl: imageUrl, defaultImage: defImage)

    
    if let title = jsonDict["title"] as? String {
        book = Book(title: title,
            imageUrl: imageString, pdfUrl: pdfString,
            image: defImage, pdf: defPdf,
            favourite: false,
            inContext: context)
        
    } else {
        throw HackerBooksError.wrongJSONFormat
    }
    
    
    guard let authorsString = jsonDict["authors"] as? String
        
        else {
            throw HackerBooksError.wrongURLFormatForJSONResource
    }
    let authors = authorsString.components(separatedBy: ", ")
    
    for authorName in authors {
        let author = Author.getOrInsert(withName: authorName,
                                        inContext: context)
        book.addToAuthors(author)
    }
    
    
    guard let tagsString = jsonDict["tags"] as? String
        
        else {
            throw HackerBooksError.wrongURLFormatForJSONResource
    }
    let tags = tagsString.components(separatedBy: ", ")
    
    for tagName in tags {
        
        book.addTag(tagName: tagName, inContext: context)
    }
}


func decode(jsonDict: JSONDictionary?,
            context: NSManagedObjectContext) throws {

    if case .some(let jsonDict) = jsonDict{
        if let defaultImage = defaultImageSyncDownload(),
            let defaultPdf = defaultPdfSyncDownload(){

            try decode(jsonDict: jsonDict,
                              defaultImage: defaultImage as NSData,
                              defaultPdf: defaultPdf as NSData,
                              context: context)

        } else {
            throw HackerBooksError.missingDefaultImage
        }

    } else {
        throw HackerBooksError.nilJSONObject
    }

}


// MARK: - Loading
func loadFromLocalFile(fileName name: String, bundle: Bundle = Bundle.main) throws -> JSONArray {

    if let url = bundle.URLForResource(name),
        let data = try? Data(contentsOf: url),
        let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,
        let array = maybeArray {

            return array

    } else {
        throw HackerBooksError.jsonParsingError
    }
}



func getJSON(remoteUrl url: String) throws -> JSONArray {
    if let jsonUrl = URL(string: url),

    // Get Documents url
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{ // First because it returns an array

    // Get json filename
    let jsonFileName = jsonUrl.lastPathComponent //{

        let destination = documentsUrl.appendingPathComponent(jsonFileName)

        // Check if file exists before downloading it
        if /*destination.path != nil
            &&*/ FileManager().fileExists(atPath: destination.path) {
            // File exists at path

            if let data = try? Data(contentsOf: destination){

                return try getJSONArray(fromData: data)

            } else {
                throw HackerBooksError.jsonParsingError
            }

        } else {
            // File doesn't exists. Download from url

            if let data = try? Data(contentsOf: jsonUrl) {
                try? data.write(to: destination, options: [.atomic])

                return try getJSONArray(fromData: data)

            } else {
                throw HackerBooksError.jsonDownloadingError
            }

        }
    } else {
        throw HackerBooksError.resourcePointedByUrLNotReachable
    }

}


func getJSONArray(fromData data: Data) throws -> JSONArray {
    if let maybeArray = try? JSONSerialization.jsonObject(with: data,
        options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray,

        let array = maybeArray {

            return array

    } else {
        throw HackerBooksError.jsonParsingError
    }
}


func defaultImageSyncDownload() -> Data? {
    let imageName = "book-default.png"
    if let url = Bundle.main.URLForResource(imageName),
        let data = try? Data(contentsOf: url),
        let _ = UIImage(data: data) {

            return data
    }
    return nil
}

func defaultPdfSyncDownload() -> Data? {
    let pdfName = "defaultPdf.pdf"
    if let url = Bundle.main.URLForResource(pdfName),
        let data = try? Data(contentsOf: url){
        
        return data
    }
    return nil
}

