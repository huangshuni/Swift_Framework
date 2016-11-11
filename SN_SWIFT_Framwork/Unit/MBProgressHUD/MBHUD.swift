//
//  MBHUD.swift
//  LKB_SWIFT
//
//  Created by huangshuni on 2016/11/9.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

class MBHUD: NSObject {
    
  // MARK: - 没有文本框的一朵小菊花,
   static func showHUDAddedTo(view:UIView ,animated:Bool) {
       MBProgressHUD.showAdded(to: view, animated: animated)
    }
    
  // MARK: - 带文本框的菊花
    static func showHUDWithTextAddedTo(view:UIView ,animated:Bool,text:String?) {
        let HUD = MBProgressHUD.showAdded(to: view, animated: animated)
        HUD.label.text = text
    }
    
  // MARK: -Ring-shaped progress view. （环状的)
    static func showHUDModeAnnularDeterminateAddedTo(view:UIView ,animated:Bool,text:String?) {
        let HUD = MBProgressHUD.showAdded(to: view, animated: animated)
        HUD.mode = MBProgressHUDMode.annularDeterminate
        HUD.label.text = text
    
        //HUD.progress = 0.5 //要设置进度设置他就好了
    }
    
    // MARK: -A round, pie-chart like, progress view. （饼状,其实就是比环状面积宽一点)
    static func showHUDModeDeterminateAddedTo(view:UIView ,animated:Bool,text:String?) {
        let HUD = MBProgressHUD.showAdded(to: view, animated: animated)
        HUD.mode = MBProgressHUDMode.determinate
        HUD.label.text = text
        
        //HUD.progress = 0.5 //要设置进度设置他就好了
    }
    
    // MARK: -Horizontal progress bar. （条形进度)
    static func showHUDModeHorizontalBarAddedTo(view:UIView ,animated:Bool,text:String?) {
        let HUD = MBProgressHUD.showAdded(to: view, animated: animated)
        HUD.mode = MBProgressHUDMode.determinateHorizontalBar
        HUD.label.text = text
    }
    
    // MARK: -Shows only labels. （页面中间纯文本提示框，自动消失)
    static func showHUDModeOnlyLabelsAddedTo(view:UIView ,animated:Bool,text:String?) {
        let HUD = MBProgressHUD.showAdded(to: view, animated: animated)
        HUD.mode = MBProgressHUDMode.text
        HUD.label.text = text
        HUD.hide(animated: true, afterDelay: 2.0)
    }
    
    // MARK: -Shows only labels. （底部纯文本提示框,自动消失)
    static func showHUDModeBottomOnlyLabelsAddedTo(view:UIView ,animated:Bool,text:String?) {
        let HUD = MBProgressHUD.showAdded(to: view, animated: animated)
        HUD.mode = MBProgressHUDMode.text
        HUD.label.text = text
        HUD.offset = CGPoint.init(x: 0.0, y:  SCREEN_HEIGHT/2 - 100)
        HUD.hide(animated: true, afterDelay: 2.0)
    }
    
    // MARK: -Shows a custom view. （自定义提示框)
    static func showHUDModeCustomViewAddedTo(view:UIView ,animated:Bool,customView:UIView, text:String?) {
        let HUD = MBProgressHUD.showAdded(to: view, animated: animated)
        HUD.mode = MBProgressHUDMode.customView
        HUD.customView = customView
        HUD.label.text = text
    }
    
//    // MARK: - 为HUD设置进度
//    static func setHUDProgress(view:UIView, progress:Float){
//        let HUD = MBProgressHUD.HUDForView(view:view)
//        HUD?.progress = progress
//    }
    
    
  // MARK: - 隐藏hud
  static func hideHUDForView(view:UIView ,animated:Bool) {
        MBProgressHUD.hide(for: view, animated: animated)
    }
    
}
