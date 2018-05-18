//
//  UIView+Rx.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/8/11.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension Reactive where Base: UIView{
    
    var willMove: Observable<UIWindow?> {
        return self.sentMessage(#selector(Base.willMove(toWindow:))).map{
            $0.first as? UIWindow
        }
    }
}
