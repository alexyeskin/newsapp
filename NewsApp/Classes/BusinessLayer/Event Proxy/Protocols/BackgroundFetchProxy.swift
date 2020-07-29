//
//  BackgroundFetchProxy.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/26/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

protocol BackgroundFetchDelegate: AnyObject {
    func didFetch()
}

protocol BackgroundFetchDelegateHandler: AnyObject {
    var delegate: BackgroundFetchDelegate? { get set }
}

protocol BackgroundFetchActionHandler {
    func didFetch()
}

protocol BackgroundFetchProxy: BackgroundFetchDelegateHandler, BackgroundFetchActionHandler {}
