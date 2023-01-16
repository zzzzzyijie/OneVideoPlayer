//
//  OnePlayerRenderingView.swift
//  OneVideoPlayer
//
//  Created by Jie on 2023/1/9.
//

import UIKit
import AVFoundation

class OnePlayerRenderingView: UIView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    lazy var playerLayer: AVPlayerLayer = {
        return layer as! AVPlayerLayer
    }()
    
    weak var playerView: OnePlayerView!
    
    required init(with playerView: OnePlayerView) {
        self.playerView = playerView
        super.init(frame: .zero)
        self.playerLayer.player = playerView.player
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        if let parent = superview {
            topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: parent.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: parent.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        }
    }
}
