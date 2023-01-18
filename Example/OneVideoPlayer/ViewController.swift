//
//  ViewController.swift
//  OneVideoPlayer
//
//  Created by zengyijie on 01/16/2023.
//  Copyright (c) 2023 zengyijie. All rights reserved.
//

import UIKit
import OneVideoPlayer
import AVFoundation
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let sdVideoUrl =  "http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/picker_examle_video.mp4"
        let vc = OneVideoPlayerViewController(url: sdVideoUrl, title: "sdadlksjflsa")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

