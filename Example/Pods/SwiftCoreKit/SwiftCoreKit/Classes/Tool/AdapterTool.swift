//
//  DeviceTool.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/6/16.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit

public struct AdapterTool {
    
    public static var mainWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public static var mainHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    public static var tabbarHeight: CGFloat {
        if DeviceTool.share.isPhoneMode { // iPhone
            return 49.0
        }else { // iPad
            if DeviceTool.share.isSafeAreaMode {
                return 45.0
            }else {
                return 50.0
            }
        }
    }
    
    public static var navBarHeight: CGFloat {
        if DeviceTool.share.isPhoneMode { // iPhone
            return 44.0
        }else { // iPad
            return 50.0
        }
    }
    
    public static var safeBottomValue: CGFloat {
        if DeviceTool.share.isSafeAreaMode {
            if DeviceTool.share.isPhoneMode { // iPhone
                return 34.0
            }else { // iPad
                return 20.0
            }
        }else {
            return 0.0
        }
    }
    
    public static var safeStatusHeight: CGFloat {
        if DeviceTool.share.isSafeAreaMode {
            if DeviceTool.share.isPhoneMode { // iPhone
                return 44.0
            }else { // iPad
                return 24.0
            }
        }else {
            return 20.0
        }
    }
    
    public static var adaperSacle: CGFloat {
        return CGFloat(UIScreen.main.bounds.width/375.0)
    }
    
    // tabbar栏高度
    // iPhone: normal -> 49, safe -> 49 + 34;
    // iPad: normal -> 50,  safe -> 45 + 20;
    public static var tabbarSafeHeight: CGFloat {
        return AdapterTool.tabbarHeight + AdapterTool.safeBottomValue
    }
    
    // 导航栏高度
    // iPhone: normal -> 44 + 20, safe -> 44 + 44;
    // iPad: normal -> 50,  safe -> 50 + 24;
    public static var navBarSafeHeight: CGFloat {
        return AdapterTool.navBarHeight + AdapterTool.safeStatusHeight
    }
    
    // 底部适配返回的高度
    public static func adapterBottomHeight(_ value: CGFloat) -> CGFloat {
        return (value + AdapterTool.safeBottomValue)
    }
    
    // 适配
    public static func adapterByWidth(width: CGFloat , height: CGFloat , contentWidth: CGFloat) -> CGFloat {
        return contentWidth/(width/height)
    }
}
