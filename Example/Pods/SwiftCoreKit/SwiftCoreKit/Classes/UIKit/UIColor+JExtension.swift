//
//  UIColor+JExtension.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/23.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit
// 依赖 extension CGFloat
public extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
