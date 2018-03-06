//
//  ListLayout.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2016. 11. 26..
//  Copyright © 2016. Sabminder. All rights reserved.
//

import UIKit

class ListLayout: UICollectionViewFlowLayout {

    var itemHeight: CGFloat = 150

    init(itemHeight: CGFloat) {
        super.init()
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0

        self.itemHeight = itemHeight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var itemSize: CGSize {
        get {
            if let collectionView = collectionView {
                let itemWidth: CGFloat = collectionView.frame.width
                return CGSize(width: itemWidth, height: self.itemHeight)
            }

            // Default fallback
            return CGSize(width: 400, height: 200)
        }
        set {
            super.itemSize = newValue
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
}
