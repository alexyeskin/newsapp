//
//  RootRootProtocols.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

protocol RootViewInput: class, Presentable {
    func setupInitialState()
}

protocol RootViewOutput {
    func viewIsReady()
}

protocol RootModuleInput: class {
	var viewController: UIViewController { get }
	var output: RootModuleOutput? { get set }
}

protocol RootModuleOutput: class {
}

protocol RootInteractorInput {
    func bindToEvents()
}

protocol RootInteractorOutput: class {
}

protocol RootRouterInput {
    func presentMainScreen()
}
