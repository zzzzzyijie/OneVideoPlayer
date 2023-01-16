//
//  Frame+JExtension.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/7/7.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit

public extension CGRect {
    var right: CGFloat {
        return size.width + origin.x
    }
    
    var x: CGFloat {
        return origin.x
    }
    
    var y: CGFloat {
        return origin.y
    }
    
    var bottom: CGFloat {
        return origin.y + size.height
    }
    
    var centerX: CGFloat {
        return CGFloat(width/2)
    }
    
    var centerY: CGFloat {
        return CGFloat(height/2)
    }
}
