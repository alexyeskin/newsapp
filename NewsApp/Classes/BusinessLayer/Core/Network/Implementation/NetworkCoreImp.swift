//
//  NetworkCoreImp.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/16/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import FeedKit
import Foundation

class NetworkCoreImp: NetworkCore {
    func loadNews(from stringURL: String, completion: @escaping (Result<Feed, ParserError>) -> Void) {
        guard let url = URL(string: stringURL) else {
            completion(.failure(.internalError(reason: "Bad URL")))
            return
        }
        let parser = FeedParser(URL: url)
        parser.parseAsync { result in
            switch result {
            case .success(let feed):
                completion(.success(feed))
                
            case .failure:
                completion(.failure(.internalError(reason: "Can't parse")))
            }
        }
    }
    
    func loadArticleDetails(from stringURL: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: stringURL) else {
                completion(.failure(.badURL))
                return
            }
            if let data = try? Data(contentsOf: url) {
                if let atricleDetails = String(data: data, encoding: .utf8) {
                    completion(.success(atricleDetails))
                } else {
                    completion(.failure(.mappingError))
                }
            } else {
                completion(.failure(.badConnection))
            }
        }
    }
}
