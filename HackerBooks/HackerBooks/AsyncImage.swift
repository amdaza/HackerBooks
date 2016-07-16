//
//  AsyncImage.swift
//  HackerBooks
//
//  Created by Alicia Daza on 16/07/16.
//  Copyright © 2016 Alicia Daza. All rights reserved.
//

import UIKit

class AsyncImage {
    
    let image: UIImage?
    let url: NSURL
    
    init(remoteUrl url: NSURL, defaultImage image: UIImage){
        self.url = url
        self.image = image
    }
    
}