//
//  Foundation.swift
//  HackerBooks
//
//  Created by Alicia Daza on 04/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation

extension NSBundle {
    func URLForResource(name: String?) -> NSURL? {
        let components = name?.componentsSeparatedByString(".")
        let fileTitle = components?.first
        let fileExtension = components?.last

        return URLForResource(fileTitle, withExtension: fileExtension)
    }
}