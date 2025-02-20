//
//  CollectionViewLeftAlignFlowLayout.swift
//  ImageGallery
//
//  Created by William Gomes on 23/11/2019.
//  Copyright © 2019 William Gomes. All rights reserved.
//

import UIKit

class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {

    var delegate: UICollectionViewDelegateFlowLayout? {

        return self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        guard let attributesCollection = super.layoutAttributesForElements(in: rect) else {

            return nil
        }

        var updatedAttributes = [UICollectionViewLayoutAttributes]()

        attributesCollection.forEach({ originalAttributes in

            guard originalAttributes.representedElementKind == nil else {

                updatedAttributes.append(originalAttributes)
                return
            }

            if let updatedAttribute = self.layoutAttributesForItem(at: originalAttributes.indexPath) {

                updatedAttributes.append(updatedAttribute)
            }
        })

        return updatedAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy()

            as? UICollectionViewLayoutAttributes else {
            return nil
        }

        guard let collectionView = self.collectionView else {

            return attributes
        }

        let firstInSection: Bool = indexPath.item == 0

        guard !firstInSection else {

            let section = attributes.indexPath.section
            let x = delegate?.collectionView?(collectionView,
                                              layout: self,
                                              insetForSectionAt: section).left ?? sectionInset.left
            attributes.frame.origin.x = x
            return attributes
        }

        let previousAttributes = self.layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1,
                                                                            section: indexPath.section))
        let previousFrame: CGRect = previousAttributes?.frame ?? CGRect()
        let firstInRow = previousAttributes?.center.y != attributes.center.y

        guard !firstInRow else {

            let section = attributes.indexPath.section
            let x = delegate?.collectionView?(collectionView,
                                              layout: self,
                                              insetForSectionAt: section).left ?? sectionInset.left
            attributes.frame.origin.x = x
            return attributes
        }

        let interItemSpacing: CGFloat = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
            .collectionView?(collectionView,
                             layout: self,
                             minimumInteritemSpacingForSectionAt: indexPath.section) ?? self.minimumInteritemSpacing

        let x = previousFrame.origin.x + previousFrame.width + interItemSpacing
        attributes.frame = CGRect(x: x,
                                  y: attributes.frame.origin.y,
                                  width: attributes.frame.width,
                                  height: attributes.frame.height)

        return attributes
    }
}

