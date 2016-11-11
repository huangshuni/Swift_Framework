//
//  NetworkReachability.swift
//  LKB_SWIFT
//
//  Created by huangshuni on 2016/11/1.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit
import Alamofire

let SNNotificationListener = "SNNetworkNotificationListener"
let statusInfo = "status"

enum SNNetworkStatus: String {
    case unknown = "network unknown"
    case notReachable = "network  notReachable"
    case ethernetOrWiFi = "network ethernetOrWiFi"
    case wwan = "network wwan"
}

class NetworkReachability: NSObject {

    static let reachability = NetworkReachability()
    private override init() {}
    
    private var manager:NetworkReachabilityManager?{
    
      let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.listener = { status in
            var networkStatus:SNNetworkStatus?
            switch status {
            case .notReachable:
                networkStatus = SNNetworkStatus.notReachable
            case .unknown:
                networkStatus = SNNetworkStatus.unknown
            case .reachable(.ethernetOrWiFi):
                networkStatus = SNNetworkStatus.ethernetOrWiFi
            case .reachable(.wwan):
                networkStatus = SNNetworkStatus.wwan
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(SNNotificationListener), object: self, userInfo: [statusInfo:networkStatus])
        }
      return reachabilityManager
        
    }
    
    // MARK: - 开始监听网络
    func startListenNetwork() -> Void {
        
        manager?.startListening()
    }
    
    
}
