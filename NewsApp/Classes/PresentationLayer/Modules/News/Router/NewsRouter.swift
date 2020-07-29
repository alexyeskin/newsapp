//
//  NewsNewsRouter.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

class NewsRouter: NewsRouterInput {
	weak var view: UIViewController?
    
    func presentArticle(article: NewsEntity, output: NewsDetailsModuleOutput) {
        guard let view = view else {
            return
        }
        
        let module = NewsDetailsModuleConfigurator().configureModule()
        module.output = output
        module.article = article
        let viewController = module.viewController
        viewController.modalPresentationStyle = .fullScreen
        view.present(viewController, animated: true, completion: nil)
    }
}
