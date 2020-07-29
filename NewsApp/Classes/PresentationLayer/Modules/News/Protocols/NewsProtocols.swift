//
//  NewsNewsProtocols.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

protocol NewsViewInput: class, Presentable {
    func setupInitialState(news: [NewsEntity])
    func setupSavedNews(news: [NewsEntity])
    func updateNews(news: [NewsEntity])
    func failConnection()
    func getConnection()
}

protocol NewsViewOutput {
    func viewIsReady()
    func actionSelectArticle(article: NewsEntity)
    func actionShowAllNews()
    func actionShowSavedNews()
}

protocol NewsModuleInput: class {
	var viewController: UIViewController { get }
	var output: NewsModuleOutput? { get set }
}

protocol NewsModuleOutput: class {
}

protocol NewsInteractorInput {
    func getLocation()
    func geocodeLocation()
    func getNews()
    func obtainNews()
    func updateNews(with article: NewsEntity)
    func bindToEvents()
}

protocol NewsInteractorOutput: class {
    func didGetLocation()
    func didFailLocation()
    func didGeocodeLocation()
    func didFailGeocodeLocation()
    func didReceiveNews(news: [NewsEntity])
    func didFailReceiveNews()
    func didObtainNews(savedNews: [NewsEntity])
    func didUpdateNews(news: [NewsEntity])
    func didFailConnection()
    func didGetConnection()
}

protocol NewsRouterInput {
    func presentArticle(article: NewsEntity, output: NewsDetailsModuleOutput)
}
