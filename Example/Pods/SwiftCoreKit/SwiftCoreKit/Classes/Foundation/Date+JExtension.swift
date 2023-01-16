//
//  Date+JExtension.swift
//  JianxiaozhiAI
//
//  Created by Long on 2022/2/16.
//  Copyright © 2022 Jie. All rights reserved.
//

import Foundation
import SwifterSwift

// 依赖SwiftSwifter
public extension Date {

    var monthDays: Int {
        return Calendar(identifier: Calendar.current.identifier).range(of: .day, in: .month, for: self)!.count
    }
    
    /// 前一个月
    var frontMonthDate: Date {
        return adding(.month, value: -1)
    }
    
    /// 后一个月
    var nextMonthDate: Date {
        return adding(.month, value: 1)
    }
}
