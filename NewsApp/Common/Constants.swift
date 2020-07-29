//
//  Constants.swift
//  NewsApp
//
//  Created by Alexander Eskin on 11/15/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    enum NewsSource {
        static let tutByURL = "https://news.tut.by/rss/index.rss"
        static let theVergeURL = "https://www.theverge.com/rss/index.xml"
    }
    
    enum NewsSourceName {
        static let tutby = "TUT.BY"
        static let theVerge = "TheVerge"
    }
    
    enum NewsSourceImageName {
        static let tutby = "tutbyLogo"
        static let theVerge = "vergeLogo"
    }
    
    enum Font {
        case text
        case heading
        case imageCaption
    }
    
    enum Color {
        case text
        case imageCaption
    }
    
    enum Keys {
        static let savedNews = "kSavedNews"
        static let currentLocation = "kLocation"
        static let savedLastArticle = "kSavedLastArticle"
        static let newsSource = "kNewsSource"
    }
    
    // MARK: - NewsModule Constants
    
    static let animationDuration = 0.3
    static let collectionViewInset: CGFloat = 30.0
    static let stackViewSpacing: CGFloat = 6.0
    static let warningImageViewWidth: CGFloat = 22.0
    static let warningImageViewHeight: CGFloat = 34.0
    
    // MARK: - NewsDetailsModule Constants
    
    static let minimumLabelTextCount = 20
    static let fastAnimationDuration = 0.15
    static let minimumContentOffsetForDismiss: CGFloat = -65
    static let articleDetailsImageCornerRadius: CGFloat = 8.0
    static let articleImageViewCornerRadius: CGFloat = 20.0
    static let articleImageViewHeightMultiplier: CGFloat = 0.59
    static let imageViewInset: CGFloat = 30.0
    
    // MARK: - General Constants
    
    static let labelLineSpacing: CGFloat = 11.0
}

enum NetworkError: Error {
    case badURL
    case badConnection
    case mappingError
}

enum LocationError: Error {
    case denied
    case notFound
    case badConnection
}

enum NotificationError: Error {
    case registrationError
    case sendingError
}

enum StorageError: Error {
    case empty
}

extension Constants.Font: RawRepresentable {
    typealias RawValue = UIFont
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case R.font.sfProDisplayRegular(size: 18.0):
            self = .text
            
        case R.font.sfProDisplayHeavy(size: 21.0):
            self = .heading
            
        case UIFont.systemFont(ofSize: 15, weight: .light):
            self = .imageCaption
            
        default:
            return nil
        }
    }
    
    var rawValue: RawValue {
        switch self {
        case .text:
            return R.font.sfProDisplayRegular(size: 18.0) ?? UIFont.systemFont(ofSize: 18.0)
            
        case .heading:
            return R.font.sfProDisplayHeavy(size: 21.0) ?? UIFont.systemFont(ofSize: 21.0)
            
        case .imageCaption:
            return UIFont.systemFont(ofSize: 15, weight: .light)
        }
    }
}

extension Constants.Color: RawRepresentable {
    typealias RawValue = UIColor
    
    init?(rawValue: RawValue) {
        switch rawValue {
        case R.color.app():
            self = .text
            
        case R.color.imageCaption():
            self = .imageCaption
            
        default:
            return nil
        }
    }
    
    var rawValue: UIColor {
        switch self {
        case .text:
            return R.color.text() ?? UIColor(red: 0.63, green: 0.65, blue: 0.71, alpha: 1.0)
            
        case .imageCaption:
            return R.color.imageCaption() ?? UIColor(red: 0.63, green: 0.65, blue: 0.71, alpha: 0.97)
        }
    }
}
