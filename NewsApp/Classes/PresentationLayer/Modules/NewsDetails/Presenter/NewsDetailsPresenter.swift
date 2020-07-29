//
//  NewsDetailsNewsDetailsPresenter.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

class NewsDetailsPresenter {
    weak var view: NewsDetailsViewInput!
    weak var output: NewsDetailsModuleOutput?
    
    var interactor: NewsDetailsInteractorInput!
    var router: NewsDetailsRouterInput!
    var article: NewsEntity?
    var articleDetails: [ArticleDetailEntity]?
}

// MARK: - NewsDetailsModuleInput

extension NewsDetailsPresenter: NewsDetailsModuleInput {
    var viewController: UIViewController {
        return view.viewController
    }
}

// MARK: - NewsDetailsViewOutput

extension NewsDetailsPresenter: NewsDetailsViewOutput {
    func actionSaveButtonTapped(article: NewsEntity, articleDetails: [ArticleDetailEntity]) {
        if article.isSaved {
            interactor.removeArticle(article: article)
        } else {
            interactor.saveArticle(article: article, articleDetails: articleDetails)
        }
    }
    
    func actionBack() {
        view.dissmissModal(animated: true)
    }
    
    func viewIsReady() {
        interactor.bindToEvents()
        interactor.getConnectionStatus()
        
        guard let article = article else {
            return
        }
        
        view.setupInitialState(article: article)
        self.articleDetails = []
        
        if article.isSaved {
            interactor.obtainArticleDetails(by: article)
        } else {
            interactor.getArticleDetails(from: article.link)
        }
    }
}

// MARK: - NewsDetailsInteractorOutput

extension NewsDetailsPresenter: NewsDetailsInteractorOutput {
    func didGetConnectionStatus(isConnected: Bool) {
        if !isConnected {
            view.showNetworkWarning()
        }
    }
    
    func didFailConnection() {
        view.showNetworkWarning()
    }
    
    func didGetConnection() {
        guard let article = article else {
            return
        }
        
        if !article.isSaved {
            interactor.getArticleDetails(from: article.link)
        } else if article.isSaved && articleDetails?.isEmpty ?? false {
            interactor.getArticleDetails(from: article.link)
        }
        view.hideNetworkWarning()
    }
    
    func didObtainArticleDetails(articleDetails: [ArticleDetailEntity]) {
        self.articleDetails = articleDetails
        view.setupArticleDetails(articleDetails: articleDetails)
        
        if articleDetails.isEmpty {
            interactor.getArticleDetails(from: article?.link ?? "")
        }
    }
    
    func didRemoveArticle(article: NewsEntity) {
        self.article = article
        view.updateArticle(article: article)
        output?.refreshNews(with: article)
    }
    
    func didSaveArticle(article: NewsEntity) {
        self.article = article
        view.updateArticle(article: article)
        output?.refreshNews(with: article)
    }
    
    func didReceiveArticleDetails(articleDetails: [ArticleDetailEntity]) {
        if article?.isSaved ?? false && self.articleDetails?.isEmpty ?? false {
            guard let article = article else {
                return
            }
            interactor.saveArticle(article: article, articleDetails: articleDetails)
        }
        self.articleDetails = articleDetails
        view.setupArticleDetails(articleDetails: articleDetails)
    }
    
    func didFailArticleDetails() {
    }
}
