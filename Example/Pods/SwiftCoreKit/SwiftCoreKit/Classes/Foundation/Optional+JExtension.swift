//
//  Optional+JExtension.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/30.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit

public extension Optional {
    
    // 是否为空
    var isNone: Bool {
      return self == nil
    }
    
    // 是否不为空
    var isSome: Bool {
      return self != nil
    }
    
    /// 返回可选值或默认值
    /// - 参数: 如果可选值为空，将会默认值
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
}

public extension Optional where Wrapped: Collection {
    
    // 是否为nil或空
    func isNilOrEmpty() -> Bool {
        return self?.isEmpty ?? true
    }
    
    // 是否有元素
    func hasElements() -> Bool {
        return !isNilOrEmpty()
    }
}


public extension Optional where Wrapped == String {
    @discardableResult
    func isBlank() -> Bool {
        return self?.isBlank ?? true
    }
    
    var emptyCheck: String? {
        if !isBlank() {
            return self!
        }
        return nil
    }
}


public extension Optional where Wrapped == Int {
    var bool: Bool {
        if isNone {
            return false
        }
        return self!.boolValue
    }
}
