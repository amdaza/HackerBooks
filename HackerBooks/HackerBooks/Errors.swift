//
//  Errors.swift
//  HackerBooks
//
//  Created by Alicia Daza on 04/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation

// MARK: JSON Errors
enum HackerBooksError : Error {
    case wrongURLFormatForJSONResource
    case resourcePointedByUrLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
    case jsonDownloadingError
    case missingDefaultImage
}
