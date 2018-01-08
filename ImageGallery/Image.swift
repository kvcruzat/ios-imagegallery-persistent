//
//  Image.swift
//  ImageGallery
//
//  Created by Khen Cruzat on 06/01/2018.
//  Copyright © 2018 Khen Cruzat. All rights reserved.
//

import Foundation

struct Image {
    
    var url: URL
    var ratio: Double
    
    init(imageUrl: URL, aspectRatio: Double){
        url = imageUrl
        ratio = aspectRatio
    }
}
