//
//  MainViewReactor.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/12/20.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift
import RxCocoa

class MainViewReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var currentThemeModel = ThemeModel.init(color: nil, thumbnail: nil, id: nil, description: nil, name: "首页")
    }
    
    // MARK: - 属性
    var initialState = State()
    
    // MARK: - 方法
    func transform(state: Observable<MainViewReactor.State>) -> Observable<MainViewReactor.State> {
        
        let themeModel = NotificationCenter.default.rx.notification(Notification.Name.init("themeModel"))
            .map({ (notification) -> State in
                State(currentThemeModel: notification.userInfo?["themeModel"] as! ThemeModel)
            })
        
        return themeModel
    }
}
