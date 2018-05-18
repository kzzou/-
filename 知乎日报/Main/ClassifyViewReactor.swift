//
//  ClassifyViewReactor.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/12/23.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
import ReactorKit
import Moya

class ClassifyViewReactor: Reactor {
    
    typealias ListSection = SectionModel<String, StoryModel>
    // MARK: - 常量
    
    // MARK: - 结构
    enum Action {
        case loadData
    }
    
    enum Mutation {
        case setTitle(String)
        case setSections([ListSection])
        case setRefreshStatus(RefreshStatus)
    }
    
    struct State {
        var title: String = ""
        var refreshStatus: RefreshStatus = .InvaliData
        var sections:[ListSection] = []
    }
    
    enum RefreshStatus: Int {
        case InvaliData             // 无效数据
        case DropDownSuccess        // 下拉成功
    }
    
    // MARK: - 内部属性
    fileprivate var disposeBag = DisposeBag()
    fileprivate let provider: ServiceProvider
    
    // MARK: - 外部属性
    var currentThemeModel = ThemeModel()
    
    let initialState = State()
    
    init(provider: ServiceProvider) {
        self.provider = provider
    }
    
    // MARK: - 内部方法
    func mutate(action: ClassifyViewReactor.Action) -> Observable<ClassifyViewReactor.Mutation> {
        
        switch(action){
        case .loadData:
            
            let setTitle = Observable<Mutation>.just(.setTitle(currentThemeModel.name!))
            
            let storyResponseModel = provider.netWorkService.apiService
                .rx
                .request(ApiServices.getThemeDesc(currentThemeModel.id!)).asObservable()
                .mapString()
                .mapResponseModel(StoryResponseModel.self)
            
            let setSections = storyResponseModel
                .map({ (storyResponseModel) -> ListSection in
                    var items = [StoryModel]()
                    
                    items += storyResponseModel.stories!
                    return ListSection(model: storyResponseModel.date ?? "", items: items)
                })
                .map({ (listSection) -> [ListSection] in
                    return [listSection]
                })
                .map{Mutation.setSections($0)}
            
            let endRefreshStatus = Observable<Mutation>.just(.setRefreshStatus(RefreshStatus.DropDownSuccess))
            
            return Observable.concat([setTitle, setSections, endRefreshStatus])
        }
    }
    
    func reduce(state: ClassifyViewReactor.State, mutation: ClassifyViewReactor.Mutation) -> ClassifyViewReactor.State {
        
        var state = state
        switch(mutation) {
        case let .setRefreshStatus(refreshStatus):
            state.refreshStatus = refreshStatus
            return state
        case let .setSections(sections):
            state.sections = sections
            return state
        case let .setTitle(title):
            state.title = title
            return state
        }
    }
    
    // MARK: - 外部方法
}
