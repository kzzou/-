//
//  NewsDetailModel.swift
//  知乎日报
//
//  Created by 邹凯章 on 2018/5/4.
//  Copyright © 2018年 邹凯章. All rights reserved.
//

import Foundation
import HandyJSON

struct NewsDetailModel: HandyJSON {
    var body: String?
    var ga_prefix: String?
    var id: Int?
    var image: String?
    var image_source: String?
    var share_url: String?
    var title: String?
    var type: Int?
    var images: [String]?
    var css: [String]?
    var js: [String]?
}
