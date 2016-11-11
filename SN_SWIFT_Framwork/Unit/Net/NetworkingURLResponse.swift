//
//  NetworkingURLResponse.swift
//  LKB_SWIFT
//
//  Created by huangshuni on 2016/10/31.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit
import Alamofire

/*
 *json字符串转NSDictionary
 */
extension String{
    
    func NetworkingjsonDictionary() -> NSDictionary? {
        if self.characters.count == 0 {
            return nil
        }else{
            let jsonData = self.data(using: String.Encoding.utf8)
            let dic = try? JSONSerialization.jsonObject(with: jsonData!, options: JSONSerialization.ReadingOptions.mutableContainers)
            return dic as! NSDictionary?
        }
    }
}

enum NetURLResponseStatus{
    case NetURLResponseStatusSuccess//作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的NetAPIBaseManager来决定。
    case NetURLResponseStatusErrorTimeout//网络超时
    case NetURLResponseStatusNoNetwork//在这里除了超时以外的错误都是无网络错误
}

class NetworkingURLResponse: NSObject {

    //     @property(nonatomic,assign,readonly)BOOL isCache;
    //     @property(nonatomic,copy)NSString *faileType;

    var task:DataRequest?
    var status:NetURLResponseStatus?
    var requestId = NSInteger()
    var requestParams:NSDictionary?
    var responseData:Any?
    var content:Any?
    
    init(data:Any) {
        super.init()
    }
    
    /*
     * 成功
     */
    init(dataTask:DataRequest?,requestId:NSNumber,requertParams:NSDictionary,responseData:Any?,status:NetURLResponseStatus) {
        super.init()
        
//        print("responseData:\(responseData)")
        
        if responseData != nil {
            
            let dataDic:NSDictionary = responseData as!NSDictionary
            self.content = (dataDic["value"] as! String).NetworkingjsonDictionary()
            self.responseData = (dataDic.count  != 0) ? dataDic : self.content
            
        }else{
            self.content = nil
            self.responseData = nil
        }
        
        self.requestId = requestId.intValue
        self.requestParams = requertParams
        self.status = status
        self.task = dataTask
        
        
//        print(" self.content:___\(self.content)")
    }
    
    /*
     * 失败
     */
    init(dataTask:DataRequest?, requestId:NSNumber,requertParams:NSDictionary,responseData:Any?,error:NSError) {
        super.init()
        
        if responseData != nil {
            self.content = nil
            self.responseData = nil
//            do {
//                let data = try JSONSerialization.jsonObject(with: responseData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//                self.content = data["value"] as! NSDictionary
//                self.responseData = (data.count != 0) ? data:responseData
//            
//            } catch {
//                self.content = nil
//                self.responseData = nil
//            }
            
        }else{
            self.content = nil
            self.responseData = nil
        }
        
        self.status = self.responseStatusWithError(error: error)
        self.requestId = requestId.intValue
        self.requestParams = requertParams
        self.task = dataTask
    }
    
    
      // MARK: -
    func responseStatusWithError(error:NSError?) -> NetURLResponseStatus {
        
        if error != nil {
            
          var result = NetURLResponseStatus.NetURLResponseStatusNoNetwork
            if error?.code == NSURLErrorTimedOut {
                result = NetURLResponseStatus.NetURLResponseStatusErrorTimeout
            }
            
            return result
            
        }else{
           return NetURLResponseStatus.NetURLResponseStatusSuccess
        }
    }
}
