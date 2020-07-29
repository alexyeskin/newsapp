//
//  NewsServiceImp.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/16/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import FeedKit
import Foundation

class NewsServiceImp: NewsService {
    var networkCore: NetworkCore!
    var locationCore: LocationCore!
    var parserCore: ParserCore!
    var reachabilityCore: ReachabilityCore!
    var notificationCore: NotificationCore!
    var sharedStorageCore: StorageCore!
    
    func getNews(completion: @escaping (Result<[NewsResponseModel], Error>) -> Void) {
        guard let source = sharedStorageCore.get(key: Constants.Keys.newsSource) else {
            completion(.failure(LocationError.notFound))
            return
        }
        
        networkCore.loadNews(from: source) { [weak self] result in
            switch result {
            case .success(let feed):
                switch source {
                case Constants.NewsSource.tutByURL:
                    let parsedNews = self?.parserCore.parseTutByNews(from: feed)
                    self?.saveFirstArticle(from: parsedNews ?? [])
                    completion(.success(parsedNews ?? []))
                    
                case Constants.NewsSource.theVergeURL:
                    let parsedNews = self?.parserCore.parseVergeNews(from: feed)
                    self?.saveFirstArticle(from: parsedNews ?? [])
                    completion(.success(parsedNews ?? []))
                    
                default:
                    break
                }
                
            case .failure(let error):
                print("feed error \(error.localizedDescription)")
            }
        }
    }
    
    func getArticleDetails(from stringURL: String, completion: @escaping (Result<[ArticleDetailResponseModel], Error>) -> Void) {
        networkCore.loadArticleDetails(from: stringURL) { [weak self] result in
            switch result {
            case .success(let article):
                guard let source = self?.sharedStorageCore.get(key: Constants.Keys.newsSource) else {
                    completion(.failure(LocationError.notFound))
                    return
                }
                switch source {
                case Constants.NewsSource.tutByURL:
                    let parsedHtml = self?.parserCore.parseTutByHTML(html: article)
                    let articleDetails = self?.parserCore.parseArticleDetails(from: parsedHtml ?? [])
                    completion(.success(articleDetails ?? []))
                    
                case Constants.NewsSource.theVergeURL:
                    let parsedHtml = self?.parserCore.parseVergeHTML(html: article)
                    let articleDetails = self?.parserCore.parseArticleDetails(from: parsedHtml ?? [])
                    completion(.success(articleDetails ?? []))
                    
                default:
                    break
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchUpdates(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        guard let lastArticle = sharedStorageCore.get(key: Constants.Keys.savedLastArticle, type: NewsResponseModel.self) else {
            return
        }
        var newArticle: NewsResponseModel?
        getNews { [weak self] result in
            switch result {
            case .success:
                newArticle = self?.sharedStorageCore.get(key: Constants.Keys.savedLastArticle, type: NewsResponseModel.self)
                if lastArticle.link == newArticle?.link {
                    completion(.success(false))
                } else {
                    completion(.success(true))
                }
                
            case .failure(let error):
                print("Fail to load News in Fetch Updates \(error.localizedDescription)")
                completion(.failure(.badURL))
            }
        }
    }
    
    func saveFirstArticle(from news: [NewsResponseModel]) {
        guard let firstLoadedArticle = news.first else {
            return
        }
        sharedStorageCore.set(key: Constants.Keys.savedLastArticle, value: firstLoadedArticle)
    }
    
    func startNotify() {
        reachabilityCore.startNotify()
    }
    
    func registerNotifications(completion: @escaping (Result<Bool, NotificationError>) -> Void) {
        notificationCore.registerNotifications { result in
            switch result {
            case .success:
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendNotification(completion: @escaping (NotificationError?) -> Void) {
        notificationCore.sendNotification { error in
            if error != nil {
                completion(error)
            }
        }
    }
}
