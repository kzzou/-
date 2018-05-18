//
//  BaseService.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/4.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation

class BaseService {
    unowned let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
}
