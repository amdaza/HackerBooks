//
//  Foundation.swift
//  HackerBooks
//
//  Created by Alicia Daza on 04/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import Foundation

extension Bundle {
    func URLForResource(_ name: String?) -> URL? {
        let components = name?.components(separatedBy: ".")
        let fileTitle = components?.first
        let fileExtension = components?.last

        return url(forResource: fileTitle, withExtension: fileExtension)
    }
}
