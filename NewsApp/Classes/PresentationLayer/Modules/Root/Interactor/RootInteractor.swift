//
//  RootRootInteractor.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//
import Foundation

class RootInteractor {
    weak var output: RootInteractorOutput!
    var newsService: NewsService!
    var connectionDelegateHandler: ConnectionEventDelegateHandler!
    var backgroundFetchDelegateHandler: BackgroundFetchDelegateHandler!
}

// MARK: - RootInteractorInput

extension RootInteractor: RootInteractorInput {
    func bindToEvents() {
        backgroundFetchDelegateHandler.delegate = self
        newsService.registerNotifications { result in
            switch result {
            case .success:
                print("Notifications Registered")
                
            case .failure(let error):
                print("Notification Error - \(error.localizedDescription)")
            }
        }
    }
}

extension RootInteractor: BackgroundFetchDelegate {
    func didFetch() {
        newsService.fetchUpdates { [weak self] result in
            switch result {
            case .success(let haveUpdates):
                if haveUpdates {
                    self?.newsService.sendNotification { error in
                        if error != nil {
                            print("Notification Error - \(error?.localizedDescription ?? " ")")
                        }
                    }
                    print("has new news")
                }
                
            case .failure(let error):
                print("fetch error \(error.localizedDescription)")
            }
        }
    }
}
