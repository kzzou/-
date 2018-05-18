//
//  UINavigationBar+Ex.swift
//  知乎日报
//
//  Created by 邹凯章 on 2018/5/17.
//  Copyright © 2018年 邹凯章. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    fileprivate struct AssociatedKeys {
        static var backgroundView = UIView()
        static var backgroundStatusView = UIView()
        static var backgroundNavView = UIView()
        static var backgroundImageView = UIImageView()
    }
    
    fileprivate var backgroundView: UIView? {
        get {
            guard let bgView = objc_getAssociatedObject(self, &AssociatedKeys.backgroundView) as? UIView else {
                return nil
            }
            return bgView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var backgroundStatusView: UIView? {
        get {
            guard let bgsView = objc_getAssociatedObject(self, &AssociatedKeys.backgroundStatusView) as? UIView else {
                return nil
            }
            return bgsView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundStatusView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var backgroundNavView: UIView? {
        get {
            guard let banView = objc_getAssociatedObject(self, &AssociatedKeys.backgroundNavView) as? UIView else {
                return nil
            }
            return banView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundNavView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var backgroundImageView: UIImageView? {
        get {
            guard let bgimageView = objc_getAssociatedObject(self, &AssociatedKeys.backgroundImageView) as? UIImageView else {
                return nil
            }
            return bgimageView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.backgroundImageView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func kzSetBackgroundImage(image: UIImage) {
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        backgroundStatusView?.removeFromSuperview()
        backgroundStatusView = nil
        backgroundNavView?.removeFromSuperview()
        backgroundNavView = nil
        if backgroundImageView == nil {
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            shadowImage = UIImage()
            backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIDevice.current.screenWidth(), height: UIDevice.current.navBarBottom()))
            backgroundImageView?.autoresizingMask = .flexibleWidth
            self.subviews.first?.insertSubview(backgroundImageView ?? UIImageView(), at: 0)
        }
        backgroundImageView?.image = image
    }
    
    func kzSetBackgroundColor(color: UIColor) {
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = nil
        backgroundStatusView?.removeFromSuperview()
        backgroundStatusView = nil
        backgroundNavView?.removeFromSuperview()
        backgroundNavView = nil
        if backgroundView == nil {
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            shadowImage = UIImage()
            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.current.screenWidth(), height: UIDevice.current.navBarBottom()))
            backgroundView?.autoresizingMask = .flexibleWidth
            self.subviews.first?.insertSubview(backgroundView ?? UIView(), at: 0)
        }
        backgroundView?.backgroundColor = color
    }
    
    func kzSetBackgroundStatusColor(color: UIColor) {
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = nil
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        if backgroundStatusView == nil {
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            shadowImage = UIImage()
            backgroundStatusView = UIView(frame: CGRect(x: 0, y: 0, width: UIDevice.current.screenWidth(), height: UIDevice.current.statusBarHight()))
            backgroundStatusView?.autoresizingMask = .flexibleWidth
            self.subviews.first?.insertSubview(backgroundStatusView ?? UIView(), at: 0)
        }
        backgroundStatusView?.backgroundColor = color
    }
    
    func kzSetBackgroundNavColor(color: UIColor) {
        backgroundImageView?.removeFromSuperview()
        backgroundImageView = nil
        backgroundView?.removeFromSuperview()
        backgroundView = nil
        if backgroundNavView == nil {
            setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            shadowImage = UIImage()
            backgroundNavView = UIView(frame: CGRect(x: 0, y: UIDevice.current.statusBarHight(), width: UIDevice.current.screenWidth(), height: UIDevice.current.navBarHight()))
            backgroundNavView?.autoresizingMask = .flexibleWidth
            self.subviews.first?.insertSubview(backgroundNavView ?? UIView(), at: 1)
        }
        backgroundNavView?.backgroundColor = color
    }
    
    func kzSetBackgroundAlpha(alpha: CGFloat) {
        backgroundView?.alpha = alpha
    }
    
    func kzSetBackgroundStatusAlpha(alpha: CGFloat) {
        backgroundStatusView?.alpha = alpha
    }
    
    func kzSetBackgroundNavAlpha(alpha: CGFloat) {
        backgroundNavView?.alpha = alpha
    }
}
