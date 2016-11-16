//
//  SNPageView.swift
//  SN_SWIFT_Framwork
//
//  Created by huangshuni on 2016/11/14.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit


protocol SNPageViewDataSourse {
    func numberOfItemInSNPageView(pageView:SNPageView) -> Int
    func pageViewAtIndex(pageView:SNPageView,index:Int) -> UIView
}

protocol SNPageViewDelegate {
    func didScrollToIndex(index:NSInteger)
}

class SNPageView: UIView,UIScrollViewDelegate {

    var scrollView:UIScrollView?
    var numberOfItems:Int = 0
    var scrollAnimation = false
    var currentIndex:Int = 0
    
    
    var dataSourse:SNPageViewDataSourse?
    var delegate : SNPageViewDelegate?
    
    //保存的是下面的一个一个的View
    lazy var itemsArr:NSMutableArray = {
        let innerItemsArr = NSMutableArray()
        let total:NSInteger = (self.dataSourse?.numberOfItemInSNPageView(pageView: self))!
        for index in 0..<total{
         innerItemsArr.add(NSNull())
        }
        return innerItemsArr
    }()
    
    
   override init(frame: CGRect) {
        super.init(frame: frame)
    
       self.customView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customView() {
        
        self.scrollView = UIScrollView.init(frame: self.bounds)
        self.scrollView?.delegate = self
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.isPagingEnabled = true
        self.addSubview(self.scrollView!)
    }
    
    func reloadData() {
        
        self.numberOfItems = (self.dataSourse?.numberOfItemInSNPageView(pageView: self))!
        self.scrollView?.contentSize = CGSize.init(width: SCREEN_WIDTH * CGFloat.init(self.numberOfItems), height: SCREEN_HEIGHT)
    }
    
      // MARK: -移动view
    func changeToItemAtIndex(index:Int)  {
        
        //如果没有这个View那么就加在这个view
        print(self.itemsArr[index])
        
        if self.itemsArr[index] is NSNull {
            self.loadViewAtIndex(index: index)
        }
        
        //移动到对应的view
        self.scrollView?.setContentOffset(CGPoint.init(x: CGFloat.init(index) * SCREEN_WIDTH, y: 0), animated: scrollAnimation)
       
        //预加载View
        self.preLoadViewWithIndex(index: index)

        self.currentIndex = index;

    }
    
    
      // MARK: -加载view
    func loadViewAtIndex(index:Int) {
        let view:UIView = (self.dataSourse?.pageViewAtIndex(pageView: self, index: index))!
        view.frame = CGRect.init(x: SCREEN_WIDTH*CGFloat.init(index), y: 0, width: SCREEN_WIDTH, height: self.bounds.size.height)
        self.scrollView?.addSubview(view)
        self.itemsArr.replaceObject(at: index, with: view)
    }
    
      // MARK: -预加载当前选中的View之前和之后的view
    func preLoadViewWithIndex(index:Int) {
        
        if index > 0 && self.itemsArr[index - 1] is NSNull {
            self .loadViewAtIndex(index: (index-1))
        }
        
        if index < (self.numberOfItems-1) && self.itemsArr[index + 1] is NSNull{
            self.loadViewAtIndex(index: (index+1))
        }

    }
    
    
    // MARK: -UIScrollViewDelegate
    //滑动下面的view
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index:Int = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
        if self.itemsArr[index] is NSNull {
            self.loadViewAtIndex(index: index)
        }
        self .preLoadViewWithIndex(index: index)
        
        if index != self.currentIndex {
            self.delegate?.didScrollToIndex(index: index)
            self.currentIndex = index
        }
    }
}
