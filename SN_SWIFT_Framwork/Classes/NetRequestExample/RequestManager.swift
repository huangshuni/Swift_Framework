//
//  RequestManager.swift
//  SN_SWIFT_Framwork
//
//  Created by huangshuni on 2016/11/11.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

class RequestManager: NetworkingBaseManager,NetAPIManagerValidator {

    override init() {
        super.init()
        self.validator = self
    }
    
    func NetAPIManagerCorrectWithParamsData(manager: NetworkingBaseManager, paramsdata: NSDictionary) -> Bool {
        return true
    }
    
    func NetAPIManagerCorrecWithCallBackData(manager: NetworkingBaseManager, callBackdata: NSDictionary) -> Bool {
        return true
    }

}
