//
//  CommonTool.swift
//  KzMist
//
//  Created by 邹凯章 on 16/10/9.
//  Copyright © 2016年 邹凯章. All rights reserved.
//

import Foundation
import UIKit

func KzLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
    #if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
}

extension UIDevice {
    func isiPhoneX() -> Bool {
        if UIScreen.main.bounds.equalTo(CGRect(x: 0, y: 0, width: 375, height: 812)) {
            return true
        } else {
            return false
        }
    }
    
    func statusBarHight() -> CGFloat {
        return self.isiPhoneX() ? 40 : 20
    }
    
    func navBarHight() -> CGFloat {
        return 44
    }
    
    func navBarBottom() -> CGFloat {
        return self.isiPhoneX() ? 88 : 64
    }
    
    func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func screenHight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
