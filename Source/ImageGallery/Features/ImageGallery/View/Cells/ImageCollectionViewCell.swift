//
//  ImageCollectionViewCell.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!

    func configureCell(with imageModel: ImageModel) {

        thumbnailImageView.setImage(with: imageModel.largeSquareImageURL, placeholder: Asset.placeholder)
    }
    
    override func prepareForReuse() {
        
        thumbnailImageView.image = nil
    }
}
