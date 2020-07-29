//
//  NewsCollectionViewLayout.swift
//  NewsApp
//
//  Created by Alexander Eskin on 11/15/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation
import UIKit

class NewsCollectionViewLayout: UICollectionViewFlowLayout {
    open var inset: CGFloat = 30.0
    
    convenience init(withCarouselInset inset: CGFloat = 30.0) {
        self.init()
        self.inset = inset
    }
    
    override open func prepare() {
        guard let collectionViewSize = collectionView?.frame.size else {
            return
        }
        
        itemSize = collectionViewSize
        itemSize.width -= (inset * 2)
        
        scrollDirection = .horizontal
        collectionView?.isPagingEnabled = true
        
        minimumLineSpacing = 0.0
        minimumInteritemSpacing = 0.0
        
        sectionInset = UIEdgeInsets(top: 0.0, left: inset, bottom: 0.0, right: inset)
        footerReferenceSize = CGSize.zero
        headerReferenceSize = CGSize.zero
    }
}
