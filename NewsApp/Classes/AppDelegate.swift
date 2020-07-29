//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var applicationAssembler = ApplicationAssembler()
    
    var backgroundFetchActionHandler: BackgroundFetchActionHandler! {
        return applicationAssembler.assembler.resolver.resolve(BackgroundFetchProxy.self)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        _ = ApplicationAssembler.rootAssembler()
        self.window = applicationAssembler.assembler.resolver.resolve(UIWindow.self)
        self.window?.makeKeyAndVisible()
        // swiftlint:disable force_unwrapping
        let configurators: [ConfiguratorProtocol] = applicationAssembler.assembler.resolver.resolve([ConfiguratorProtocol].self)!
        // swiftlint:enable force_unwrapping
        for configurator in configurators {
            configurator.configure()
        }
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(5)
        
        return true
    }
}

extension AppDelegate {
    static var currentDelegate: AppDelegate {
        // swiftlint:disable force_cast
        return UIApplication.shared.delegate as! AppDelegate
        // swiftlint:enable force_cast
    }
    
    static var currentWindow: UIWindow {
        // swiftlint:disable force_unwrapping
        return currentDelegate.window!
        // swiftlint:enable force_unwrapping
    }
    
    static var moduleAssembly: ModuleAssembly {
        // swiftlint:disable force_unwrapping
        return applicationAssembler.assembler.resolver.resolve(ModuleAssembly.self)!
        // swiftlint:enable force_unwrapping
    }
    
    static var applicationAssembler: ApplicationAssembler {
        return currentDelegate.applicationAssembler
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        backgroundFetchActionHandler.didFetch()
        completionHandler(.newData)
    }
}
