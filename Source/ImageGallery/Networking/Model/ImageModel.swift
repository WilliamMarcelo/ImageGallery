//
//  ImageModel.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

struct ImageModel: Codable {

    let identifier: String
    let secret: String
    let server: String

    var largeSquareImageURL: URL? {
        
        return URL(string: "https://live.staticflickr.com/\(server)/\(identifier)_\(secret)_q.jpg")
    }

    var largeImageURL: URL? {
        
        return  URL(string: "https://live.staticflickr.com/\(server)/\(identifier)_\(secret)_b.jpg")
    }

    enum CodingKeys: String, CodingKey {
        
        case identifier = "id"
        case secret = "secret"
        case server = "server"
    }
}
