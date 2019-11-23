//
//  UIImageView+Download.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

extension UIImageView {
    
    private static let imageCache = NSCache<NSString, UIImage>()
    
    func setImage(with url: URL?, placeholder: UIImage?) {
        
        self.image = placeholder
        
        if let url = url {
            
            if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
                
                image = cachedImage

            } else {
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data) else {
                            
                            return
                    }

                    UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)

                    DispatchQueue.main.async() {
                        
                        self.image = image
                    }
                    
                }.resume()
            }
        }
    }
}
