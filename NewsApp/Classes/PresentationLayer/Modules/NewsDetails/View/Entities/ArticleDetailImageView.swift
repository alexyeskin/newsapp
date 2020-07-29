//
//  NewsDetailImageVIew.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/6/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

class ArticleDetailImageView: UIImageView {
    override open var intrinsicContentSize: CGSize {
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            let ratio = myViewWidth / myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: 0, height: 0)
    }
}
