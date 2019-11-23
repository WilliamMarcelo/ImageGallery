//
//  PagedResponseModel.swift
//  Marvel Character
//
//  Created by William on 11/3/19.
//  Copyright © 2019 William. All rights reserved.
//

import Foundation

class PagedResponseModel<T: Codable>: Codable {

    let currentPage: Int
    let totalPages: Int
    let results: [T]

    enum CodingKeys: String, CodingKey {

        case currentPage = "page"
        case totalPages = "pages"
        case results = "photo"
    }
}
