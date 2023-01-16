//
//  EyeManager.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2020/11/19.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit

private let EyeModeKey = "EyeModeKey"
public class EyeManager: NSObject {
    // window
    private lazy var coverWindow: EyeCoverWindow = {
        let view = EyeCoverWindow(frame: UIScreen.main.bounds)
        view.windowLevel = UIWindow.Level(rawValue: 2099)
        view.isUserInteractionEnabled = false
        //view.makeKey()
        return view
    }()
    
    // 获取单例
    public static let share: EyeManager = {
        let manager = EyeManager()
        return manager
    }()
    
    public static var isOn: Bool {
        return UserDefaults.standard.bool(forKey: EyeModeKey)
    }
    
    public static func checkIsShow() {
        if EyeManager.isOn {
            EyeManager.switchTo(true)
        }
    }
    
    public static func switchAction () {
        if EyeManager.isOn {
            EyeManager.switchTo(false)
        }else {
            EyeManager.switchTo(true)
        }
    }
    
    public static func switchTo(_ isOn: Bool) { // 切换主题
        UserDefaults.standard.setValue(isOn, forKey: EyeModeKey)
        UserDefaults.standard.synchronize()
        if isOn {
            //EyeManager.share.coverWindow.makeKey()
            EyeManager.share.coverWindow.isHidden = false
        }else {
            EyeManager.share.coverWindow.isHidden = true
            //let mainWindow = AppClient.share.mainWindow()
            //mainWindow?.makeKey()
        }
    }

}


public class EyeCoverWindow: UIWindow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        // remove all
        layer.sublayers?.forEach({ (layer) in
            layer.removeFromSuperlayer()
        })
        
        let coverLayer = CALayer()
        coverLayer.frame = UIScreen.main.bounds
        coverLayer.backgroundColor = UIColor(red: 128/255.0, green: 116/255.0, blue: 37/255.0, alpha: 0.3).cgColor
        layer.addSublayer(coverLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
