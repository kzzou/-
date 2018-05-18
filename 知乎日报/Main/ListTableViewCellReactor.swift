//
//  ListTableViewCellReactor.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/6.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import ReactorKit

final class ListTableViewCellReactor: Reactor{
    
    // MARK: - 类型定义
    typealias Action = NoAction
    
    // MARK: - 属性
    let initialState: StoryModel
    
    // MARK: - 方法
    init(storyModel: StoryModel) {
        self.initialState = storyModel
    }
    
}
