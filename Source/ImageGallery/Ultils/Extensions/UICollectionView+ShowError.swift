//
//  UICollectionView+ShowError.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func showError(viewController: UIViewController? = nil, error: Error, didTapRetryButton: @escaping () -> Void) {
        
        if let loadingCell = visibleCells.first(where: { collectionViewCell  in
            
            return collectionViewCell is LoadingCollectionViewCell
            
        }) as? LoadingCollectionViewCell {
            
            loadingCell.showError(error: error)
            loadingCell.didTapRetryButton = {
                
                didTapRetryButton()
            }
            
        } else {
            
            viewController?.showAlert(title: "Error", message: error.localizedDescription)
        }
    }
}
