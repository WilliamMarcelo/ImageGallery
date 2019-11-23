//
//  UIViewController+Alert.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
