//
//  ImageGalleryViewModelProtocol.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

protocol ImageGalleryViewModelProtocol {
    
    var items: [ImageModel] { get }
    var isLoading: Bool { get }
    var totalPages: Int { get }
    var currentPage: Int { get }
    var tag: String? { get }
    var hasMoreContentToLoad: Bool { get }
    var itemsCount: Int { get }
    var delegate: ImageGalleryViewModelDelegate? { get }

    init(delegate: ImageGalleryViewModelDelegate)

    func getItems(tag: String?)
    func getMoreItems()
    func getItem(at index: Int) -> ImageModel
}
