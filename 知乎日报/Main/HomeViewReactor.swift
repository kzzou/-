//
//  HomeViewReactor.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/3.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit
import Moya
import RxOptional

final class HomeViewReactor: Reactor {
    
    typealias ListSection = SectionModel<String, StoryModel>
    // MARK: - 常量
    
    // MARK: - 结构
    enum Action {
        case loadData
        case loadMoreData
    }
    
    enum Mutation {
        case setSections([ListSection])
        case addSections([ListSection])
        case setBannerDataSource([StoryModel])
        case setRefreshStatus(RefreshStatus)
    }
    
    struct State {
        var refreshStatus:RefreshStatus?
        var bannerDataSource: [StoryModel]?
        var sections: [ListSection]?
    }
    
    enum RefreshStatus: Int {
        case InvaliData             // 无效数据
        case DropDownSuccess        // 下拉成功
        case PullSuccessHasMoreData // 上拉还有更多数据
        case PullSuccessNoMoreData  // 上拉没有更多数据
    }
    
    // MARK: - 属性
    fileprivate var disposeBag = DisposeBag()
    fileprivate let provider: ServiceProvider
    fileprivate var newsData = ""
    
    let initialState = State()
    
    init(provider: ServiceProvider) {
        self.provider = provider
    }
    
    // MARK: - 方法
    func mutate(action: HomeViewReactor.Action) -> Observable<HomeViewReactor.Mutation> {
        
        switch(action){
        case .loadData:
            let storyResponseModel = provider.netWorkService.apiService
                .rx
                .request(ApiServices.getNewsList).asObservable()
                .mapString()
                .mapResponseModel(StoryResponseModel.self)

            storyResponseModel
                .subscribe(onNext: { (model) in
                    guard let date = model.date else {
                        return
                    }
                    self.newsData = date
                })
                .disposed(by: disposeBag)

            let setSections = storyResponseModel
                .map({ (storyResponseModel) -> ListSection in
                    var items = [StoryModel]()

                    items += storyResponseModel.stories!
                    return ListSection(model: storyResponseModel.date!, items: items)
                })
                .map({ (listSection) -> [ListSection] in
                    return [listSection]
                })
                .map{Mutation.setSections($0)}

            let setBannerDataSource = storyResponseModel
                .map({ (storyResponseModel) -> [StoryModel] in
                    storyResponseModel.top_stories!
                })
                .map{Mutation.setBannerDataSource($0)}
            
            let endRefreshStatus = Observable<Mutation>.just(.setRefreshStatus(RefreshStatus.DropDownSuccess))
            
            return Observable.concat([setBannerDataSource, setSections, endRefreshStatus])
        case .loadMoreData:
            let storyResponseModel = provider.netWorkService.apiService
                .rx
                .request(ApiServices.getMoreNews(self.newsData)).asObservable()
                .mapString()
                .mapResponseModel(StoryResponseModel.self)
            
            storyResponseModel
                .subscribe(onNext: { (model) in
                    guard let date = model.date else {
                        return
                    }
                    self.newsData = date
                })
                .disposed(by: disposeBag)
            
            let addSections = storyResponseModel
                .map({ (storyResponseModel) -> ListSection in
                    var items = [StoryModel]()
                    
                    items += storyResponseModel.stories!
                    return ListSection(model: storyResponseModel.date!, items: items)
                })
                .map({ (listSection) -> [ListSection] in
                    return [listSection]
                })
                .map{Mutation.addSections($0)}
            
            let endRefreshStatus = Observable<Mutation>.just(.setRefreshStatus(RefreshStatus.PullSuccessHasMoreData))
            return Observable.concat([addSections, endRefreshStatus])
        }
    }
    
    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutation) -> HomeViewReactor.State {
        
        var state = state
        switch(mutation) {
        case let .setRefreshStatus(refreshStatus) :
            state.refreshStatus = refreshStatus
            return state
        case let .setSections(sections):
            state.sections = sections
            return state
        case let .addSections(sections):
            state.sections = state.sections! + sections
            return state
        case  let .setBannerDataSource(bannerDataSource):
            state.bannerDataSource = bannerDataSource
            return state
        }
    }
}
