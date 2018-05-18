//
//  ServiceProvider.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/4.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation

protocol ServiceProviderType: class {
    var netWorkService: NetWorkServiceType {get}
}

final class ServiceProvider: ServiceProviderType {
    lazy var netWorkService: NetWorkServiceType = NetWorkService.init(provider: self)
}
