//
//  DateTool.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2021/6/22.
//  Copyright © 2021 Jie. All rights reserved.
//

import UIKit

public class DateTool: NSObject {
    // caches
    private var cachedDateFormatters: [String: DateFormatter] = [:]
    // instance
    public static let share: DateTool = {
        let manager = DateTool()
        return manager
    }()
    
    // get or create one DateFormatter
    public func dateFormatter(withFormat format: String) -> DateFormatter {
        if let formatter = cachedDateFormatters[format] {
            return formatter
        }
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = format
        cachedDateFormatters[format] = newFormatter
        return newFormatter
    }
    
    // MARK: - Base ----------------------------
    // 当前日期
    public static var currentDate: Date {
        return Date()
    }
    
    // 当前日期的时间戳
    public static var currentTimeInterval: TimeInterval {
        return Date().timeIntervalSince1970
    }
    
    // MARK: - NSDate, NSString , 时间戳的转换 ----------------------------
    /*--------- To Date ---------*/
    // 字符串时间 --> 转Date (如："2020/4/14 11:7:43" -> Date
    public static func dateFrom(stringDate: String, forrmat: String) -> Date? {
        let formatter = DateTool.share.dateFormatter(withFormat: forrmat)
        return formatter.date(from: stringDate)
    }
    
    // 时间戳 --> Date (如：1586833663 -> Date
    public static func dateForm(timeInterval: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: timeInterval)
    }
    
    /*--------- To String ---------*/
    // Date --> 转字符串时间 (如：Date对象 -> "2020/4/14 11:7:43"
    public static func stringForm(date: Date, forrmat: String) -> String {
        let formatter = DateTool.share.dateFormatter(withFormat: forrmat)
        return formatter.string(from: date)
    }
    
    // TimeInterval --> 转字符串时间 (如：1624344850 -> "2020/4/14 11:7:43"
    public static func stringForm(timeInterval: TimeInterval, forrmat: String) -> String {
        let formatter = DateTool.share.dateFormatter(withFormat: forrmat)
        let date = DateTool.dateForm(timeInterval: timeInterval)
        return formatter.string(from: date)
    }
    
    /*--------- To TimeInterval ---------*/
    // Date --> 转TimeInterval (如：Date对象 -> 1624344850
    public static func timeIntervalForm(date: Date) -> TimeInterval {
        return date.timeIntervalSince1970
    }
    
    // 字符串 --> 转TimeInterval (如："2020/4/14 11:7:43" -> 1624344850
    public static func timeIntervalForm(stringDate: String,forrmat: String? = "yyyy-MM-dd HH:mm:ss") -> TimeInterval {
        if let date = DateTool.dateFrom(stringDate: stringDate, forrmat: forrmat!) {
            return date.timeIntervalSince1970
        }
        return 0
    }
}
