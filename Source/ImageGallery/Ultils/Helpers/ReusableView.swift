//
//  ReusableView.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

public protocol ReusableView: class {

    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension ReusableView {

    public static var reuseIdentifier: String {

        return String(describing: self)
    }

    public static var nib: UINib {

        return UINib(nibName: self.reuseIdentifier, bundle: nil)
    }
}
