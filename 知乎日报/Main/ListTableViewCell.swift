//
//  ListTableViewCell.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/7/6.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import Foundation
import ReactorKit
import Kingfisher

final class ListTableViewCell: BaseTableViewCell, StoryboardView{
    
    // MARK: - 属性
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    // MARK: - 生命周期
    
    // MARK: - 配置
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - 绑定
    func bind(reactor: ListTableViewCellReactor) {
        
        if let titleString = reactor.currentState.title {
            titleLabel.text = titleString
        }else {
            titleLabel.text = ""
        }
        
        if let imageString = reactor.currentState.images?.first {
            imgView.kf.indicatorType = .activity
            imgView.kf.setImage(with: URL.init(string: imageString))
        }
    }
    
    // MARK: - 代理
    
}
