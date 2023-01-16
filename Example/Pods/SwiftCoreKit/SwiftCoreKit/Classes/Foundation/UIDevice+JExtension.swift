//
//  UIDevice+JExtension.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2020/9/29.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation

public extension UIDevice {
    // 切换旋转方向
    static func rotate(to orientation: UIInterfaceOrientation) {
       UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
       UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
    }
    
    // 返回当前的屏幕方向
    static var currentOrientationMask: UIInterfaceOrientationMask {
        let currentMask = UIApplication.shared.statusBarOrientation
        switch currentMask {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        default:
            return.portrait
        }
    }
}
