//
//  NewsDetailsNewsDetailsAssembler.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject
import UIKit

class NewsDetailsModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(NewsDetailsInteractor.self) { ( resolver, presenter: NewsDetailsPresenter) in
            let interactor = NewsDetailsInteractor()
            interactor.output = presenter
            interactor.newsService = resolver.resolve(NewsService.self)
            interactor.sharedStorageCore = resolver.resolve(StorageCore.self)
            interactor.reachabilityCore = resolver.resolve(ReachabilityCore.self)
            interactor.connectionDelegateHandler = resolver.resolve(ConnectionEventProxy.self)
            
            return interactor
        }
        
        container.register(NewsDetailsRouter.self) { (_, viewController: NewsDetailsViewController) in
            let router = NewsDetailsRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(NewsDetailsModuleInput.self) { resolver in
            let presenter = NewsDetailsPresenter()

            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(NewsDetailsViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(NewsDetailsInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(NewsDetailsRouter.self, argument: viewController)
            
            return presenter
        }
        
        container.register(NewsDetailsViewController.self) { (_, presenter: NewsDetailsPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.newsDetails.newsDetailsViewController()!
            // swiftlint:enable force_unwrapping
            viewController.output = presenter
            return viewController
        }
    }
}
