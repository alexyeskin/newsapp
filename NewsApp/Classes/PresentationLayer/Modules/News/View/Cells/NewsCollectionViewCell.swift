//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by Alexander Eskin on 11/13/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var newsTextView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var newsImageViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var newsTextHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.articleImageView.layer.cornerRadius = 10
    }
    
    var scaleMinimum: CGFloat = 0.9
    var scaleDivisor: CGFloat = 10.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scaleNewsImageView(withInset: 30.0)
        scaleNewsTextView(withInset: 30.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.articleImageView.transform = CGAffineTransform.identity
        self.newsTextView.transform = CGAffineTransform.identity
    }
    
    func scaleNewsImageView(withInset inset: CGFloat) {
        guard let superview = superview,
            let mainView = articleImageView else { return }
        
        let originX = superview.convert(frame, to: superview.superview).origin.x
        let originXActual = originX - inset
        let width = frame.size.width
        let scaleCalculator = abs(width - abs(originXActual))
        let percentageScale = (scaleCalculator / width)
        let scaleValue = scaleMinimum + (percentageScale / scaleDivisor)
        let affineIdentity = CGAffineTransform.identity
        mainView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
    }
    
    func scaleNewsTextView(withInset inset: CGFloat) {
        guard let superview = superview,
            let mainView = newsTextView else { return }
        
        let originX = superview.convert(frame, to: superview.superview).origin.x
        let originXActual = originX - inset
        let width = frame.size.width
        let scaleCalculator = abs(width - abs(originXActual))
        let percentageScale = (scaleCalculator / width)
        let scaleValue = 0.81 + (percentageScale / scaleDivisor)
        let affineIdentity = CGAffineTransform.identity
        mainView.transform = affineIdentity.scaledBy(x: scaleValue, y: scaleValue)
    }
}
