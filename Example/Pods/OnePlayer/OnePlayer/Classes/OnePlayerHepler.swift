//
//  OnePlayerHepler.swift
//  OnePlayer
//
//  Created by Jie on 2023/1/9.
//

import UIKit
import Foundation
import AVFoundation

// MARK: - OnePlayerPlaybackDelegate ----------------------------
public protocol OnePlayerPlaybackDelegate: AnyObject {
    /// 资源已加载
    func playbackAssetLoaded(player: OnePlayer)
    
    /// 准备播放（可播放
    func playbackPlayerReadyToPlay(player: OnePlayer)
    
    /// 当前item准备播放（可播放
    func playbackItemReadyToPlay(player: OnePlayer, item: OnePlayerItem)
    
    /// 时间改变
    func playbackTimeDidChange(player: OnePlayer, to time: CMTime)
    
    /// 开始播放（点击 play
    func playbackDidBegin(player: OnePlayer)
    
    /// 暂停播放 （点击 pause
    func playbackDidPause(player: OnePlayer)
    
    /// 播放到结束
    func playbackDidEnd(player: OnePlayer)
    
    /// 开始缓冲
    func playbackStartBuffering(player: OnePlayer)
    
    /// 缓冲的进度
    func playbackLoadedTimeRanges(player: OnePlayer, progress: CGFloat)
    
    /// 缓存完毕
    func playbackEndBuffering(player: OnePlayer)
    
    /// 播放错误
    func playbackDidFailed(with error: Error)
}

extension OnePlayerPlaybackDelegate {
    public func playbackAssetLoaded(player: OnePlayer) { }
    public func playbackPlayerReadyToPlay(player: OnePlayer) { }
    public func playbackItemReadyToPlay(player: OnePlayer, item: OnePlayerItem) { }
    public func playbackTimeDidChange(player: OnePlayer, to time: CMTime) { }
    public func playbackDidBegin(player: OnePlayer) { }
    public func playbackDidPause(player: OnePlayer) { }
    public func playbackDidEnd(player: OnePlayer) { }
    public func playbackStartBuffering(player: OnePlayer) { }
    public func playbackLoadedTimeRanges(player: OnePlayer, progress: CGFloat) { }
    public func playbackEndBuffering(player: OnePlayer) { }
    public func playbackDidFailed(with error: Error) { }
}

// MARK: - Error ----------------------------
// 自定义的错误
enum OnePlayerError: Error {
    case unknown // 未知错误
}

extension OnePlayerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Player遇到未知错误"
        }
    }
}


// MARK: - OnePlayerObserverKey ----------------------------
enum OnePlayerObserverKey: String, CaseIterable {
    case status = "status"
    case playbackBufferEmpty = "playbackBufferEmpty"
    case loadedTimeRanges = "loadedTimeRanges"
    case playbackLikelyToKeepUp = "playbackLikelyToKeepUp"
    case playbackBufferFull = "playbackBufferFull"
}
