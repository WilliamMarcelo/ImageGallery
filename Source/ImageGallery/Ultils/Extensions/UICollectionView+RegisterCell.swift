//
//  UICollectionView+RegisterCell.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

extension UICollectionReusableView: ReusableView {}

enum SuplementaryViewKind: RawRepresentable {

    case header
    case footer

    init?(rawValue: String) {
        switch rawValue {
        case UICollectionView.elementKindSectionHeader:
            self = .header
        case UICollectionView.elementKindSectionFooter:
            self = .footer
        default:
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .header:
            return UICollectionView.elementKindSectionHeader
        case .footer:
            return UICollectionView.elementKindSectionFooter
        }
    }
}

// MARK: - Register Cells and Suplementary views
extension UICollectionView {

    func registerNib<T: UICollectionViewCell>(for cellClass: T.Type,
                                              in bundle: Bundle? = nil) {

        register(T.nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_ supplementaryViewClass: T.Type,
                                               forSupplementaryViewOfKind supplementaryViewOfKind: String) {

        register(supplementaryViewClass,
                 forSupplementaryViewOfKind: supplementaryViewOfKind,
                 withReuseIdentifier: T.reuseIdentifier)
    }

    func register<T: UICollectionReusableView>(_ supplementaryViewClass: T.Type,
                                               for supplementaryViewOfKind: SuplementaryViewKind) {
        register(supplementaryViewClass,
                 forSupplementaryViewOfKind: supplementaryViewOfKind.rawValue,
                 withReuseIdentifier: T.reuseIdentifier)
    }
}

// MARK: - Dequeue cells and supplementary views
extension UICollectionView {

    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {

        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: SuplementaryViewKind,
                                                                       for indexPath: IndexPath) -> T {

        return self.dequeueReusableSupplementaryView(ofKind: kind.rawValue,
                                                     withReuseIdentifier: T.reuseIdentifier,
                                                     for: indexPath) as! T
    }
}

