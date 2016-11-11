//
//  RequestReformer.swift
//  SN_SWIFT_Framwork
//
//  Created by huangshuni on 2016/11/11.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

class RequestReformer: NSObject,NetAPIManagerCallbackDataReformer {

    
    func managerReformData(manager: NetworkingBaseManager, data: NSDictionary?) -> Any? {
        
        if manager.isKind(of: RequestManager.self) {
           
            //处理数据
            
            return data
        }
        
        return nil
    }
    
}
