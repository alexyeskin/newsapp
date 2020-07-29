//
//  CoreComponentAssembly.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject

final class CoreComponentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkCore.self) { _ in
            let core = NetworkCoreImp()
            return core
        }
        .inObjectScope(.container)
        
        container.register(LocationCore.self) { _ in
            let core = LocationCoreImp()
            return core
        }
        .inObjectScope(.container)
        
        container.register(ParserCore.self) { _ in
            let core = ParserCoreImp()
            return core
        }
        .inObjectScope(.container)
        
        container.register(ReachabilityCore.self) { resolver in
            let core = ReachabilityCoreImp()
            core.actionHandler = resolver.resolve(ConnectionEventProxy.self)
            return core
        }
        .inObjectScope(.container)
        
        container.register(NotificationCore.self) { _ in
            let core = NotificationCoreImp()
            return core
        }
        .inObjectScope(.container)
        
        container.register(StorageCore.self) { _ in
            let core = SharedStorageCore()
            return core
        }
        .inObjectScope(.container)
    }
}
