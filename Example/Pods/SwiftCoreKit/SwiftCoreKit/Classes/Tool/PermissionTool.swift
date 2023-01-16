//
//  PermissionTool.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2021/3/9.
//  Copyright © 2021 Jie. All rights reserved.
//

import UIKit
import Photos

public typealias PermissionHanderClosure = (_ status: AVAuthorizationStatus) -> Void
public typealias PermissionBoolHanderClosure = (_ value: Bool) -> Void
public class PermissionTool: NSObject {
    // 录音权限
    public static func audioAuthoried(_ hander: @escaping PermissionHanderClosure) {
        var status = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        debugPrint("status = \(status)")
        if (status == .authorized || status == .denied){
            hander(status)
            return
        }
        // 获取麦克风权限
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) -> Void in
            DispatchQueue.main.async {
                if(granted) { //受限制
                    status = AVAuthorizationStatus.authorized
                }else {
                    status = AVAuthorizationStatus.denied
                }
                hander(status)
            }
        })
    }
    
    // 拍照权限
    public static func takePhotoAuthoried(_ hander: @escaping PermissionHanderClosure) {
        var status = AVCaptureDevice.authorizationStatus(for: .video)
        debugPrint("status = \(status)")
        if (status == .authorized || status == .denied){
            hander(status)
            return
        }
        // 拍照权限
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
            DispatchQueue.main.async {
                if(granted) { //受限制
                    status = AVAuthorizationStatus.authorized
                }else {
                    status = AVAuthorizationStatus.denied
                }
                hander(status)
            }
        })
    }
    
    // 相册权限
    public static func libraryPhotoAuthoried(_ hander: @escaping PermissionBoolHanderClosure) {
        if #available(iOS 14.0, *) {
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            if status == .authorized || status == .limited {
                hander(true)
                return
            }else if status == .denied {
                hander(false)
                return
            }
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (authStatus) in
                DispatchQueue.main.async {
                    if authStatus == .authorized || authStatus == .limited {
                        hander(true)
                    }else {
                        hander(false)
                    }
                }
            }
        } else {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == .authorized {
                hander(true)
                return
            }else if status == .denied {
                hander(false)
                return
            }
            PHPhotoLibrary.requestAuthorization { (authStatus) in
                DispatchQueue.main.async {
                    if authStatus == .authorized {
                        hander(true)
                    }else {
                        hander(false)
                    }
                }
            }
        }
    }
    
    // 通知权限 请求
    public static func notifyRequest(_ hander: @escaping PermissionBoolHanderClosure) {
        // 这里看实际情况 申请不一样的类型；普通的以下三个就可以
        let options: UNAuthorizationOptions = [.alert,.badge,.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (isSuccess, _) in
            DispatchQueue.main.async {
                hander(isSuccess)
            }
        }
    }
    
    // 通知权限 查看 (
    public static func checkNotifyStatus(_ hander: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (setting) in
            DispatchQueue.main.async {
                hander(setting.authorizationStatus)
            }
        }
    }
}
