//
//  BaseViewController.swift
//  知乎日报
//
//  Created by 邹凯章 on 17/3/9.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    // MARK: - RX
    var disposeBag = DisposeBag()
    
    // MARK: - 生命周期
    
    // MARK: - 布局约束
    private(set) var didSetupConstraints = false
    
    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func setupConstraints() {
        
    }
}
