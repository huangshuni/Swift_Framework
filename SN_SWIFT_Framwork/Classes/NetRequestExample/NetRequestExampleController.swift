//
//  NetRequestExampleController.swift
//  SN_SWIFT_Framwork
//
//  Created by huangshuni on 2016/11/11.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

class NetRequestExampleController: BaseViewController,NetAPIManagerCallBackDataDelegate,NetAPIManagerParamSourceDelegate,NetAPIManagerInterceptor {

    lazy var mainPageManager : RequestManager = {
        let innerRequestManager = RequestManager()
        innerRequestManager.delegate = self
        innerRequestManager.paramSource = self
        innerRequestManager.intercetor = self
        return innerRequestManager
    }()
    let reformer = RequestReformer()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let btn = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        btn.setTitle("请求数据", for: UIControlState.normal)
        btn.setTitleColor(UIColor.red, for: UIControlState.normal)
        btn.addTarget(self, action:#selector(NetRequestExampleController.loadData), for:UIControlEvents.touchUpInside)
        self.view.addSubview(btn)
        
    }
    
    func loadData()  {
        
         MBHUD.showHUDAddedTo(view: self.view, animated: true)
        
        
         self.mainPageManager.loadData()
    }
    
    
    // MARK: -NetworkingManagerParamSourceDelegate
    func NetAPIManagerParamsForAPI(manager:NetworkingBaseManager) -> NSDictionary{
        //给参数
        let parameters:NSDictionary = ["action":"getHomeDatas",
                                       "apikey":"a881b0448aa94a71",
                                       ]
        return parameters
    }
    
    // MARK: -NetworkingRequestBackDataDelegate
    func NetAPIManagerRequestSuccessBackData(manager: NetworkingBaseManager) {
        
        //请求成功
        MBHUD.hideHUDForView(view: self.view, animated: true)
        let data = manager.fetchDataWithReformer(reformer: reformer)
        print(data)//data为处理过的数据
        
    }
    func NetAPIManagerRequestFailedBackData(manager: NetworkingBaseManager) {
        
        MBHUD.hideHUDForView(view: self.view, animated: true)
        
        //请求失败后做的一些处理
    }
    
    
      // MARK: -NetAPIManagerInterceptor（下面的代理方法都是可选的）
    func beforePerformSuccessWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void{
        
        //在请求成功NetAPIManagerRequestSuccessBackData之前
    }
    func afterPerformSuccessWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void{
    
        //在请求成功NetAPIManagerRequestSuccessBackData之后调用
    }
   
    func beforePerformFailWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void{
    
        //在请求失败NetAPIManagerRequestFailedBackData之前
    }
   
    func afterPerformFailWithResponse(manager:NetworkingBaseManager,response:NetworkingURLResponse?) -> Void{
    
        //在请求失败NetAPIManagerRequestFailedBackData之后
    }
    
    
}
