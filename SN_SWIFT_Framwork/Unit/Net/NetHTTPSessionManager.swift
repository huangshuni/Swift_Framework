//
//  NetHTTPSessionManager.swift
//  LKB_SWIFT
//
//  Created by huangshuni on 2016/10/31.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit
import Alamofire

class NetHTTPSessionManager: NSObject {
    
    //单例，static关键字，哪里用到的都是一个
    static let session = NetHTTPSessionManager()
    private override init() {
       super.init()
    }
    
    static var timeOut: TimeInterval = 15.0//超时
    var header: HTTPHeaders?//请求头
    private lazy var sessionMnager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = timeOut
        return SessionManager(configuration: configuration)
    }()
    
    var recordedRequestId:NSNumber?
    var dispatchTable = NSMutableDictionary()
    
    typealias NetworkingURLResponseCallBack = (_ response:NetworkingURLResponse)->Void
        
    /*
     * GET请求
     * 参数可以方在url中,也可以放在params中
     */
    @discardableResult
    func callGETWithUrl(url:String,params:AnyObject,success:@escaping NetworkingURLResponseCallBack,failure:@escaping NetworkingURLResponseCallBack) -> NSInteger {
        
        let requesID = self.generateRequestId()
        
        //dataTask是nil值，需要处理一下
        
        let dataRequest:DataRequest =  self.sessionMnager.request((url as String),method:.get,parameters:(params as! Parameters), encoding:URLEncoding.default,headers:nil).responseJSON { (response) in
            
            switch response.result{
            case .success:
                //如果这个时候请求已经被取消，那么就不处理回调
                let cancelRequest = self.dispatchTable.object(forKey: requesID)
                if cancelRequest == nil {
                    return
                }
                //处理数据
                let responseData = NetworkingURLResponse.init(dataTask:nil,requestId: requesID, requertParams: params as! NSDictionary, responseData: response.result.value as Any, status: NetURLResponseStatus.NetURLResponseStatusSuccess)
                success(responseData)
            case .failure(let error):
                
                //如果这个时候请求已经被取消，那么就不处理回调
                let cancelRequest = self.dispatchTable.object(forKey: requesID)
                if cancelRequest == nil {
                    return
                }
                //处理数据
                let responseData = NetworkingURLResponse.init(dataTask:nil,requestId: requesID, requertParams: params as! NSDictionary, responseData: response.result.value as Any, error:error as NSError)
                failure(responseData)
            }
        }

        self.dispatchTable.setObject(dataRequest, forKey: requesID)
        return NSInteger(requesID)
    }

    /*
     * POST请求
     */
    func callPOSTWithUrl(url:String,params:AnyObject,success:@escaping NetworkingURLResponseCallBack,failure:@escaping NetworkingURLResponseCallBack) -> NSInteger {
        
        let requesID = self.generateRequestId()
        
      let dataRequest:DataRequest = self.sessionMnager.request((url as String),method: .post,parameters:(params as! Parameters),encoding:URLEncoding.default,headers:nil).validate().responseJSON { (response) in
            
            switch response.result{
            case .success:
                //如果这个时候请求已经被取消，那么就不处理回调
                let cancelRequest = self.dispatchTable.object(forKey: requesID)
                if cancelRequest == nil {
                    return
                }
                //处理数据
                let responseData = NetworkingURLResponse.init(dataTask:nil,requestId: requesID, requertParams: params as! NSDictionary, responseData: response.result.value as Any, status: NetURLResponseStatus.NetURLResponseStatusSuccess)
                    success(responseData)
                
            case .failure(let error):
                
                //如果这个时候请求已经被取消，那么就不处理回调
                let cancelRequest = self.dispatchTable.object(forKey: requesID)
                if cancelRequest == nil {
                    return
                }
                //处理数据
                let responseData = NetworkingURLResponse.init(dataTask:nil,requestId: requesID, requertParams: params as! NSDictionary, responseData: response.result.value as Any, error:error as NSError)
                failure(responseData)
            }
        }
        
        //打印请求的url
        if dataRequest.request?.httpBody != nil {
            let url = BASE_URL + String.init(data: (dataRequest.request?.httpBody)!, encoding: String.Encoding.utf8)!
            print(url)
        }
       
        self.dispatchTable.setObject(dataRequest, forKey: requesID)
        return NSInteger(requesID)
    }
    

    /*
     * 单独取消请求
     */
    func cancelRequestWithRequestId(requestID:NSNumber) -> Void {
        
        let dataRequest = self.dispatchTable.object(forKey: requestID)
        if dataRequest != nil {
            (dataRequest as! DataRequest).cancel()
        }
        self.dispatchTable.removeObject(forKey: requestID)
    }
    
    /*
     * 根据数组取消请求
     */
    func cancelRequestWithRequestIDList(requestIDList:NSArray) -> Void {
        
        for value in requestIDList {
            self.cancelRequestWithRequestId(requestID: (value as! NSNumber))
        }
    }
    
      // MARK: - 生成请求Id
    func generateRequestId() -> NSNumber {
        
        if recordedRequestId == nil {
            recordedRequestId = NSNumber.init(integerLiteral: 1)
        }else{
            if recordedRequestId?.intValue == NSIntegerMax {
                recordedRequestId = NSNumber.init(integerLiteral: 1)
            }else{
                recordedRequestId = NSNumber.init(integerLiteral: (recordedRequestId?.intValue)! + 1)
            }
        }
        return recordedRequestId!
    }
}
