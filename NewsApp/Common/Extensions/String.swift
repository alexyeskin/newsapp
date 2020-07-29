//
//  String.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/13/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

extension String {
    func strippingHTML() throws -> String? {
        if isEmpty {
            return nil
        }
        
        if let data = data(using: .utf8) {
            let attributedString = try NSAttributedString(data: data,
                                                          options: [
                                                            .documentType: NSAttributedString.DocumentType.html,
                                                            .characterEncoding: String.Encoding.utf8.rawValue
                                                            ],
                                                          documentAttributes: nil)
            let string = attributedString.string
            return string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return nil
    }
    
    func getImageURL() -> String {
        let range = NSRange(location: 0, length: self.utf16.count)
        guard let regEx = try? NSRegularExpression(pattern: "http.*?(.png|.jpg|.jpeg|.gif)", options: [.caseInsensitive]) else {
            return ""
        }
        guard let match = regEx.firstMatch(in: self, options: [], range: range) else {
            return ""
        }
        let matchRange = match.range
        let string = (self as NSString).substring(with: matchRange)
        
        return string
    }
}
