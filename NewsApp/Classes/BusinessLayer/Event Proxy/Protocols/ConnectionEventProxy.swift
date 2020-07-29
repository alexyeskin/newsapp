//
//  ConnectionEventProxy.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/24/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

protocol ConnectionEventDelegate: class {
    func connectionFailed()
    func connectionSuccess()
}

protocol ConnectionEventActionHandler {
    func actionConnectionFailed()
    func actionConnectionSuccess()
}

protocol ConnectionEventDelegateHandler {
    var delegate: ConnectionEventDelegate? { get set }
}

protocol ConnectionEventProxy: ConnectionEventDelegateHandler, ConnectionEventActionHandler {}
