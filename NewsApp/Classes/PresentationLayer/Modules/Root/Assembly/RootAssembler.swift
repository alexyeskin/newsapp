//
//  RootRootAssembler.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject
import UIKit

class RootModuleAssembler: Assembly {
    func assemble(container: Container) {
        container.register(RootInteractor.self) { ( resolver, presenter: RootPresenter) in
            let interactor = RootInteractor()
            interactor.output = presenter
            interactor.newsService = resolver.resolve(NewsService.self)
            interactor.backgroundFetchDelegateHandler = resolver.resolve(BackgroundFetchProxy.self)
            
            return interactor
        }
        
        container.register(RootRouter.self) { (_, viewController: RootViewController) in
            let router = RootRouter()
            router.view = viewController
            
            return router
        }
        
        container.register(RootModuleInput.self) { resolver in
            let presenter = RootPresenter()
            // swiftlint:disable force_unwrapping
            let viewController = resolver.resolve(RootViewController.self, argument: presenter)!
            // swiftlint:enable force_unwrapping
            presenter.view = viewController
            presenter.interactor = resolver.resolve(RootInteractor.self, argument: presenter)
            presenter.router = resolver.resolve(RootRouter.self, argument: viewController)

            return presenter
        }
        
        container.register(RootViewController.self) { (_, presenter: RootPresenter) in
            // swiftlint:disable force_unwrapping
            let viewController = R.storyboard.root.rootViewController()!
            viewController.output = presenter
            return viewController
            // swiftlint:enable force_unwrapping
        }
    }
}
