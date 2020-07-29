//
//  NewsNewsPresenter.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

class NewsPresenter {
    weak var view: NewsViewInput!
    weak var output: NewsModuleOutput?
    
    var interactor: NewsInteractorInput!
    var router: NewsRouterInput!
}

// MARK: - NewsModuleInput

extension NewsPresenter: NewsModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - NewsViewOutput

extension NewsPresenter: NewsViewOutput {
    func viewIsReady() {
        interactor.bindToEvents()
        interactor.getLocation()
    }
    
    func actionShowAllNews() {
        interactor.getNews()
    }
    
    func actionShowSavedNews() {
        interactor.obtainNews()
    }
    
    func actionSelectArticle(article: NewsEntity) {
        router.presentArticle(article: article, output: self)
    }
}

// MARK: - NewsInteractorOutput

extension NewsPresenter: NewsInteractorOutput {
    func didGetLocation() {
        interactor.geocodeLocation()
    }
    
    func didFailLocation() {
    }
    
    func didGeocodeLocation() {
        interactor.getNews()
    }
    
    func didFailGeocodeLocation() {
    }
    
    func didFailConnection() {
        view.failConnection()
    }
    
    func didGetConnection() {
        interactor.geocodeLocation()
        interactor.getNews()
        view.getConnection()
    }
    
    func didUpdateNews(news: [NewsEntity]) {
        view.updateNews(news: news)
    }
    
    func didObtainNews(savedNews: [NewsEntity]) {
        view.setupSavedNews(news: savedNews)
    }
    
    func didReceiveNews(news: [NewsEntity]) {
        view.setupInitialState(news: news)
    }
    
    func didFailReceiveNews() {
    }
}

extension NewsPresenter: NewsDetailsModuleOutput {
    func refreshNews(with article: NewsEntity) {
        interactor.updateNews(with: article)
        interactor.obtainNews()
    }
}
