//
//  SNSegmentController.swift
//  SN_SWIFT_Framwork
//
//  Created by huangshuni on 2016/11/14.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

class SNSegmentController: BaseViewController,SNPageViewDelegate,SNPageViewDataSourse,SNSegmentDelegate {

    var segment:SNSegment?
    var pageView : SNPageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        segment = SNSegment.init(frame: CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 40))
        segment?.updateChannels(itemsArr: ["首页","文章","好东西","早点与宵夜","电子小物","苹果","收纳集合","JBL","装b利器","测试机啦啦","乱七八糟的"])
        segment?.delegate = self
        self.view.addSubview(segment!)
//        segment?.customView()
        
        
        pageView = SNPageView.init(frame: CGRect.init(x: 0, y: 100+40, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        pageView?.backgroundColor = UIColor.blue
        pageView?.delegate = self
        pageView?.dataSourse = self
        pageView?.reloadData()
        pageView?.changeToItemAtIndex(index: 0)
        self.view.addSubview(pageView!)
        
    }
    
      // MARK: -SNPageViewDelegate
    func didScrollToIndex(index: NSInteger) {
        segment?.didChangeToIndex(index: index)
    }
    
      // MARK: -SNPageViewDataSourse
    func numberOfItemInSNPageView(pageView: SNPageView) -> Int {
        return 11
    }
    
    func pageViewAtIndex(pageView: SNPageView, index: Int) -> UIView {
        
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        let lable:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 100, width: SCREEN_WIDTH, height: 100))
        lable.text = String(index)
        lable.textAlignment = NSTextAlignment.center
        view.addSubview(lable)
        return view
    }
    
      // MARK: - SNSegmentDelegate
    func SNSegmentDidSelectIndex(segment: SNSegment, index: NSInteger) {
        pageView?.changeToItemAtIndex(index: index)
    }

}
