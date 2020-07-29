//
//  ReachabilityCore.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/24/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

enum ReachabilityStatus {
    case reachable
    case unreachable
}

//events from this service you can get from ConnectionEventProxy class
protocol ReachabilityCore {
    var connectionHandler: ((ReachabilityStatus) -> Void)? { get set }
    
    func startNotify()
    func stopNotify()
    func getConnectionStatus() -> Bool
}
