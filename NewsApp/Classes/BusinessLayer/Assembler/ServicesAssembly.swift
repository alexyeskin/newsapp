//
//  ServicesAssembly.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NewsService.self) { resolver in
            let service = NewsServiceImp()
            service.networkCore = resolver.resolve(NetworkCore.self)
            service.locationCore = resolver.resolve(LocationCore.self)
            service.parserCore = resolver.resolve(ParserCore.self)
            service.reachabilityCore = resolver.resolve(ReachabilityCore.self)
            service.notificationCore = resolver.resolve(NotificationCore.self)
            service.sharedStorageCore = resolver.resolve(StorageCore.self)
            return service
        }
        .inObjectScope(.container)
    }
}
