//
//  Number+Calculate.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/22.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit

public extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    // 转字符串
    var stringValue: String {
        return "\(self)"
    }
}


public extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

public extension Int {
    var boolValue: Bool {
        return self == 1
    }
}

public extension Formatter {
    static let stringFormatters: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = false
        return formatter
    }()
}

public extension Decimal {
    var formattedString: String {
        return Formatter.stringFormatters.string(for: self) ?? ""
    }
    
    var doubleValue:Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
}

public extension Bool {
    public var toInt: Int { return self ? 1 : 0 }
}



//extension Decimal {
//    var formattedString: String {
//        //创建一个NumberFormatter对象
////        let numberFormatter = NumberFormatter()
////        numberFormatter.numberStyle = .decimal
////        numberFormatter.minimumFractionDigits = 0 //设置小数点后最少0位（不足补0）
////        numberFormatter.maximumFractionDigits = 2 //设置小数点后最多3位
////        //格式化
////        return numberFormatter.
//        return NSDecimalNumber(decimal: self).stringValue
//    }
//}
