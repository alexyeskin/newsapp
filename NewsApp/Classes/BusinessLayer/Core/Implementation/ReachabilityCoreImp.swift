//
//  ReachabilityCoreImp.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/24/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

class ReachabilityCoreImp: ReachabilityCore {
    let reachability = try? Reachability()
    var actionHandler: ConnectionEventActionHandler!
    
    var connectionHandler: ((ReachabilityStatus) -> Void)?
    
    func startNotify() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("can’t start")
        }
        
        reachability?.whenUnreachable = { [weak self] _ in
            print("whenUnreachable")
            let reachabilityStatus: ReachabilityStatus = .unreachable
            self?.actionHandler.actionConnectionFailed()
            self?.connectionHandler?(reachabilityStatus)
        }
        
        reachability?.whenReachable = { [weak self] _ in
            print("whenReachable")
            let reachabilityStatus: ReachabilityStatus = .reachable
            self?.actionHandler.actionConnectionSuccess()
            self?.connectionHandler?(reachabilityStatus)
        }
    }
    
    func stopNotify() {
        reachability?.stopNotifier()
    }
    
    func getConnectionStatus() -> Bool {
        switch reachability?.connection {
        case .some(.cellular), .some(.wifi):
            return true
            
        case .some(.none), .some(.unavailable), .none:
            return false
        }
    }
}
