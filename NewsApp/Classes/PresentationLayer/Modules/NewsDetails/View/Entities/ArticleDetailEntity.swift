//
//  ArticleDetailEntity.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/18/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation
import UIKit

enum ArticleDetailEntity {
    case imageDetail(String)
    case textDetail(String)
    case imageCaptionDetail(String)
    case headingDetail(String)
}

extension ArticleDetailEntity: Codable {
    private enum CodingKeys: CodingKey {
        case imageURL
        case textDetail
        case imageCaptionDetail
        case headingDetail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let url = try? container.decode(String.self, forKey: .imageURL) {
            self = .imageDetail(url)
            return
        }
        if let text = try? container.decode(String.self, forKey: .textDetail) {
            self = .textDetail(text)
            return
        }
        if let text = try? container.decode(String.self, forKey: .imageCaptionDetail) {
            self = .imageCaptionDetail(text)
            return
        }
        
        if let text = try? container.decode(String.self, forKey: .headingDetail) {
            self = .headingDetail(text)
            return
        }
        
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Data doesn't match"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .imageDetail(let url):
            try container.encode(url, forKey: .imageURL)
            
        case .textDetail(let text):
            try container.encode(text, forKey: .textDetail)
            
        case .imageCaptionDetail(let text):
            try container.encode(text, forKey: .imageCaptionDetail)
            
        case .headingDetail(let text):
            try container.encode(text, forKey: .headingDetail)
        }
    }
}
