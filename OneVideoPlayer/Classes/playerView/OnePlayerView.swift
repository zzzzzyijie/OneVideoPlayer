//
//  OnePlayerView.swift
//  OneVideoPlayer
//
//  Created by Jie on 2023/1/9.
//

import UIKit
import AVFoundation
import OnePlayer

public class OnePlayerView: UIView {
    
    // MARK: - UI ----------------------------
    /// 播放器
    public var player: OnePlayer!
    /// 渲染的playerView
    public var renderingView: OnePlayerRenderingView!
    // MARK: - Data ----------------------------
    // -----------------Public-----------------------
    /// 是否自动播放, 默认true
    public var isAutoPlay: Bool = true
    // -----------------Private-----------------------
    /// 存储extension
    private var extensions: [String: OneVideoPlayerManagerExtension] = [:]
    
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Init Method ----------------------------
    func setup() {
        player = OnePlayer()
        player.setupPlayer()
        renderingView = OnePlayerRenderingView(with: self)
        addSubview(renderingView)
    }
    
    // MARK: - Public Method ----------------------------
    /// 设置播放的item
    /// - Parameter item: player item
    public func set(item: OnePlayerItem?) {
        player.replaceCurrentItem(with: item)
        if isAutoPlay && item?.error == nil {
            play()
        }
    }
    
    /// 播放
    public func play() {
        player.play()
    }
    
    /// 暂停
    public func pause() {
        player.pause()
    }
    
    /// 重播
    /// - Parameter isAutoPlay: 是否自动播放
    public func rePlay(isAutoPlay: Bool = true) {
        seek(to: 0.0, isAutoPlay: isAutoPlay) { _ in }
    }
    
    /// 指定进度播放
    /// - Parameters:
    ///   - time: 播放位置
    ///   - isAutoPlay: 是否自动播放
    public func seek(to time: Double,
              isAutoPlay: Bool = true,
              completionHandler: @escaping (Bool) -> Void) {
        let toTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // 精确播放
        player.seek(to: toTime, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] finished in
            if finished {
                if isAutoPlay {
                    self?.play()
                }
            }
            completionHandler(finished)
        })
    }
    
    /// 添加player extension
    /// - Parameters:
    ///   - ext: OnePlayerManagerExtension
    ///   - name: name
    public func addExtension(extension ext: OneVideoPlayerManagerExtension, with name: String) {
        ext.playerView = self
        ext._setup()
        extensions[name] = ext
    }
    
    /// 获取player extension
    /// - Parameter name: name
    /// - Returns: extenison
    open func getExtension(with name: String) -> OneVideoPlayerManagerExtension? {
        return extensions[name]
    }
}
