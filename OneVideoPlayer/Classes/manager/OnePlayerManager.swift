//
//  OnePlayerManager.swift
//  OneVideoPlayer
//
//  Created by Jie on 2023/1/11.
//

import UIKit
import AVFoundation
import OnePlayer

// MARK: - VideoPlayerManagerPlayerStatus ----------------------------
/// 播放器状态
public enum OneVideoPlayerManagerPlayerStatus {
    case assetLoaded
    case didPlay
    case readyToPlay
    case didEnd
    case didPause
    case buffering
    case endBuffering
    case loadedTimeRanges
    case failed
    case none
}

public typealias OneVideoPlayStatusHanderClosure = (_ status: OneVideoPlayerManagerPlayerStatus) -> Void
public typealias OneVideoPlayTimeHanderClosure = (_ time: TimeInterval) -> Void


// MARK: - PlayerManagerExtension ----------------------------
/// 如果需要自定义，继承即可
open class OneVideoPlayerManagerExtension: NSObject {
    
    /// 这里需要使用weak , 不然内存泄漏
    public weak var playerView: OnePlayerView?
    /// 是否正在播放
    var isPlaying: Bool = false
    
    public init(with playerView: OnePlayerView) {
        self.playerView = playerView
    }
    
    /// 初始化设置
    open func _setup() {
        
    }
    
    /// 视频是否正在播放
    /// - Returns: yes or no
    public func isVideoPlaying() -> Bool {
        return isPlaying
    }
    
    /// 播放
    public func play() {
        playerView?.play()
    }
    
    /// 暂停
    public func pause() {
        playerView?.pause()
    }
    
    /// 播放 & 暂停
    public func togglePlayback() {
        if isPlaying {
            pause()
        }else {
            play()
        }
    }
    
    /// 设置倍速
    func setRate(_ rate: Float) {
        playerView?.setRate(rate)
    }
    
    /// 重播
    /// - Parameter isAutoPlay: 是否自动播放
    public func rePlay(isAutoPlay: Bool = true) {
        playerView?.rePlay(isAutoPlay: isAutoPlay)
    }
    
    /// 指定进度播放
    /// - Parameters:
    ///   - time: 播放位置
    ///   - isAutoPlay: 是否自动播放
    public func seek(to time: Double,
              isAutoPlay: Bool = true,
              completionHandler: @escaping (Bool) -> Void) {
        playerView?.seek(to: time, isAutoPlay: isAutoPlay, completionHandler: completionHandler)
    }
}

// MARK: - OnePlayerManager ----------------------------
public class OnePlayerManager: OneVideoPlayerManagerExtension {
    
    public var status: OneVideoPlayerManagerPlayerStatus = .none
    public weak var coordinator: OnePlayerBaseControlsCoordinator?
    public var statusChangedHander: OneVideoPlayStatusHanderClosure? // 状态改变回调
    public var timeChangedHander: OneVideoPlayTimeHanderClosure? // 时间改变回调
    
    required public init(with playerView: OnePlayerView,
                  and coordinator: OnePlayerBaseControlsCoordinator) {
        super.init(with: playerView)
        self.coordinator = coordinator
        playerView.player.playbackDelegate = self
        playerView.addSubview(coordinator)
        playerView.bringSubviewToFront(coordinator)
    }
    
    deinit {
        debugPrint("OnePlayerManager is deinit")
    }
    
    public override func _setup() {
        
    }
    
    func playerStatusDidChanged(status: OneVideoPlayerManagerPlayerStatus) {
        coordinator?.playerStatusDidChanged(status: status)
        statusChangedHander?(status)
    }
    
    func timeDidChange(time: CMTime) {
        let timeValue = TimeInterval(time.seconds)
        coordinator?.timeDidChange(time: timeValue)
        timeChangedHander?(timeValue)
    }
}

extension OnePlayerManager: OnePlayerPlaybackDelegate {
    
    public func playbackAssetLoaded(player: OnePlayer) {
        status = .assetLoaded
        playerStatusDidChanged(status: status)
    }
    
    public func playbackPlayerReadyToPlay(player: OnePlayer) {
        status = .readyToPlay
        playerStatusDidChanged(status: status)
    }
    
    public func playbackItemReadyToPlay(player: OnePlayer, item: OnePlayerItem) {
        status = .readyToPlay
        playerStatusDidChanged(status: status)
    }
    
    public func playbackTimeDidChange(player: OnePlayer, to time: CMTime) {
        timeDidChange(time: time)
    }
    
    public func playbackDidBegin(player: OnePlayer) {
        status = .didPlay
        isPlaying = true
        playerStatusDidChanged(status: status)
    }
    
    public func playbackDidPause(player: OnePlayer) {
        status = .didPause
        isPlaying = false
        playerStatusDidChanged(status: status)
    }
    
    public func playbackDidEnd(player: OnePlayer) {
        status = .didEnd
        isPlaying = false
        playerStatusDidChanged(status: status)
    }
    
    public func playbackStartBuffering(player: OnePlayer) {
        status = .buffering
        playerStatusDidChanged(status: status)
    }
    
    public func playbackLoadedTimeRanges(player: OnePlayer, progress: CGFloat) {
        status = .loadedTimeRanges
        playerStatusDidChanged(status: status)
    }
    
    public func playbackEndBuffering(player: OnePlayer) {
        status = .endBuffering
        playerStatusDidChanged(status: status)
    }
    
    public func playbackDidFailed(with error: Error) {
        status = .failed
        isPlaying = false
        playerStatusDidChanged(status: status)
    }
}

// MARK: - OnePlayerView Extension ----------------------------
public extension OnePlayerView {
    
    var onePlayerManager: OnePlayerManager? {
        let manager = getExtension(with: "OnePlayerManager") as? OnePlayerManager
        return manager 
    }

    func useOnePlayerManager(manager: OnePlayerManager?) {
        if let manager = manager {
            addExtension(extension: manager, with: "OnePlayerManager")
        }
    }
}
