//
//  NetworkingBaseMangaer.swift
//  LKB_SWIFT
//
//  Created by huangshuni on 2016/10/31.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit
import Alamofire

// 在调用成功之后的params字典里面，用这个key可以取出requestID
let NetAPIBaseManagerRequestID:NSString = "NetAPIBaseManagerRequestID"

//MARK: - 请求方式
enum NetAPIManagerRequestType {
    case NetMangerRequesetTypePost
    case NetMangerRequesetTypeGet
}

enum NetAPIManagerErrorType {
    
    case NetAPIManagerErrorTypeDefault//没有产生过API请求，这个是manager的默认状态
    case NetAPIManagerErrorTypeSuccess//API请求成功且返回数据正确，此时manager的数据是可以直接那拿来使用的
    case NetAPIManagerErrorTypeNoContent//API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    case NetAPIManagerErrorTypeParamsError//参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    case NetAPIManagerErrorTypeTimeout //请求超时。JFHTTPSessionManager设置的是20秒超时，具体超时时间的设置请自己去看HTTPSessionManager的相关代码。
    case NetAPIManagerErrorTypeNoNetWork//网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
    
}


//MARK: - 设置参数
@objc protocol NetAPIManagerParamSourceDelegate:NSObjectProtocol {
    //第一个代理必须实现
   func NetAPIManagerParamsForAPI(manager:NetworkingBaseManager) -> NSDictionary
   @objc optional func NetworkingManagerBackCorrectParamsResult(manager:NetworkingBaseManager) -> Void
    
}

//MARK: - 验证参数和返回的数据
@objc protocol NetAPIManagerValidator:NSObjectProtocol{
    /*
     返回的数据
     所有的callback数据都应该在这个函数里面进行检查，事实上，到了回调delegate的函数里面是不需要再额外验证返回数据是否为空的。
     */
    func NetAPIManagerCorrecWithCallBackData(manager:NetworkingBaseManager,callBackdata:NSDictionary) -> Bool

    /*
     参数验证
     */
    func NetAPIManagerCorrectWithParamsData(manager:NetworkingBaseManager,paramsdata:NSDictionary) -> Bool
}


//MARK: - 拦截功能 给参数之前之后，请求数据成功之前和之后，请求数据失败之前和之后
@objc protocol NetAPIManagerInterceptor :NSObjectProtocol{
    
@objc optional
    func beforePerformSuccessWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void
@objc optional
    func afterPerformSuccessWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void
@objc optional
    func beforePerformFailWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void
@objc optional
    func afterPerformFailWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void
@objc optional
    func shouldCallAPIWithParams(manager:NetworkingBaseManager,params:NSDictionary) -> Bool
@objc optional
    func afterCallingAPIWithParams(manager:NetworkingBaseManager,params:NSDictionary) -> Void
}


//MARK: - 调用API成功和失败之后使用该代理方法
protocol NetAPIManagerCallBackDataDelegate:NSObjectProtocol{
    func NetAPIManagerRequestSuccessBackData(manager:NetworkingBaseManager) -> Void
    func NetAPIManagerRequestFailedBackData(manager:NetworkingBaseManager) -> Void
}

//MARK: - 处理返回的数据
protocol NetAPIManagerCallbackDataReformer:NSObjectProtocol {
    func managerReformData(manager:NetworkingBaseManager,data:NSDictionary?) -> Any?
}


class NetworkingBaseManager: NSObject {
    
    weak var delegate:NetAPIManagerCallBackDataDelegate?
    weak var paramSource:NetAPIManagerParamSourceDelegate?
    weak var validator:NetAPIManagerValidator?
    weak var intercetor:NetAPIManagerInterceptor?
    var fetchedRawData:Any?
    var requestIdList = NSMutableArray()
    let requestType:NetAPIManagerRequestType
    var errorType = NetAPIManagerErrorType.NetAPIManagerErrorTypeDefault
    var headers = [String:String]()
    var requestURL = String()
    
    override init() {
        self.paramSource = nil
        self.delegate = nil
        self.validator = nil
        self.requestType = NetAPIManagerRequestType.NetMangerRequesetTypePost
//      headers["Content-Type"] = "application/json"
    }
    
    @discardableResult
    func loadData() -> NSInteger {
        
        let params:NSDictionary = (self.paramSource?.NetAPIManagerParamsForAPI(manager:self))!
        let urlStr = requestURL.characters.count != 0 ? self.requestURL : BASE_URL as String
        let requestId = self.loadDataWithURL(url:urlStr as String,params:params )
        return requestId
    }
    
