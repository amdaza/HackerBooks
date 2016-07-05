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
func decode(agtBook json: JSONDictionary) throws -> AGTBook {
    
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

    
    if let title = json["title"] as? String {
        return AGTBook(title: title, authors: authors, tags: tags,
            image_url: imageUrl, pdf_url: pdfUrl)
    } else {
        throw HackerBooksError.wrongJSONFormat
    }
    
}


func decode(agtBook json: JSONDictionary?) throws -> AGTBook {
    
    if case .Some(let jsonDict) = json {
        return try decode(agtBook: jsonDict)
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