//
//  ViewController.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/3/8.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit
import MJRefresh
import SVProgressHUD
import RxOptional

class HomeViewController: BaseViewController ,StoryboardView{

    // MARK: - 属性

    @IBOutlet weak var bannerView: KzBannerView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource :RxTableViewSectionedReloadDataSource<SectionModel<String, StoryModel>>?
    // MARK: - 生命周期
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        configView()
    }
    
    override func setupConstraints() {
        
        super.setupConstraints()
    }
    
    deinit {
        
        removeNavigationBarItem()
    }
    
    // MARK: - 内部方法
    private func setupView() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.reactor?.action.onNext(HomeViewReactor.Action.loadData)
        })
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [unowned self] in
            self.reactor?.action.onNext(HomeViewReactor.Action.loadMoreData)
        })
    }
    
    private func configView() {
        
        self.navigationItem.title = "今日热文"
        // 设置轮播视图高度
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250)
        // 注册cell
        let cellNib = UINib(nibName: "ListCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ListTableViewCell")
        // 设置视图延伸到整个屏幕
        self.edgesForExtendedLayout = UIRectEdge.all
        // 导航栏设置
        self.navigationController?.navigationBar.kzSetBackgroundStatusColor(color: UIColor.blue)
        self.navigationController?.navigationBar.kzSetBackgroundStatusAlpha(alpha: 0.0)
        self.navigationController?.navigationBar.kzSetBackgroundNavColor(color: UIColor.blue)
        self.navigationController?.navigationBar.kzSetBackgroundNavAlpha(alpha: 0.0)
        setNavigationBarItem()
    }

    
    private func setNavigationBarItem() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "menu")!)
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    private func removeNavigationBarItem() {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    // MARK: - 外部方法
    
    // MARK: - 绑定
    func bind(reactor: HomeViewReactor) {
        // 代理
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        // dataSource
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, StoryModel>>(
            configureCell: { ds, tv, ip, item in
                let cell = tv.dequeueReusableCell(withIdentifier: "ListTableViewCell") as! ListTableViewCell
                cell.reactor = ListTableViewCellReactor(storyModel: item)
                return cell
            })
        self.dataSource = dataSource
        
        // Action
        self.rx.viewWillAppear.asObservable()
            .map{_ in HomeViewReactor.Action.loadData}
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.asObservable()
            .map{$0.sections}
            .filterNil()
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{$0.bannerDataSource}
            .filterNil()
            .bind(to: bannerView.imageDataSource)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{$0.refreshStatus}
            .filterNil()
            .subscribe(onNext: { [unowned self] (refreshStatus) in

                switch refreshStatus {
                case .InvaliData:
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_footer.endRefreshing()
                        return
                case .DropDownSuccess:
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.mj_footer.resetNoMoreData()
                        return
                case .PullSuccessHasMoreData:
                        self.tableView.mj_footer.endRefreshing()
                        return
                case .PullSuccessNoMoreData:
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        return
                }

            })
            .disposed(by: self.disposeBag)
        
        // View
        tableView.rx.contentOffset
            .subscribe(onNext: { [unowned self] (offset) in
                if offset.y > 1750 {
                    self.navigationController?.navigationBar.kzSetBackgroundNavAlpha(alpha: 0.0)
                    self.navigationItem.title = ""
                } else if offset.y > 250 {
                    self.tableView.contentInset = UIEdgeInsetsMake(UIDevice.current.statusBarHight(), 0, 0, 0)
                    self.navigationController?.navigationBar.kzSetBackgroundStatusAlpha(alpha: 1.0)
                    self.navigationController?.navigationBar.kzSetBackgroundNavAlpha(alpha: 1.0)
                    self.navigationItem.title = "今日热文"
                } else if offset.y >= 0 {
                    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                    let alpha = offset.y/(250.0 - UIDevice.current.navBarBottom())
                    self.navigationController?.navigationBar.kzSetBackgroundStatusAlpha(alpha: alpha)
                    self.navigationController?.navigationBar.kzSetBackgroundNavAlpha(alpha: alpha)
                }
            })
            .disposed(by: self.disposeBag)
        tableView.rx.modelSelected(StoryModel.self)
            .subscribe(onNext: { model in
                let viewController = UIStoryboard(name: "Details", bundle: nil).instantiateInitialViewController() as! DetailsViewController
                let serviceProvider = ServiceProvider()
                viewController.reactor = DetailsViewReactor.init(provider: serviceProvider)
                viewController.loadData(model: model)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
        .disposed(by: self.disposeBag)
    }
}

// MARK: - 代理
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            return UILabel().then {
                $0.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 44)
                $0.backgroundColor = UIColor.blue
                $0.textColor = UIColor.black
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.textAlignment = .center
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMdd"
                let date = dateFormatter.date(from: dataSource![section].model)!
                dateFormatter.dateFormat = "MM月dd日"
                let dateStr = dateFormatter.string(from: date)
                let weekday = date.dayOfWeek()
                $0.text = dateStr + "  星期\(weekday)"
            }
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension Date {
    // 获取当前日期是周几
    func dayOfWeek() -> Int {
        let interval = self.timeIntervalSince1970;
        let days = Int(interval / 86400);
        return (days - 3) % 7;
    }
}


