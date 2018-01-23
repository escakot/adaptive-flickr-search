//
//  Photo.swift
//  Adaptive Flickr Search
//
//  Created by Errol Cheong on 2018-01-23.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

import Foundation

struct Photo {
    var photoID: String?
    var server: String?
    var farm: Int16 = 0
    var owner: String?
    var secret: String?
    var title: String?
    
    var url: URL? {
        get {
            return URL(string: "https://farm\(farm).staticflickr.com/\(server ?? "")/\(photoID ?? "")_\(secret ?? "").jpg")
        }
    }
    
    init(data: [String: AnyObject]) {
        if let f = data["farm"] as? NSNumber {

            photoID = data["id"] as? String
            server = data["server"] as? String
            farm = f.int16Value
            owner = data["owner"] as? String
            secret = data["secret"] as? String
            title = data["title"] as? String
        }
    }
}
