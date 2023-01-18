//
//  OnePlayerResource.swift
//  OneVideoPlayer
//
//  Created by Jie on 2023/1/18.
//

import UIKit


enum Icon: String {
    
    case top_shadow = "one_video_player_top_shadow"
    case bottom_shadow = "one_video_player_bottom_shadow"
    case nav_back = "one_video_nav_back"
    case pause = "one_video_pause"
    case play = "one_video_play"
    case slider_dot = "one_video_slider_dot"
    case lock = "one_video_lock"
    case unlock = "one_video_unlock"
    
    /// Returns the associated image.
    var image: UIImage? {
        return UIImage(named: rawValue, in: Bundle.frameworkBundle(), compatibleWith: nil)
    }
}


// MARK: - Bundle ----------------------------
// 参考SwiftMessage
private class BundleToken {}

extension Bundle {
    // This is copied method from SPM generated Bundle.module for CocoaPods support
    static func frameworkBundle() -> Bundle {

        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,

            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleToken.self).resourceURL,

            // For command-line tools.
            Bundle.main.bundleURL,
        ]

        let bundleNames = [
            // For Swift Package Manager
            "OneVideoPlayer_OneVideoPlayer",

            // For Carthage
            "OneVideoPlayer",
        ]

        for bundleName in bundleNames {
            for candidate in candidates {
                let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                    return bundle
                }
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: BundleToken.self)
    }
}
