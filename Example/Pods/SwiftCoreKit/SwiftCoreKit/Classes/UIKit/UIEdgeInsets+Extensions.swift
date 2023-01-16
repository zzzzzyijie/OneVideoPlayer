//
//  UIEdgeInsets+Extensions.swift
//  JianxiaozhiAI
//
//  Created by Jie on 2021/7/6.
//  Copyright © 2021 Jie. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    
    init(all: CGFloat) {
        self.init(top: all, left: all, bottom: all, right: all)
    }

    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }
    
}
