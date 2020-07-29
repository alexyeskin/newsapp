//
//  NewsDetailsNewsDetailsProtocols.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//
 
import UIKit

protocol NewsDetailsViewInput: class, Presentable {
    func setupInitialState(article: NewsEntity)
    func setupArticleDetails(articleDetails: [ArticleDetailEntity])
    func updateArticle(article: NewsEntity)
    func showNetworkWarning()
    func hideNetworkWarning()
}

protocol NewsDetailsViewOutput {
    func viewIsReady()
    func actionBack()
    func actionSaveButtonTapped(article: NewsEntity, articleDetails: [ArticleDetailEntity])
}

protocol NewsDetailsModuleInput: class {
	var viewController: UIViewController { get }
	var output: NewsDetailsModuleOutput? { get set }
    var article: NewsEntity? { get set }
}

protocol NewsDetailsModuleOutput: class {
    func refreshNews(with article: NewsEntity)
}

protocol NewsDetailsInteractorInput {
    func getArticleDetails(from stringURL: String)
    func saveArticle(article: NewsEntity, articleDetails: [ArticleDetailEntity])
    func removeArticle(article: NewsEntity)
    func obtainArticleDetails(by article: NewsEntity)
    func bindToEvents()
    func getConnectionStatus()
}

protocol NewsDetailsInteractorOutput: class {
    func didReceiveArticleDetails(articleDetails: [ArticleDetailEntity])
    func didObtainArticleDetails(articleDetails: [ArticleDetailEntity])
    func didFailArticleDetails()
    func didSaveArticle(article: NewsEntity)
    func didRemoveArticle(article: NewsEntity)
    func didGetConnection()
    func didFailConnection()
    func didGetConnectionStatus(isConnected: Bool)
}

protocol NewsDetailsRouterInput {
}
