//
//  BackgroundFetchProxyImp.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/26/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

class BackgroundFetchProxyImp: BackgroundFetchProxy {
    weak var delegate: BackgroundFetchDelegate? {
        didSet {
            delegates.addObject(delegate)
        }
    }
    
    fileprivate var delegates = NSPointerArray.weakObjects()
    
    func didFetch() {
        delegates.compact()
        
        for index in 0..<delegates.count {
            if let delegate = delegates.object(at: index) as? BackgroundFetchDelegate {
                delegate.didFetch()
            }
        }
    }
}
