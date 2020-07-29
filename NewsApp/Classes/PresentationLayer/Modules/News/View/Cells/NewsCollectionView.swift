//
//  NewsCollectionView.swift
//  NewsApp
//
//  Created by Alexander Eskin on 11/15/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation
import UIKit

class NewsCollectionView: UICollectionView {
    var lastCurrentCenterCellIndex: IndexPath?
    
    var currentCenterCell: UICollectionViewCell? {
        let lowerBound = 30 - 20
        let upperBound = 30 + 20
        
        for cell in visibleCells {
            let cellRect = convert(cell.frame, to: nil)
            if Int(cellRect.origin.x) > lowerBound && Int(cellRect.origin.x) < upperBound {
                return cell
            }
        }
        return nil
    }
    
    var currentCenterCellIndex: IndexPath? {
        guard let currentCenterCell = self.currentCenterCell else {
            return nil
        }
        
        return indexPath(for: currentCenterCell)
    }
    
    var inset: CGFloat = 30.0 {
        didSet {
            configureLayout()
        }
    }
    
    override var contentSize: CGSize {
        didSet {
            guard let dataSource = dataSource,
                let invisibleScrollView = invisibleScrollView else { return }
            
            let numberSections = dataSource.numberOfSections?(in: self) ?? 1
            var numberItems = 0
            
            for i in 0..<numberSections {
                let numberSectionItems = dataSource.collectionView(self, numberOfItemsInSection: i)
                numberItems += numberSectionItems
            }
            let contentWidth = invisibleScrollView.frame.width * CGFloat(numberItems)
            invisibleScrollView.contentSize = CGSize(width: contentWidth, height: invisibleScrollView.frame.height)
        }
    }
    
    var invisibleScrollView: UIScrollView!
    var invisibleWidthConstraint: NSLayoutConstraint?
    var invisibleLeftConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(withFrame frame: CGRect, andInset inset: CGFloat) {
        self.init(frame: frame, collectionViewLayout: NewsCollectionViewLayout(withCarouselInset: inset))
        self.inset = inset
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        addInvisibleScrollView(to: superview)
    }
    
    func didScroll() {
        scrollViewDidScroll(self)
    }
    
    func didEndDecelerating() {
        scrollViewDidEndDecelerating(self)
    }
    
    func didEndDragging() {
        scrollViewDidEndDecelerating(self)
    }
}

private extension NewsCollectionView {
    func addInvisibleScrollView(to superview: UIView?) {
        guard let superview = superview else {
            return
        }
        
        invisibleScrollView = UIScrollView(frame: bounds)
        invisibleScrollView.translatesAutoresizingMaskIntoConstraints = false
        invisibleScrollView.isPagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        
        invisibleScrollView.isUserInteractionEnabled = true
        invisibleScrollView.delegate = self
        
        superview.addSubview(invisibleScrollView)
        
        invisibleScrollView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        invisibleScrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        configureLayout()
    }
    
    func configureLayout() {
        collectionViewLayout = NewsCollectionViewLayout(
            withCarouselInset: inset)
        
        guard let invisibleScrollView = invisibleScrollView else {
            return
        }
        invisibleWidthConstraint?.isActive = false
        invisibleLeftConstraint?.isActive = false
        invisibleWidthConstraint = invisibleScrollView.widthAnchor.constraint(
            equalTo: widthAnchor, constant: -(2 * inset))
        invisibleLeftConstraint = invisibleScrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: inset)
        invisibleWidthConstraint?.isActive = true
        invisibleLeftConstraint?.isActive = true
    }
}

extension NewsCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateOffSet()
        for cell in visibleCells {
            if let cell = cell as? NewsCollectionViewCell {
                cell.scaleNewsImageView(withInset: 30.0)
                cell.scaleNewsTextView(withInset: 30.0)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateOffSet()
    }
    
    private func updateOffSet() {
        contentOffset = self.invisibleScrollView.contentOffset
    }
}
