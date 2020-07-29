//
//  NetworkCore.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/16/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import FeedKit
import Foundation

protocol NetworkCore {
    func loadNews(from stringURL: String, completion: @escaping (Result<Feed, ParserError>) -> Void)
    func loadArticleDetails(from stringURL: String, completion: @escaping (Result<String, NetworkError>) -> Void)
}
