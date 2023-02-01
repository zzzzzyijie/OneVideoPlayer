//
//  OnePlayerBaseControlsCoordinator.swift
//  OneVideoPlayer
//
//  Created by Jie on 2023/1/11.
//

import UIKit
import AVFoundation

public class OnePlayerBaseControlsCoordinator: UIView {
    /// 播放器的View
    public weak var playerView: OnePlayerView!
    
    // MARK: - Life Cycle ----------------------------
    required init(playerView: OnePlayerView) {
        super.init(frame: .zero)
        self.playerView = playerView
        _setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        _setupUI()
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        _layoutUI()
    }
    
    /// 初始化UI
    func _setupUI() {
        
    }
    
    /// 布局UI ( 默认被添加到父控件时执行
    func _layoutUI() {
        if let container = superview {
            translatesAutoresizingMaskIntoConstraints = false
            topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
    }
    
    /// 播放状态的改变
    /// - Parameter status: 状态
    public func playerStatusDidChanged(status: OneVideoPlayerManagerPlayerStatus) {

    }
    
    /// 播放时间的改变
    /// - Parameter time: 时间
    public func timeDidChange(time: TimeInterval) {
        
    }
}