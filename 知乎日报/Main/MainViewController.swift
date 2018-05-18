//
//  MainViewController.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/12/20.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SlideMenuControllerSwift

class MainViewController: BaseTabarViewController,StoryboardView {
    typealias Reactor = MainViewReactor
    
    // MARK: - 属性
    // 主页视图控制器
    var homeViewController: HomeViewController = {
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
        let serviceProvider = ServiceProvider()
        viewController.reactor = HomeViewReactor(provider: serviceProvider)
        return viewController
        }()
    // 分类视图控制器
    var classifyViewController: ClassifyViewController = {
        let viewController = UIStoryboard(name: "Classify", bundle: nil).instantiateInitialViewController() as! ClassifyViewController
        let serviceProvider = ServiceProvider()
        viewController.reactor = ClassifyViewReactor(provider: serviceProvider)
        return viewController
        }()
    // MARK: - 生命周期
    override func viewDidLoad() {
        
        setupView()
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        configView()
    }
    
    // MARK: - 内部方法
    fileprivate func setupView() {
        
        let navHomeViewController = UINavigationController(rootViewController: homeViewController)
        let navClassifyViewController = UINavigationController(rootViewController: classifyViewController)
        
        self.setViewControllers([navHomeViewController,navClassifyViewController], animated: true)
    }
    
    fileprivate func configView() {
        
        self.selectedIndex = 0
        self.tabBar.isHidden = true
    }
    
    // MARK: - 绑定
    func bind(reactor: MainViewController.Reactor) {
        
        reactor.state.asObservable()
            .map{$0.currentThemeModel}
            .subscribe(onNext: {[unowned self] (themeModel) in
                if themeModel.id == 0 || themeModel.id == nil{
                    self.selectedIndex = 0
                } else {
                    self.selectedIndex = 1
                    self.classifyViewController.loadData(mode: themeModel)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}
