//
//  NetWorkService.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/4.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

protocol NetWorkServiceType {
    var apiService: MoyaProvider<ApiServices> {get}
}

final class NetWorkService: BaseService, NetWorkServiceType {
    
    var apiService = MoyaProvider<ApiServices>()
}
