//
//  Data+JExtension.swift
//  JianxiaozhiAI
//
//  Created by 湛楚健 on 2020/11/3.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit

public extension Data {
    
    static func CacheGroup() -> String {
        return URL(fileURLWithPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]).appendingPathComponent("dataCache").path
    }
    
    static func CachePath(_ cacheKey: Any) -> String {
        let cacheGroup = URL(fileURLWithPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]).appendingPathComponent("dataCache").path
        return URL(fileURLWithPath: cacheGroup).appendingPathComponent(cacheKey as? String ?? "version_key").path
    }
    
    static func cache(withKey key: String?, validity: Int) -> Any? {
        if key?.isEmpty ?? false {
            return nil
        }
        
        let cacheGroup = URL(fileURLWithPath: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)[0]).appendingPathComponent("dataCache").path
        let path = URL(fileURLWithPath: cacheGroup).appendingPathComponent(key ?? "version_key").path

        var cacheDic: [String : Any] = [:]
        let unarchive = NSKeyedUnarchiver.unarchiveObject(withFile: path) as? [String:Any]
        cacheDic = unarchive ?? [:]
        

        if cacheDic.isEmpty {
            return nil
        }

        if validity != 0 {
            let cacheDate = cacheDic["cacheDate"] as? Date
            let nowDate = Date()
            var timeInterval: TimeInterval? = nil
            if let cacheDate = cacheDate {
                timeInterval = nowDate.timeIntervalSince(cacheDate)
            }
            let second = Int(round(timeInterval ?? 0))
            if second > validity {
                //现在的时间和缓存的时间差，如果大于缓存有效期，则返回nil
                return nil
            }
        }

        return cacheDic["json"]
    }
    
    static func saveCache(withKey key: String?, cache: Any?) {
        DispatchQueue.global(qos: .default).async(execute: {
            if key?.isEmpty ?? false {
                return
            }

            if cache.isNone {
                Data.removeCache(withKey: key)
                return
            }

            var cacheDic: [AnyHashable : Any] = [:]
            cacheDic["json"] = cache
            cacheDic["cacheDate"] = Date()

            if !Data.isHavefile(CacheGroup()) {
                _ = Data.createPath(CacheGroup())
            }

            let path = CachePath(key ?? "version_key")

            //加密保存数据
            NSKeyedArchiver.archiveRootObject(cacheDic, toFile: path)
        })
    }
    
    static func removeCache(withKey key: String?){
        Data.removeFile(CachePath(key ?? "version_key"))
    }
    
    static func isHavefile(_ filePath: String?) -> Bool {
        let fileManger = FileManager.default
        let isHavefile = fileManger.fileExists(atPath: filePath ?? "")

        let file_length = NSNumber(value: Data.fileSize(atPath: filePath))

        if Int(truncating: file_length) == 0 {
            Data.removeFile(filePath)
        }
        return isHavefile && Int(truncating: file_length) != 0
    }
    
    static func createPath(_ filePath: String?) -> Bool {
        //判断路径是否存在，不存在则新建
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePath ?? "") {
            return ((try? fileManager.createDirectory(atPath: filePath ?? "", withIntermediateDirectories: true, attributes: nil)) != nil)
        }
        return false
    }
    
    //单个文件的大小
   static func fileSize(atPath filePath: String?) -> Int64 {
        let manager = FileManager.default

        if manager.fileExists(atPath: filePath ?? "") {
            return Int64((try! manager.attributesOfItem(atPath: filePath ?? "")[FileAttributeKey.size] as? UInt64 ?? 0))
        }
        return 0

    }
    
    static func removeFile(_ filePath: String?) {
        let fm = FileManager()
        try? fm.removeItem(atPath: filePath ?? "")
    }
    
}
