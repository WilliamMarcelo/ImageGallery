//
//  NSError+Message.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import Foundation

extension NSError {

    static func buildError(domain: String,
                           code: Int,
                           title: String,
                           description: String,
                           comment: String = "") -> NSError {

        let userInfo = [NSLocalizedDescriptionKey: NSLocalizedString(title,
                                                                     value: description,
                                                                     comment: comment),
                        NSLocalizedFailureReasonErrorKey: NSLocalizedString(title,
                                                                            value: description,
                                                                            comment: comment)]
        return NSError(domain: domain, code: code, userInfo: userInfo)
    }
}
