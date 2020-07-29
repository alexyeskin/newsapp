//
//  RootRootPresenter.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

enum AuthState {
    case unauth
    case varification
    case auth
}

class RootPresenter {
    weak var view: RootViewInput!
    weak var output: RootModuleOutput?
    
    var interactor: RootInteractorInput!
    var router: RootRouterInput!
}

// MARK: - RootModuleInput

extension RootPresenter: RootModuleInput {
  	var viewController: UIViewController {
    	return view.viewController
  	}
}

// MARK: - RootViewOutput

extension RootPresenter: RootViewOutput {
    func viewIsReady() {
        interactor.bindToEvents()
        router.presentMainScreen()
    }
}

// MARK: - RootInteractorOutput

extension RootPresenter: RootInteractorOutput {
}
