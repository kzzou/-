//
//  BannerView.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/8/8.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxOptional
import ReactorKit
import SnapKit
import Kingfisher

class KzBannerView: UIView {
    
    
    // MARK: - 全局属性
    // 数据源
    open let imageDataSource: Variable<[StoryModel]?> = Variable(nil)
    
    // 自动滚动时间 为0这关闭
    open var automaticInterval: TimeInterval = 2.0 {
        didSet {
            
        }
    }
    
    // 当前索引
    open var currentIndex: Int = 0 {
        didSet {
            
        }
    }
    
    // MARK: - 内部属性
    internal weak var contentView: UIView!
    internal weak var collectionView: UICollectionView!
    internal weak var pageControl: UIPageControl!
    internal var collectionViewLayout: UICollectionViewFlowLayout!
    
    internal var disposeBag = DisposeBag()
    internal var timer: Timer?
    internal var numberOfItems: Int = 0
    internal var numberOfSections: Int = 0
    
    // MARK: - 重写方法
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        configView()
        setConstraints()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            startTimer()
        }else {
            cancelTimer()
        }
    }
    
    deinit {
        
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
    }
    
    // MARK: - 内部方法
    fileprivate func setupView() {
        
        // contentView
        let contentView = UIView(frame: CGRect.zero)
        self.addSubview(contentView)
        self.contentView = contentView
        
        // collectionView
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        self.collectionViewLayout = collectionViewLayout
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(KzBannerViewCell.self, forCellWithReuseIdentifier: "KzBannerViewCell")
        self.addSubview(collectionView)
        self.collectionView = collectionView
        
        // pageControl
        let pageControl = UIPageControl(frame: CGRect.zero)
        self.addSubview(pageControl)
        self.pageControl = pageControl
        
        // rx
        self.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        imageDataSource.asObservable()
            .filterNil()
            .map({ (storyModels) -> [StoryModel] in
                var transformStoryModels = [storyModels[storyModels.count - 1]]
                for storyModel in storyModels {
                    transformStoryModels.append(storyModel)
                }
                transformStoryModels.append(storyModels[0])
                return transformStoryModels
            })
            .bind(to: self.collectionView.rx.items(cellIdentifier: "KzBannerViewCell", cellType: KzBannerViewCell.self)) {
                row, model, cell in
                guard let imageModel = model.image, let titleModel = model.title else {
                    return
                }
                cell.imageView.kf.setImage(with: URL.init(string: imageModel))
                cell.imageTitle.text = titleModel
            }
            .disposed(by: disposeBag)
        
        imageDataSource.asObservable()
            .filterNil()
            .subscribe(onNext: { [unowned self] (storyModels) in
                self.numberOfItems = storyModels.count
                pageControl.numberOfPages = storyModels.count
                self.startTimer()
                collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            })
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func configView() {
        
        self.contentView.backgroundColor = UIColor.clear
        
        self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.collectionViewLayout.itemSize = self.frame.size
        self.collectionViewLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.collectionViewLayout.minimumLineSpacing = 0.0
        self.collectionViewLayout.minimumInteritemSpacing = 0.0
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.isPagingEnabled = true
    }
    
    fileprivate func setConstraints() {
        
        self.contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        self.collectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        self.pageControl.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 150, height: 30))
            make.right.equalTo(self.snp.right).offset(-10)
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            
        }
    }
}
// MARK: - timer
extension KzBannerView {
    
    fileprivate func startTimer() {
        
        if numberOfItems <= 1 {
            return
        }
        cancelTimer()
        timer = Timer.scheduledTimer(withTimeInterval: automaticInterval, repeats: true, block: { [unowned self] (timer) in
            if self.currentIndex < (self.imageDataSource.value?.count)! - 1 {
               self.currentIndex += 1
            } else {
                 self.currentIndex = 0
            }
            self.collectionView.scrollToItem(at: IndexPath.init(item: self.currentIndex + 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        })
    }
    
    fileprivate func cancelTimer() {
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

// MARK: - UICollectionViewDelegate
extension KzBannerView: UICollectionViewDelegate {
    // 开始拖拽调用
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if automaticInterval > 0 {
            cancelTimer()
        }
    }
    
    // 结束拖拽调用
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if automaticInterval > 0 {
            startTimer()
        }
    }
    
    // 滚动时调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    // 人为导致的滚动完毕调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollViewDidEndScrollingAnimation(scrollView)
    }
    
    // 系统导致滚动完毕调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x >= CGFloat((imageDataSource.value?.count)! + 1)*UIScreen.main.bounds.width {
            collectionView.scrollToItem(at: IndexPath.init(item: 1, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            currentIndex = 0
        }else if scrollView.contentOffset.x <= 0 {
            collectionView.scrollToItem(at: IndexPath.init(item: (imageDataSource.value?.count)!, section: 0), at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
            currentIndex = (imageDataSource.value?.count)! - 1
        }else {
            currentIndex = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width) - 1
        }
        self.pageControl.currentPage = currentIndex
    }
}

