//
//  ProxyAssembly.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12.12.2019.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Swinject

final class ProxyAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ConnectionEventProxy.self) { _ in
            let proxy = ConnectionEventProxyImp()
            return proxy
        }
        .inObjectScope(.container)
        
        container.register(BackgroundFetchProxy.self) { _ in
            let proxy = BackgroundFetchProxyImp()
            return proxy
        }
        .inObjectScope(.container)
    }
}
