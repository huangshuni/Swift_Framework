//
//  UIColor_EColor.swift
//  LKB_SWIFT
//
//  Created by huangshuni on 2016/11/8.
//  Copyright © 2016年 huangshuni. All rights reserved.
//

import UIKit

extension UIColor{
    
   static func ColorWithRGB(R:CGFloat,G:CGFloat,B:CGFloat) -> UIColor {
        
        return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
    }
    
    static func ColorWithRGBA(R:CGFloat,G:CGFloat,B:CGFloat,A:CGFloat) -> UIColor {
        return UIColor.init(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
    }
    


}
