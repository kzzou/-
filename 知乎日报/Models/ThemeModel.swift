//
//  File.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/6.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import HandyJSON

struct ThemeResponseModel: HandyJSON {
    var others: [ThemeModel]?
}

struct ThemeModel: HandyJSON {
    var color: String?
    var thumbnail: String?
    var id: Int?
    var description: String?
    var name: String?
}
