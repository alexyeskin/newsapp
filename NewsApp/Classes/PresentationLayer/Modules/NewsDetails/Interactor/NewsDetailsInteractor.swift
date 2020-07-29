//
//  NewsDetailsNewsDetailsInteractor.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

class NewsDetailsInteractor {
    weak var output: NewsDetailsInteractorOutput!
    var newsService: NewsService!
    var sharedStorageCore: StorageCore!
    var reachabilityCore: ReachabilityCore!
    var connectionDelegateHandler: ConnectionEventDelegateHandler!
}

// MARK: - NewsDetailsInteractorInput

extension NewsDetailsInteractor: NewsDetailsInteractorInput {
    func bindToEvents() {
        connectionDelegateHandler.delegate = self
        newsService.startNotify()
    }
    
    func getConnectionStatus() {
        let isConnected = reachabilityCore.getConnectionStatus()
        DispatchQueue.main.async { [weak self] in
            self?.output.didGetConnectionStatus(isConnected: isConnected)
        }
    }
    
    func saveArticle(article: NewsEntity, articleDetails: [ArticleDetailEntity]) {
        let savedArticle = NewsEntity(source: article.source,
                                    sourceImageName: article.sourceImageName,
                                    imageURL: article.imageURL,
                                    publishDate: article.publishDate,
                                    title: article.title,
                                    description: article.description,
                                    link: article.link,
                                    isSaved: true
        )
        
        var updatedSavedNews: [NewsEntity: [ArticleDetailEntity]]?
        if let savedNews = sharedStorageCore.get(key: Constants.Keys.savedNews, type: [NewsEntity: [ArticleDetailEntity]].self) {
            updatedSavedNews = savedNews
        } else {
            updatedSavedNews = [:]
        }
        updatedSavedNews?[savedArticle] = articleDetails
        sharedStorageCore.set(key: Constants.Keys.savedNews, value: updatedSavedNews)
        DispatchQueue.main.async { [weak self] in
            self?.output.didSaveArticle(article: savedArticle)
        }
    }
    
    func removeArticle(article: NewsEntity) {
        let removedArticle = NewsEntity(source: article.source,
                                    sourceImageName: article.sourceImageName,
                                    imageURL: article.imageURL,
                                    publishDate: article.publishDate,
                                    title: article.title,
                                    description: article.description,
                                    link: article.link,
                                    isSaved: false
        )
        var updatedSavedNews: [NewsEntity: [ArticleDetailEntity]]?
        if let savedNews = sharedStorageCore.get(key: Constants.Keys.savedNews, type: [NewsEntity: [ArticleDetailEntity]].self) {
            updatedSavedNews = savedNews
        } else {
            updatedSavedNews = [:]
        }
        updatedSavedNews?.removeValue(forKey: article)
        sharedStorageCore.set(key: Constants.Keys.savedNews, value: updatedSavedNews)
        DispatchQueue.main.async { [weak self] in
            self?.output.didRemoveArticle(article: removedArticle)
        }
    }
    
    func getArticleDetails(from stringURL: String) {
        newsService.getArticleDetails(from: stringURL) { [weak self] result in
            switch result {
            case .success(let articleDetails):
                self?.mapArticleDetails(articleDetails: articleDetails)
                
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { [weak self] in
                    self?.output.didFailArticleDetails()
                }
            }
        }
    }
    
    func obtainArticleDetails(by article: NewsEntity) {
        var updatedSavedNews: [NewsEntity: [ArticleDetailEntity]]?
        if let savedNews = sharedStorageCore.get(key: Constants.Keys.savedNews, type: [NewsEntity: [ArticleDetailEntity]].self) {
            updatedSavedNews = savedNews
        } else {
            updatedSavedNews = [:]
        }
        guard let savedArticleDetails = updatedSavedNews?[article] else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.output.didObtainArticleDetails(articleDetails: savedArticleDetails)
        }
    }
    
    private func mapArticleDetails(articleDetails: [ArticleDetailResponseModel]) {
        var articleDetailsEntity: [ArticleDetailEntity] = []
        articleDetails.forEach { articleDetail in
            switch articleDetail {
            case .textDetail(let text):
                articleDetailsEntity.append(ArticleDetailEntity.textDetail(text))
                
            case .headingDetail(let text):
                articleDetailsEntity.append(ArticleDetailEntity.headingDetail(text))
                
            case .imageCaptionDetail(let text):
                articleDetailsEntity.append(ArticleDetailEntity.imageCaptionDetail(text))
                
            case .imageDetail(let url):
                articleDetailsEntity.append(ArticleDetailEntity.imageDetail(url))
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.output.didReceiveArticleDetails(articleDetails: articleDetailsEntity)
        }
    }
}

extension NewsDetailsInteractor: ConnectionEventDelegate {
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
