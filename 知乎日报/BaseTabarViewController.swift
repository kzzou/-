//
//  BaseTabarViewController.swift
//  知乎日报
//
//  Created by 邹凯章 on 2017/12/22.
//  Copyright © 2017年 邹凯章. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

class BaseTabarViewController: UITabBarController {

    // MARK: - RX
    var disposeBag = DisposeBag()
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
