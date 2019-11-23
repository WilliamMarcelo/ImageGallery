//
//  LoadingCollectionViewCell.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var messageButton: UIButton!

    var didTapRetryButton: (() -> Void)?

    override func awakeFromNib() {

        super.awakeFromNib()

        setInitialState()
    }

    override func prepareForReuse() {

        super.prepareForReuse()

        setInitialState()
    }

    func showError(error: Error) {

        let retry = "Tap to retry!!!"

        messageButton.isHidden = false
        messageButton.setTitle("\(error.localizedDescription)\n\(retry)", for: .normal)
        activityIndicator?.isHidden = true
    }
    
    @IBAction private func didTapRetryButton(sender: UIButton) {
        
        messageButton.isHidden = true
        activityIndicator?.isHidden = false
        didTapRetryButton?()
    }

    private func setInitialState() {

        activityIndicator?.startAnimating()
        messageButton.isHidden = true
        activityIndicator?.isHidden = false
    }
}

