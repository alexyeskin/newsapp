//
//  RootRootRouter.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

class RootRouter: RootRouterInput {
	weak var view: UIViewController?
    weak var splash: UIViewController?
    weak var verification: UIViewController?
    weak var blockScreen: UIViewController?

    var childs = NSPointerArray.weakObjects()
}

extension RootRouter {
    func presentMainScreen() {
        guard let view = view else {
            return
        }
        let module = NewsModuleConfigurator().configureModule()
        let viewController = module.viewController
        clearChildsStack()
        view.addChildController(viewController)
        childs.addObject(viewController)
    }
    
    fileprivate func clearChildsStack() {
        guard let view = view else {
            return
        }
        let viewControllers: [UIViewController] = view.children
        for viewContoller in viewControllers {
            viewContoller.willMove(toParent: nil)
            viewContoller.view.removeFromSuperview()
            viewContoller.removeFromParent()
        }
    }
}
