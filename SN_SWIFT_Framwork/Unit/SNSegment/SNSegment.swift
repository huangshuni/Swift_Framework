//
//  SNSegment.swift
//  SN_SWIFT_Framwork
//
//  Created by huangshuni on 2016/11/14.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

protocol SNSegmentDelegate {
    
    func SNSegmentDidSelectIndex(segment:SNSegment,index:NSInteger)
}


class SNSegment: UIView {

    let scrollView = UIScrollView()
    var divideLineView = UIView()
    var divideView = UIView()
    
    var textFont:UIFont = UIFont.boldSystemFont(ofSize: 16)
    var selectedIndex:NSInteger = 0
    var delegate : SNSegmentDelegate?
    
    
    var allBtnWidth:CGFloat = 0
    var widthArray = NSMutableArray()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.customView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func customView() {
        
        self.scrollView.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: self.bounds.size.height - 0.5)
        scrollView.clipsToBounds = false
        scrollView.backgroundColor = UIColor.lightGray
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        self.addSubview(scrollView)
        
        self.divideLineView.backgroundColor = UIColor.groupTableViewBackground
        self.scrollView.addSubview(self.divideLineView)
        
        self.divideView.backgroundColor = UIColor.red
        self.scrollView.addSubview(self.divideView)
        
    }
    
    func updateChannels(itemsArr:NSArray) {

        let widthMutableArray = NSMutableArray()
        var totalW:CGFloat = 0
        for (index,value) in itemsArr.enumerated() {
            
            let buttonW:CGFloat =  (value as! String).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 20), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.textFont], context: nil).size.width + 20
            widthMutableArray.add(buttonW)
            
            let btn = UIButton.init(frame: CGRect.init(x: totalW, y: 0, width: buttonW, height: self.bounds.size.height))
            btn.tag = 1000 + index
            btn.titleLabel?.font = self.textFont
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            btn.setTitleColor(UIColor.red, for: UIControlState.selected)
            btn.setTitle(value as? String, for: UIControlState.normal)
            btn.addTarget(self, action: #selector(SNSegment.clickSegmentButton(selectButton:)), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(btn)
            totalW += buttonW
            
            if index == 0 {
                btn.isSelected = true
                self.divideView.frame = CGRect.init(x: 0, y: self.bounds.size.height - 2, width: buttonW, height: 2)
                self.selectedIndex = 0
            }
        }
        
        self.allBtnWidth = totalW
        self.widthArray = widthMutableArray
        scrollView.contentSize = CGSize.init(width: totalW, height: 0)
        self.divideLineView.frame = CGRect.init(x: 0, y: self.scrollView.frame.size.height - 2, width: totalW, height: 2)
        
    }
    
    func clickSegmentButton(selectButton:UIButton) {

        let oldSelectButton:UIButton = (self.scrollView.viewWithTag(self.selectedIndex + 1000)) as! UIButton
        oldSelectButton.isSelected = false
        
        selectButton.isSelected = true
        self.selectedIndex = selectButton.tag - 1000
        
        var totalW:Int = 0
        for index in 0..<selectedIndex {
            totalW += Int(self.widthArray[index] as!CGFloat)
        }
        
        
        //处理边界
        let selectW:Int = Int(widthArray[selectedIndex] as!CGFloat)
        var offset:CGFloat = CGFloat(totalW) + (CGFloat.init(selectW) - self.bounds.size.width)*0.5
        offset = min(self.allBtnWidth - self.bounds.size.width, max(0, offset))
        scrollView.setContentOffset(CGPoint.init(x: offset, y: 0), animated: true)
        
        //代理方法
        self.delegate?.SNSegmentDidSelectIndex(segment: self, index: self.selectedIndex)
        
        //滑块
        UIView.animate(withDuration: 0.1) { 
            self.divideView.frame = CGRect.init(x: CGFloat(totalW), y: self.divideView.frame.origin.y, width: CGFloat.init(selectW), height: self.divideView.frame.size.height)
        }

    }
    
    
    func didChangeToIndex(index:NSInteger) {
        let btn:UIButton = scrollView.viewWithTag(1000+index) as! UIButton
        clickSegmentButton(selectButton: btn)
    }


}
