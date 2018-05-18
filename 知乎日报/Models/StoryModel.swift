//
//  StoryModel.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/6.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import HandyJSON

struct StoryResponseModel: HandyJSON {
    var date: String?
    var stories: [StoryModel]?
    var top_stories: [StoryModel]?
}

struct StoryModel: HandyJSON {
    var ga_prefix: String?
    var id: Int?
    var images: [String]?   // list_stories
    var title: String?
    var type: Int?
    var image: String?      // top_stories
    var multipic = false
}
