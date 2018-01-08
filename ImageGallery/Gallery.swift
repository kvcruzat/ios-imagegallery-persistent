//
//  Gallery.swift
//  Gallery
//
//  Created by Khen Cruzat on 08/01/2018.
//  Copyright © 2018 Khen Cruzat. All rights reserved.
//

import Foundation

struct Gallery: Codable {
    
    var gallery = [Image]()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(Gallery.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(gallery: [Image]) {
        self.gallery = gallery
    }
}
