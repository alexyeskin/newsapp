//
//  NewsService.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/16/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

protocol NewsService {
    func getNews(completion: @escaping (Result<[NewsResponseModel], Error>) -> Void)
    func saveFirstArticle(from news: [NewsResponseModel])
    func getArticleDetails(from stringURL: String, completion: @escaping (Result<[ArticleDetailResponseModel], Error>) -> Void)
    func fetchUpdates(completion: @escaping (Result<Bool, NetworkError>) -> Void)
    func startNotify()
    func registerNotifications(completion: @escaping (Result<Bool, NotificationError>) -> Void)
    func sendNotification(completion: @escaping (NotificationError?) -> Void)
}