    func loadDataWithURL(url:String,params:NSDictionary) -> NSInteger {
        
        var requetId = 0
        
        //判断是否允许给参数
        if self.intercetor?.shouldCallAPIWithParams?(manager: self, params: params) == false {
            return 0
        }
        
        //判断参数是否正确
        if self.validator?.NetAPIManagerCorrectWithParamsData(manager: self, paramsdata: params) == false {
            self.failedOnCallingAPI(response: nil, errorType: .NetAPIManagerErrorTypeParamsError)
            return 0
        }
        
        //是否有缓存
        //...
        
        //正式进行网络请求
        switch self.requestType {
        //GET
        case NetAPIManagerRequestType.NetMangerRequesetTypeGet:
            
            requetId = NetHTTPSessionManager.session.callGETWithUrl(url: url as String, params: params, success: { (response) in
                
                   self.successedOnCallingAPI(response: response)
                
                }, failure: { (response) in
                    
                    self.failedOnCallingAPI(response: response, errorType: .NetAPIManagerErrorTypeNoNetWork)
            })
            
        //POST
        case NetAPIManagerRequestType.NetMangerRequesetTypePost:
            
            requetId = NetHTTPSessionManager.session.callPOSTWithUrl(url: url as String, params: params, success: { (response) in
                
                    self.successedOnCallingAPI(response: response)
                
                }, failure: { (response) in
                    
                    self.failedOnCallingAPI(response: response, errorType: .NetAPIManagerErrorTypeNoNetWork)
            })
            
        }
        
        //将请求Id加入请求列表
        self.requestIdList.add(NSNumber.init(value: requetId))
        
        let apiParams = params.mutableCopy() as! NSMutableDictionary
        apiParams.setObject(NSNumber.init(integerLiteral: requetId), forKey: NetAPIBaseManagerRequestID)
        //请求发起后的拦截
        self.intercetor?.afterCallingAPIWithParams?(manager: self, params: params)
        return requetId
    
   }
    
    /**
     * 请求成功
     */
    func successedOnCallingAPI(response:NetworkingURLResponse?) -> Void {
        
        if response?.content != nil {
            self.fetchedRawData = response?.content
        }else{
           self.fetchedRawData = response?.responseData
        }
        
        //移除请求列表中请求成功的请求
        self.requestIdList.remove(response?.requestId)
        
        //验证请求回来的数据
        if self.validator?.NetAPIManagerCorrecWithCallBackData(manager: self, callBackdata: response?.content as! NSDictionary) == true  {
            
            //判断缓存
            //...
            
            self.errorType = .NetAPIManagerErrorTypeSuccess
            self.intercetor?.beforePerformSuccessWithResponse?(manager: self, response: response)
            self.delegate?.NetAPIManagerRequestSuccessBackData(manager: self)
            self.intercetor?.afterPerformSuccessWithResponse?(manager: self, response: response)
            
        }else{
           self.failedOnCallingAPI(response: response, errorType: .NetAPIManagerErrorTypeNoContent)
        }
    }
    
    
    /**
     * 请求失败
     */
    func failedOnCallingAPI(response:NetworkingURLResponse?,errorType:NetAPIManagerErrorType) -> Void {

        //处理各种失败原因
        if response?.status == NetURLResponseStatus.NetURLResponseStatusErrorTimeout {
            self.errorType = NetAPIManagerErrorType.NetAPIManagerErrorTypeTimeout
            MBHUD.showHUDModeOnlyLabelsAddedTo(view: SNWindow!!, animated: true, text: "网络请求超时，请稍后再试")
        }else{
            self.errorType = errorType
            switch errorType {
            case .NetAPIManagerErrorTypeNoNetWork:
                 MBHUD.showHUDModeOnlyLabelsAddedTo(view: SNWindow!!, animated: true, text: "没有网络，请开启网络")
            case .NetAPIManagerErrorTypeParamsError:
                MBHUD.showHUDModeOnlyLabelsAddedTo(view: SNWindow!!, animated: true, text: "参数错误")
            case .NetAPIManagerErrorTypeNoContent:
                 MBHUD.showHUDModeOnlyLabelsAddedTo(view: SNWindow!!, animated: true, text: "返回的数据内容错误")
            default:
                print("")
            }
        }
        
        //移除请求列表中请求失败的请求
        self.requestIdList.remove(response?.requestId)
        //
        self.intercetor?.beforePerformFailWithResponse?(manager: self, response: response)
        self.delegate?.NetAPIManagerRequestFailedBackData(manager: self)
        self.intercetor?.afterPerformFailWithResponse?(manager: self, response: response)
    }
    
    
      // MARK: - 单独取消请求
    func cancelRequestWithRequestId(requestId:NSNumber) {
        
        if self.requestIdList.contains(requestId) {
            self.requestIdList.remove(requestId)
            NetHTTPSessionManager.session.cancelRequestWithRequestId(requestID: requestId)
        }
    }
    
      // MARK: -取消所有请求
    func cancelAllRequest() {
        
        NetHTTPSessionManager.session.cancelRequestWithRequestIDList(requestIDList: self.requestIdList)
        self.requestIdList.removeAllObjects()
    }
    
      // MARK: - 处理返回的数据 -
    func fetchDataWithReformer(reformer:NetAPIManagerCallbackDataReformer) -> Any? {
        
      let data = reformer.managerReformData(manager: self, data: self.fetchedRawData as? NSDictionary)
        if data != nil{
            return data
        }else{
           return self.fetchedRawData
        }
    }
    
}


