//
//  UIViewController+Navigation.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/6/18.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    /// 获取当前控制器
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    // 是否包含某个vc in nav's
    func isContain(type: UIViewController.Type, inNav: UINavigationController? = nil) -> Bool {
        var currentNav: UINavigationController? = self.navigationController
        if let nav = inNav {
            currentNav = nav
        }
        guard let thisNav = currentNav,thisNav.viewControllers.count > 0 else { return false }
        var boolValue = false
        for vc in thisNav.viewControllers {
            if vc.isKind(of: type) {
                boolValue = true
                break
            }
        }
        return boolValue
    }
    
    /// pop会某个页面
    /// - Parameters:
    ///   - type: target controller
    ///   - selector: target controller ' method
    ///   - object: param
    func backToViewController(type: UIViewController.Type,
                              selector: Selector,
                              object: Any? = nil) {
        let currentNav: UINavigationController? = self.navigationController
        guard let nav = currentNav,nav.viewControllers.count > 0 else { return }
        var controllers: [UIViewController] = []
        nav.viewControllers.forEach({ (childVc) in
            if childVc.isKind(of: type) {
                controllers.append(childVc)
            }
        })
        if let lastVc = controllers.last {
            if lastVc.responds(to: selector) {
                if object != nil {
                    lastVc.perform(selector, with: object)
                }else {
                    lastVc.perform(selector)
                }
            }
            navigationController?.popToViewController(lastVc, animated: true)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    /// 某controller是否为顶部controller
    /// - Parameter controllerType: target vc
    /// - Returns: bool
    func isTopViewController(_ controllerType: UIViewController.Type) -> Bool {
        let theViewControllerYouSee = UIViewController.currentViewController()
        return theViewControllerYouSee?.isKind(of: controllerType) ?? false
    }
}
