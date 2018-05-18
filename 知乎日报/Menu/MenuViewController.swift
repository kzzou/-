//
//  MenuViewController.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/3/8.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Moya
import ReactorKit
import Then
import SlideMenuControllerSwift

final class MenuViewController: BaseViewController, StoryboardView{
    
    // MARK: - 属性
    @IBOutlet weak var tableView: UITableView!

    // MARK: - 生命周期
    override func viewDidLoad() {
        
        steupView()
        super.viewDidLoad()
    }
    
    override func setupConstraints() {
        
        super.setupConstraints()
    }

    // MARK: - 内部方法
    fileprivate func steupView() {
        
        tableView.refreshControl = UIRefreshControl()
    }
    
    private func configView() {
        
        
    }
    
    // MARK: - 绑定
    func bind(reactor: MenuViewReactor) {
        // 代理
        self.tableView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
        
        // DataSource
        let dataSource = RxTableViewSectionedReloadDataSource<ThemeSection>(configureCell: { ds, tv, ip, item in
            let cell = (tv.dequeueReusableCell(withIdentifier: "MenuCell") ?? MenuTableViewCell(style: .default, reuseIdentifier: "MenuCell")) as! MenuTableViewCell
            
            cell.reactor = MenuTableViewCellReactor(themeModel: item)
            return cell
        })

        // Action
        self.rx.viewWillAppear
            .map{ _ in Reactor.Action.refresh}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        tableView.refreshControl!.rx.controlEvent(UIControlEvents.valueChanged)
            .map{_ in Reactor.Action.refresh}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.asObservable().map{$0.sections}
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable().map{$0.isRefreshing}
            .distinctUntilChanged()
            .bind(to: self.tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        
        // view
        tableView.rx.modelSelected(ThemeModel.self)
            .subscribe(onNext: { [weak self] (themeModel) in
                guard let `self` = self else { return }
                
                NotificationCenter.default.post(name: NSNotification.Name.init("themeModel"), object: nil, userInfo: ["themeModel": themeModel])
                self.slideMenuController()?.closeLeft()
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - 代理
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
}
