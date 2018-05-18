//
//  DetailsViewController.swift
//  知乎日报
//
//  Created by 邹凯章 on 2018/5/3.
//  Copyright © 2018年 邹凯章. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit
import ReactorKit
import MJRefresh
import Kingfisher

class DetailsViewController: BaseViewController, StoryboardView {
    
    // MARK: - 属性

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        steupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        configView()
    }
    
    override func setupConstraints() {
        
    }
    
    // MARK: - 内部方法
    fileprivate func steupView() {
        
        self.webView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.reactor?.action.onNext(DetailsViewReactor.Action.loadBackData)
        })
        
        self.webView.scrollView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.reactor?.action.onNext(DetailsViewReactor.Action.loadNextData)
        })
    }
    
    fileprivate func configView() {
    
        
    }
    
    // MARK: - 外部方法
    func loadData(model: StoryModel) {
        self.reactor?.currentStoryModel = model
        self.reactor?.action.onNext(DetailsViewReactor.Action.loadData)
    }
    // MARK: - 绑定
    func bind(reactor: DetailsViewReactor) {
        
        // Action
        
        // State
        reactor.state.asObservable()
            .map{$0.title}
            .filterNil()
            .subscribe(onNext: { [unowned self] (titleString) in
                self.title = titleString
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{$0.refreshStatus}
            .filterNil()
            .subscribe(onNext: { (refreshStatus) in
                KzLog("\(refreshStatus)")
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map {$0.Html}
            .filterNil()
            .subscribe(onNext: { [unowned self] (htmlString) in
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            })
            .disposed(by: self.disposeBag)
        // View
    }
}
