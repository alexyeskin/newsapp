//
//  NewsNewsAssembler.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject
import UIKit

class NewsModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(NewsInteractor.self) { ( resolver, presenter: NewsPresenter) in
            let interactor = NewsInteractor()
            interactor.output = presenter
            interactor.newsService = resolver.resolve(NewsService.self)
            interactor.sharedStorageCore = resolver.resolve(StorageCore.self)
            interactor.locationCore = resolver.resolve(LocationCore.self)
            interactor.connectionDelegateHandler = resolver.resolve(ConnectionEventProxy.self)
            
            return interactor
        }
        
        container.register(NewsRouter.self) { (_, viewController: NewsViewController) in
            let router = NewsRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(NewsModuleInput.self) { resolver in
            let presenter = NewsPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(NewsViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(NewsInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(NewsRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(NewsViewController.self) { (_, presenter: NewsPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.news.newsViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
