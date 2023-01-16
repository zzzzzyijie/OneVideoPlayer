//
//  DispatchQueue+Delay.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2021/5/19.
//  Copyright © 2021 Jie. All rights reserved.
//

import Foundation

typealias DelayTask = (_ cancel : Bool) -> Void
public extension DispatchQueue {
    @discardableResult
    internal class func delay(_ time: TimeInterval, task: @escaping ()->()) -> DelayTask? {
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (()->Void)? = task
        var result: DelayTask?
        let delayedClosure: DelayTask = { cancel in
            if let internalClosure = closure { if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result;
    }
    
    internal class func cancel(_ task: DelayTask?) {
        task?(true)
    }
}
