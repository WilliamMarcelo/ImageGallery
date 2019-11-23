//
//  ImageGalleryViewModelDelegate.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

protocol ImageGalleryViewModelDelegate: class {
    
    func didSuccessGetItemsList()
    func didFailGetGetItemsList(error: Error)
}
