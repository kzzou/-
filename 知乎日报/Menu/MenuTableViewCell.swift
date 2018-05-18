//
//  MenuTableViewCell.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/3/10.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class MenuTableViewCell: BaseTableViewCell, View{

    // MARK: - 属性
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    // MARK: - 配置
    
    // MARK: - 绑定
    func bind(reactor: MenuTableViewCellReactor) {
        self.titleLabel.text = reactor.currentState.name
    }
}
