//
//  NewsDetailsNewsDetailsConfigurator.swift
//  NewsApp
//
//  Created by Alexander Eskin on 13/12/2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject
import UIKit

class NewsDetailsModuleConfigurator {
    func configureModule () -> NewsDetailsModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = AppDelegate.moduleAssembly.resolver.resolve(NewsDetailsModuleInput.self)!
        // swiftlint:enable force_unwrapping
        return moduleInput
    }
}
