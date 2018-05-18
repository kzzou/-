//
//  KzBannerViewCell.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/8/30.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import SnapKit

class KzBannerViewCell: UICollectionViewCell {
    
    // MARK: -属性
    weak var imageView: UIImageView!
    weak var imageTitle: UILabel!
    
    // MARK: -重写方法
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
    
    // MARK: -内部方法
    private func setupView() {
        
        let imageView = UIImageView(frame: CGRect.zero)
        addSubview(imageView)
        self.imageView = imageView
        
        let imageTitle = UILabel(frame: CGRect.zero)
        addSubview(imageTitle)
        self.imageTitle = imageTitle
    }
    
    fileprivate func configView() {
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        
        imageTitle.textColor = UIColor.white
        imageTitle.font = UIFont.boldSystemFont(ofSize: 21)
        imageTitle.numberOfLines = 0
    }
    
    private func setConstraints() {
        
        self.imageView.snp.makeConstraints { (make) in
            make.size.equalTo(self)
        }
        
        self.imageTitle.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(100)
        }
    }
}
