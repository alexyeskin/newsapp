//
//  RootRootConfigurator.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject
import UIKit

class RootModuleConfigurator {
    func configureModule () -> RootModuleInput {
        // swiftlint:disable force_unwrapping
        let moduleInput = AppDelegate.moduleAssembly.resolver.resolve(RootModuleInput.self)!
        return moduleInput
        // swiftlint:enable force_unwrapping
    }
}
