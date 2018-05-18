//
//  DetailsViewReactor.swift
//  知乎日报
//
//  Created by 邹凯章 on 2018/5/3.
//  Copyright © 2018年 邹凯章. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit
import RxOptional

class DetailsViewReactor: Reactor {
    // MARK: - 结构
    enum Action {
        case loadData
        case loadBackData
        case loadNextData
    }
    
    enum Mutation {
        case setImage(String)
        case setTitle(String)
        case setHtml(String)
        case setRefreshStatus(RefreshStatus)
    }
    
    struct State {
        var refreshStatus:RefreshStatus?
        var image: String?
        var title: String?
        var Html: String?
    }
    
    enum RefreshStatus: Int {
        case DropDownHasMoreData        // 下拉还有更多数据
        case DropDownNoMoreData         // 下拉没有更多数据
        case PullHasMoreData            // 上拉还有更多数据
        case PullNoMoreData             // 上拉没有更多数据
    }
    
    // MARK: - 内部属性
    fileprivate var disposeBag = DisposeBag()
    fileprivate let provider: ServiceProvider
    // MARK: - 外部属性
    let initialState = State()
    var currentStoryModel = StoryModel()
    
    init(provider: ServiceProvider) {
        self.provider = provider
    }
    // MARK: - 内部方法
    fileprivate func concatHTML(css: [String], body: String) -> String {
        var html = "<html>"
        html += "<head>"
        css.forEach { html += "<link rel=\"stylesheet\" href=\($0)>" }
        html += "<style>img{max-width:320px !important;}</style>"
        html += "</head>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</html>"
        return html
    }
    // MARK: - 转换方法
    func mutate(action: DetailsViewReactor.Action) -> Observable<DetailsViewReactor.Mutation> {
        
        switch(action){
        case .loadData:
            let newsDetailModel = provider.netWorkService.apiService
                .rx
                .request(ApiServices.getNewsDesc(currentStoryModel.id!)).asObservable()
                .mapString()
                .mapResponseModel(NewsDetailModel.self)
            
            let setImage = newsDetailModel
                .map{ (model) -> Mutation in
                    Mutation.setImage(model.image!)
                }
            let setTitle = newsDetailModel
                .map { (model) -> Mutation in
                    Mutation.setTitle(model.title!)
                }
            let setHtml = newsDetailModel
                .map { (model) -> Mutation in
                    Mutation.setHtml(self.concatHTML(css: model.css!, body: model.body!))
                }
            return Observable.concat([setImage, setTitle, setHtml])
        case .loadBackData:
            
            let endRefreshStatus = Observable<Mutation>.just(.setRefreshStatus(RefreshStatus.DropDownHasMoreData))
            return Observable.concat([endRefreshStatus])
            
        case .loadNextData:
            
            let endRefreshStatus = Observable<Mutation>.just(.setRefreshStatus(RefreshStatus.PullHasMoreData))
            return Observable.concat([endRefreshStatus])
        }
    }
    
    func reduce(state: DetailsViewReactor.State, mutation: DetailsViewReactor.Mutation) -> DetailsViewReactor.State {
        
        var state = state
        switch(mutation) {
        case let .setRefreshStatus(refreshStatus) :
            state.refreshStatus = refreshStatus
            return state
        case let .setImage(imageString):
            state.image = imageString
            return state
        case let .setTitle(titleString):
            state.title = titleString
            return state
        case let .setHtml(htmlString):
            state.Html = htmlString
            return state
        }
    }
}
