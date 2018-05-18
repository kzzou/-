//
//  MenuViewReactor.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/6/21.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import ReactorKit

final class MenuViewReactor: Reactor {
    
    // MARK: - 类型定义
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setSections([ThemeSection])
    }
    
    struct State {
        var sections = [ThemeSection(items: [])]
        var isRefreshing = false
    }
    
    // MARK: - 属性
    fileprivate let provider: ServiceProviderType
    let initialState = State()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    // MARK: - 方法
    func mutate(action: MenuViewReactor.Action) -> Observable<MenuViewReactor.Mutation> {
        switch action {
        case .refresh:
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
            let setSections = provider.netWorkService.apiService
                    .rx
                    .request(ApiServices.getThemeList)
                    .asObservable()
                    .mapString()
                    .mapResponseModel(ThemeResponseModel.self)
                    .map({ (themeResponseModel) -> ThemeSection in
                        var items = [ThemeModel]()
                        items.append(ThemeModel(color: "", thumbnail: "", id: 0, description: "", name: "首页"))
                        items += themeResponseModel.others!
                        return ThemeSection(items: items)
                    })
                    .map({ (MenuSection) -> [ThemeSection] in
                        return [MenuSection]
                    })
                    .map{Mutation.setSections($0)}
            return Observable.concat([startRefreshing, setSections, endRefreshing])
        }
    }
    
    func reduce(state: MenuViewReactor.State, mutation: MenuViewReactor.Mutation) -> MenuViewReactor.State {
        
        var state = state
        switch mutation {
        case let .setSections(sections):
            state.sections = sections
            return state
        case let .setRefreshing(isRefreshing):
            state.isRefreshing = isRefreshing
            return state
        }
    }
    
}
