//
//  Connection.swift
//  Test
//
//  Created by Deepak on 29/06/23.
//

import Foundation
import Reachability

class InternetManager: NSObject {

    var reachability: Reachability!
    
    static let sharedInstance: InternetManager = { return InternetManager() }()
    
    
    override init() {
        super.init()

        reachability = try! Reachability()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            try reachability.startNotifier()
        } catch {
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
    }
    
    static func stopNotifier() -> Void {
        do {
            try (InternetManager.sharedInstance.reachability).startNotifier()
        } catch {
        }
    }

   @objc static func isReachable(completed: @escaping (InternetManager) -> Void) {
       if (InternetManager.sharedInstance.reachability).connection != .unavailable {
            completed(InternetManager.sharedInstance)
        }
    }
    
    static func isUnreachable(completed: @escaping (InternetManager) -> Void) {
        if (InternetManager.sharedInstance.reachability).connection == .unavailable {
            completed(InternetManager.sharedInstance)
        }
    }
    
    static func isReachableViaWWAN(completed: @escaping (InternetManager) -> Void) {
        if (InternetManager.sharedInstance.reachability).connection == .cellular {
            completed(InternetManager.sharedInstance)
        }
    }

    static func isReachableViaWiFi(completed: @escaping (InternetManager) -> Void) {
        if (InternetManager.sharedInstance.reachability).connection == .wifi {
            completed(InternetManager.sharedInstance)
        }
    }
}
