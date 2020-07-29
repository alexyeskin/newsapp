//
//  TestServicesAssembly.swift
//  NewsAppTests
//
//  Created by Alexander Eskin on 1/9/20.
//  Copyright © 2020 PixelPlex. All rights reserved.
//

import Swinject
@testable import NewsApp

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NewsServiceMock.self) { resolver in
            let service = NewsServiceMock()
//            service.networkCore = resolver.resolve(NetworkCore.self)
//            service.locationCore = resolver.resolve(LocationCore.self)
//            service.parserCore = resolver.resolve(ParserCore.self)
//            service.reachabilityCore = resolver.resolve(ReachabilityCore.self)
//            service.notificationCore = resolver.resolve(NotificationCore.self)
//            service.sharedStorageCore = resolver.resolve(StorageCore.self)
            return service
        }
        .inObjectScope(.container)
    }
}

