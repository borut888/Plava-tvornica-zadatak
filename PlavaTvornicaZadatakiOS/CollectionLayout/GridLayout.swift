//
//  GridLayout.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2016. 11. 01..
//  Copyright © 2016. Sabminder. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {

    var myCollection = ViewController()
    var numberOfColumns: Int = 1
    init(numberOfColumns: Int) {
        super.init()
       // minimumInteritemSpacing = 1
        sectionInset = UIEdgeInsets(top: 20, left: 35, bottom: 10, right: 35)
        self.numberOfColumns = numberOfColumns
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                sectionInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            case 1920, 2208:
                sectionInset = UIEdgeInsets(top: 10, left: 55, bottom: 10, right: 55)
            default:
                print("unknown")
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var itemSize: CGSize {
        get {
                let itemWidth: CGFloat = 147
                let itemHeight: CGFloat = 150
                return CGSize(width: itemWidth, height: itemHeight)
        }
        set {
            super.itemSize = newValue
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
}
