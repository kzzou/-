//
//  MenuTableViewCellReactor.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/6/21.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import RxSwift
import ReactorKit

final class MenuTableViewCellReactor: Reactor {
    typealias Action = NoAction
    
    let initialState : ThemeModel
    
    init(themeModel: ThemeModel) {
        initialState = themeModel
    }
    
}
