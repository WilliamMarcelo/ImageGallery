//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

class ImageGalleryViewModel: ImageGalleryViewModelProtocol {
    
    private let networkingService = NetworkingService<PagedResponseModel<ImageModel>>()

    weak var delegate: ImageGalleryViewModelDelegate?

    var items: [ImageModel] = []
    var isLoading = false
    var totalPages = 0
    var currentPage = 0
    var tag: String?

    var hasMoreContentToLoad: Bool {
        
        return currentPage < totalPages && totalPages > 0
    }
    
    var itemsCount: Int {
        
        return items.count
    }

    required init(delegate: ImageGalleryViewModelDelegate) {
        
        self.delegate = delegate
    }
    
    func getItems(tag: String?) {
        
        self.tag = tag
        fetchItemsList(refresh: true, tag: tag)
    }
    
    func getMoreItems() {
        
        if hasMoreContentToLoad {
            
            fetchItemsList(tag: tag)
        }
    }
    
    func getItem(at index: Int) -> ImageModel {
        
        return items[index]
    }
    
    private func fetchItemsList(refresh: Bool = false, tag: String?) {
        
        if !isLoading {
            
            isLoading = true
            currentPage = refresh ? 0 : currentPage
            
            let getImages = NetworkingRequestManager.getImages(page: currentPage, tag: tag)

            networkingService.getItens(networkingRequestManager: getImages,
                                       onSuccess: { pagedResponse in
                                        
                                        self.currentPage += pagedResponse.currentPage
                                        self.totalPages = pagedResponse.totalPages
                                        
                                        if refresh {
                                            
                                            self.items = pagedResponse.results
                                            
                                        } else {
                                            
                                            self.items.append(contentsOf: pagedResponse.results)
                                        }
                                        
                                        self.isLoading = false
                                        self.delegate?.didSuccessGetItemsList()

            }, onError: {error in
                
                self.isLoading = false
                self.delegate?.didFailGetGetItemsList(error: error)
            })
        }
    }
}
