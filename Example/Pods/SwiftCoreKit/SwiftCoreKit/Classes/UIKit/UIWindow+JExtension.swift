//
//  UIWindow+JExtension.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2020/9/29.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit

public extension UIWindow {
    
    /// Window下最顶层的ViewControler
    /// - Returns: UIViewController
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        if let presented = top?.presentedViewController {
            top = presented
        }
        if let tab = top as? UITabBarController {
            top = tab.selectedViewController
        }
        if let nav = top as? UINavigationController {
            top = nav.topViewController
        }
        return top
    }
    
    /// 获取最后一个Window
    /// - Returns: UIWindow
    static func lastWindow() -> UIWindow? {
        return UIApplication.shared.windows.last
    }
    
    /// 获取最顶层（且全屏）的Window
    /// - Returns: UIWindow
    static func topWindow() -> UIWindow? {
        return UIApplication.shared.windows.last(where: { $0.bounds.size.equalTo(UIScreen.main.bounds.size) })
    }
}
