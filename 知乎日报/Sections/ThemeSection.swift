//
//  ThemeSection.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/6.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import RxDataSources

struct ThemeSection {

    var items: [ThemeModel]
}

extension ThemeSection: SectionModelType {
    
    typealias Item = ThemeModel
    
    var identity: String {
        return ""
    }
    
    init(original: ThemeSection, items: [Item]) {
        
        self = original
        self.items = items
    }
    
}
