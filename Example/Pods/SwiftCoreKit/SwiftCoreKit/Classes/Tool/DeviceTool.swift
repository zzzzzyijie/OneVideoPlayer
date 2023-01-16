//
//  DeviceTool.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2020/11/2.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit
import DeviceKit

public class DeviceTool: NSObject {

    fileprivate var isPhone = false
    fileprivate var isPad = false
    fileprivate var isiPhoneX = false
    fileprivate var isSafeArea = false
    fileprivate var appVersion = ""
    
    public static let share: DeviceTool = {
        let manager = DeviceTool()
        return manager
    }()
    
    override init() {
        
        let unSafeAreaPhones = Device.current.isOneOf([
            // iPhone
            .iPhone4,.iPhone4s,
            .iPhone5,.iPhone5s,.iPhone5c,.iPhoneSE,.iPhoneSE2,
            .iPhone6,.iPhone6s,.iPhone7,.iPhone8,
            .iPhone6Plus,.iPhone6sPlus,.iPhone7Plus,.iPhone8Plus,
            
            // simulator
            .simulator(.iPhone4),.simulator(.iPhone4s),
            .simulator(.iPhone5),.simulator(.iPhone5s),.simulator(.iPhone5c),.simulator(.iPhoneSE),.simulator(.iPhoneSE2),
            .simulator(.iPhone6),.simulator(.iPhone6s),
            .simulator(.iPhone7),.simulator(.iPhone8),
            .simulator(.iPhone6Plus),.simulator(.iPhone6sPlus),
            .simulator(.iPhone7Plus),.simulator(.iPhone8Plus)
            
        ])
        
        let unSafeAreaPads = Device.current.isOneOf([
            // iPad
            .iPad2,.iPad3,.iPad4,.iPad5,.iPad6,.iPad7,.iPad8,
            .iPadAir,.iPadAir2,.iPadAir3,
            .iPadMini,.iPadMini2,.iPadMini3,.iPadMini4,.iPadMini5,
            .iPadPro9Inch,.iPadPro10Inch,.iPadPro12Inch,.iPadPro12Inch2,
            
            // simulator
            .simulator(.iPad2),.simulator(.iPad3),.simulator(.iPad4),.simulator(.iPad5),
            .simulator(.iPad6),.simulator(.iPad7),.simulator(.iPad8),
            .simulator(.iPadAir),.simulator(.iPadAir2),.simulator(.iPadAir3),
            .simulator(.iPadMini),.simulator(.iPadMini2),.simulator(.iPadMini3),.simulator(.iPadMini4),.simulator(.iPadMini5),
            .simulator(.iPadPro9Inch),.simulator(.iPadPro10Inch),.simulator(.iPadPro12Inch),.simulator(.iPadPro12Inch2)
        ])
        
        // 设备类型
        isPhone = Device.current.isPhone
        isPad = Device.current.isPad
        
        // Ps: 比如刘海屏，iPhone、iPad等情况，其实是用safeInset布局是最合理的，尽量少用高度判断，这不是最佳实践
        //     只是碍于设计等因素，不得而为之；
        // 表现类型
        isiPhoneX = isPhone && !unSafeAreaPhones
        // 是否刘海 ( 暂以设备区别
        isSafeArea = !(unSafeAreaPhones || unSafeAreaPads)
        
        // 版本号
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            appVersion = version
        }
    }
    
    /// 4英寸屏幕 5/5c/5s/se
    public func is4Inches() -> Bool {
        return Device.current.isOneOf([
                                        .iPhone4s,.iPhone5,.iPhone5s,.iPhone5c,.iPhoneSE,
                                        .simulator(.iPhone4s),.simulator(.iPhone5),.simulator(.iPhone5s),
                                        .simulator(.iPhone5c),.simulator(.iPhoneSE),
                                    ])
    }
    
    /// 4.7英寸屏幕 6/6s/7/8/SE2
    public func is47Inches() -> Bool {
        let temp = Device.current.isOneOf([.iPhone6,.iPhone6s,.iPhone7,.iPhone8,.iPhoneSE2]) ? true : false
        return temp
    }
    
    /// 5.5英寸屏幕 6p/6sp/7p/8p
    public func is55Inches() -> Bool {
        let temp = Device.current.isOneOf([.iPhone6Plus,.iPhone6sPlus,.iPhone7Plus,.iPhone8Plus]) ? true : false
        return temp
    }
    
    /// 大屏Max英寸屏幕 max
    public func isProMax() -> Bool {
        return Device.current.isOneOf([.iPhone13ProMax,.iPhone12ProMax,
                                       .iPhone11ProMax,.iPhoneXSMax])
    }
    
    public var isiPhoneXMode: Bool {
        return isiPhoneX
    }
    
    public var isSafeAreaMode: Bool {
        return isSafeArea
    }
    
    public var currentVersion: String {
        return appVersion
    }
    
    public var isPhoneMode: Bool {
        return isPhone
    }
    
    public var isPadMode: Bool {
        return isPad
    }
    
    public var isLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
}
