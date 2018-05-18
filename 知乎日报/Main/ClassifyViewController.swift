//
//  ClassifyViewController.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/12/23.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
import MJRefresh
import ReactorKit
import SlideMenuControllerSwift

class ClassifyViewController: BaseViewController,StoryboardView{

    // MARK: - 属性
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource :RxTableViewSectionedReloadDataSource<SectionModel<String, StoryModel>>?
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        
        setupView()
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        configView()
    }
    
    deinit {
        removeNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 内部方法
    fileprivate func setupView() {
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
            self.reactor?.action.onNext(ClassifyViewReactor.Action.loadData)
        })
    }
    
    fileprivate func configView() {
        
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        let cellNib = UINib(nibName: "ListCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ListTableViewCell")
        setNavigationBarItem()
    }
    
    
    fileprivate func setNavigationBarItem() {
        
        self.addLeftBarButtonWithImage(UIImage(named: "Back_White")!)
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    fileprivate func removeNavigationBarItem() {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    // MARK: - 外部方法
    func loadData(mode: ThemeModel) {
        
        self.reactor?.currentThemeModel = mode
        reactor?.action.onNext(ClassifyViewReactor.Action.loadData)
    }

    // MARK: - 绑定
    func bind(reactor: ClassifyViewReactor) {
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
        
        // State
        reactor.state.asObservable()
            .map{$0.title}
            .bind(to: self.navigationItem.rx.title)
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{$0.sections}
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        reactor.state.asObservable()
            .map{$0.refreshStatus}
            .subscribe(onNext: {[unowned self] (refreshStatus) in
                
                switch refreshStatus {
                case .InvaliData:
                    self.tableView.mj_header.endRefreshing()
                    return
                case .DropDownSuccess:
                    self.tableView.mj_header.endRefreshing()
                    return
                }
            })
            .disposed(by: self.disposeBag)
        // View
        tableView.rx.modelSelected(StoryModel.self)
            .subscribe(onNext: { (storyModel) in
                KzLog("ClassifyViewController :\(storyModel)")
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - 代理
extension ClassifyViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            return UILabel().then {
                $0.frame = CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 38)
                $0.backgroundColor = UIColor.red
                $0.textColor = UIColor.white
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
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
}

