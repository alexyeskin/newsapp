//
//  ConnectionEventProxyImp.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/24/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

class ConnectionEventProxyImp: ConnectionEventProxy {
    weak var delegate: ConnectionEventDelegate? {
        didSet {
            delegates.addObject(delegate)
        }
    }
    
    fileprivate var delegates = NSPointerArray.weakObjects()
    
    func actionConnectionFailed() {
        delegates.compact()
        
        for index in 0..<delegates.count {
            if let delegate = delegates.object(at: index) as? ConnectionEventDelegate {
                delegate.connectionFailed()
            }
        }
        
        print("actionConnectionFailed")
    }
    
    func actionConnectionSuccess() {
        delegates.compact()
        
        for index in 0..<delegates.count {
            if let delegate = delegates.object(at: index) as? ConnectionEventDelegate {
                delegate.connectionSuccess()
            }
        }
        print("actionConnectionSuccess")
    }
}
