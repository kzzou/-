//
//  ToModelExtension.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/3/10.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import HandyJSON

extension ObservableType where E == String {
    public func mapResponseModel<T: HandyJSON>(_ type: T.Type) -> Observable<T> {
        return self.flatMap{ (jsonString) -> Observable<T> in
            return Observable.just(JSONDeserializer<T>.deserializeFrom(json: jsonString)!)
        }
    }
}

