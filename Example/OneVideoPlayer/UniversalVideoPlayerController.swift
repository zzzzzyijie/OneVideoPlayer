//
//  UniversalVideoPlayerController.swift
//  OneVideoPlayer_Example
//
//  Created by Jie on 2023/1/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import OneVideoPlayer

// MARK: - ViewController ----------------------------
class UniversalVideoPlayerController: OneVideoPlayerViewController {
    open override var shouldAutorotate: Bool {
        return true
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }else {
            return super.supportedInterfaceOrientations
        }
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }else {
            return super.preferredInterfaceOrientationForPresentation
        }
    }
}
