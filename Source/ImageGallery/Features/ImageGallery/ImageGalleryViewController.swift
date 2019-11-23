//
//  ViewController.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController {
    
    let networkingService = NetworkingService<PagedResponseModel<ImageModel>>()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        networkingService.getItens(networkingRequestManager: .getImages(page: 1, tag: "kittens"),
                                   onSuccess: { pagedResponse in
               
                                    debugPrint(pagedResponse.results.first?.largeImageURL)
        }, onError: { error in
            
            debugPrint(error)
        })
    }
}
