//
//  Throttler.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2022/3/4.
//  Copyright © 2022 Jie. All rights reserved.
//
//  参考： https://github.com/boraseoksoon/Throttler/blob/master/Sources/Throttler/Debouncer.swift
//        https://gist.github.com/simme/b78d10f0b29325743a18c905c5512788

import UIKit


public extension TimeInterval {

    /**
     Checks if `since` has passed since `self`.
     
     - Parameter since: The duration of time that needs to have passed for this function to return `true`.
     - Returns: `true` if `since` has passed since now.
     */
    func hasPassed(since: TimeInterval) -> Bool {
        return Date().timeIntervalSinceReferenceDate - self > since
    }

}

public class Throttler {
    
    private var currentWorkItem: DispatchWorkItem?
    private var lastFire: TimeInterval = 0
    
    /// 控制执行频率
    /// - Parameters:
    ///   - delay: 间隔多小秒
    ///   - action: 执行
    /// - Returns: 闭包
    func throttle(delay: TimeInterval, action: @escaping (() -> Void)) {
        if delay.hasPassed(since: lastFire) {
            action()
            self.lastFire = Date().timeIntervalSinceReferenceDate
        }
    }
}
