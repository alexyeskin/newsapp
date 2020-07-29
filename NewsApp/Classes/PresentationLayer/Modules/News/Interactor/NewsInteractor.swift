//
//  NewsNewsInteractor.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

class NewsInteractor {
    weak var output: NewsInteractorOutput!
    var newsService: NewsService!
    var sharedStorageCore: StorageCore!
    var locationCore: LocationCore!
    var connectionDelegateHandler: ConnectionEventDelegateHandler!
    var news: [NewsEntity]?
    var location: Location?
}

// MARK: - NewsInteractorInput

extension NewsInteractor: NewsInteractorInput {
    func getNews() {
        if let news = news {
            let infinityNews = self.setupInfinityNews(news: news)
            DispatchQueue.main.async { [weak self] in
                self?.output.didReceiveNews(news: infinityNews)
            }
            return
        }
        newsService.getNews { [weak self] result in
            switch result {
            case .success(let news):
                if let mappedNews = self?.mapNews(news: news) {
                    self?.news = mappedNews
                    if let news = self?.setupInfinityNews(news: mappedNews) {
                        DispatchQueue.main.async { [weak self] in
                            self?.output.didReceiveNews(news: news)
                        }
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.output.didFailReceiveNews()
                }
            }
        }
    }
    
    func getLocation() {
        sharedStorageCore.remove(key: Constants.Keys.newsSource)
        locationCore.getLocation { [weak self] result in
            switch result {
            case .success(let location):
                self?.location = location
                
            case .failure(let error):
                if error == .denied {
                    self?.sharedStorageCore.set(key: Constants.Keys.newsSource, value: Constants.NewsSource.theVergeURL)
                    self?.location = Location(latitude: 0.0, longitude: 0.0)
                }
                print("error getLocation \(error.localizedDescription)")
            }
            DispatchQueue.main.async { [weak self] in
                self?.output.didGetLocation()
            }
        }
    }
    
    func geocodeLocation() {
        guard let location = self.location else {
            return
        }
        locationCore.geocodeLocation(location: location) { [weak self] country in
            switch country {
            case "Belarus":
                self?.sharedStorageCore.set(key: Constants.Keys.newsSource, value: Constants.NewsSource.tutByURL)
                print("tut by")
                
            default:
                self?.sharedStorageCore.set(key: Constants.Keys.newsSource, value: Constants.NewsSource.theVergeURL)
                print("the Verge")
            }
            DispatchQueue.main.async { [weak self] in
                self?.output.didGeocodeLocation()
            }
        }
    }
    
    func updateNews(with article: NewsEntity) {
        if let row = news?.lastIndex(where: { $0.link == article.link }) {
            if article.isSaved {
                news?[row] = article
                let infinityNews = self.setupInfinityNews(news: news ?? [])
                
                DispatchQueue.main.async { [weak self] in
                    self?.output.didUpdateNews(news: infinityNews)
                }
            } else {
                news?[row] = article
                let infinityNews = self.setupInfinityNews(news: news ?? [])
                
                DispatchQueue.main.async { [weak self] in
                    self?.output.didUpdateNews(news: infinityNews)
                }
            }
        }
    }
    
    func obtainNews() {
        if let savedNews = sharedStorageCore.get(key: Constants.Keys.savedNews, type: [NewsEntity: [ArticleDetailEntity]].self) {
            var savedNews = Array(savedNews.keys)
            savedNews = savedNews.sorted { firstArticle, anotherArticle -> Bool in
                firstArticle.publishDate.compare(anotherArticle.publishDate) == .orderedDescending
            }
            DispatchQueue.main.async { [weak self] in
                let savedNews = self?.setupInfinityNews(news: savedNews)
                self?.output.didObtainNews(savedNews: savedNews ?? [])
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.output.didObtainNews(savedNews: [])
            }
        }
    }
    
    func bindToEvents() {
        connectionDelegateHandler.delegate = self
        newsService.startNotify()
    }
    
    private func setupInfinityNews(news: [NewsEntity]) -> [NewsEntity] {
        var infinityNews = news
        if news.count >= 3 {
            guard let firstNews = news.first else {
                return []
            }
            let secondNews = news[1]
            
            let penultimateNews = news[news.count - 2]
            guard let lastNews = news.last else {
                return []
            }
            infinityNews.insert(penultimateNews, at: 0)
            infinityNews.insert(lastNews, at: 1)
            infinityNews.append(firstNews)
            infinityNews.append(secondNews)
        }
        
        return infinityNews
    }
    
    private func mapNews(news: [NewsResponseModel]) -> [NewsEntity] {
        var newsEntity: [NewsEntity] = []
        var savedNews: [NewsEntity] = []
        if let saved = sharedStorageCore.get(key: Constants.Keys.savedNews, type: [NewsEntity: [ArticleDetailEntity]].self) {
            savedNews = Array(saved.keys)
        }
        
        news.forEach { article in
            if savedNews.contains(where: { savedArticle -> Bool in
                article.link == savedArticle.link
            }) {
                let articleEntity = NewsEntity(source: article.source,
                                               sourceImageName: article.sourceImageName,
                                               imageURL: article.imageURL,
                                               publishDate: article.date,
                                               title: article.title,
                                               description: article.description,
                                               link: article.link,
                                               isSaved: true
                )
                newsEntity.append(articleEntity)
            } else {
                let articleEntity = NewsEntity(source: article.source,
                                               sourceImageName: article.sourceImageName,
                                               imageURL: article.imageURL,
                                               publishDate: article.date,
                                               title: article.title,
                                               description: article.description,
                                               link: article.link,
                                               isSaved: article.isSaved
                )
                newsEntity.append(articleEntity)
            }
        }
        return newsEntity
    }
}

extension NewsInteractor: ConnectionEventDelegate {
    func connectionFailed() {
        DispatchQueue.main.async { [weak self] in
            self?.output.didFailConnection()
        }
    }
    
    func connectionSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.output.didGetConnection()
        }
    }
}
