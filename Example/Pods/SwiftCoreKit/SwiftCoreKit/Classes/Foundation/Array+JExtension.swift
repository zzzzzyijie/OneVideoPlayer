//
//  Array+Random.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/22.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation

public extension Array {
    
    // 随机获取某个元素
    func randomPick(randomPick n: Int) -> [Element] {
         var copy = self
         for i in stride(from: count - 1, to: count - n - 1, by: -1) {
             copy.swapAt(i, Int(arc4random_uniform(UInt32(i + 1))))
         }
         return Array(copy.suffix(n))
     }
    
    // 插入第一个
    mutating func insertFirst(_ newElement: Element) {
        insert(newElement, at: 0)
    }
    
    // 修改List元素
    mutating func modifyForEach(_ body: (_ index: Index, _ element: inout Element) -> ()) {
        for index in indices {
            modifyElement(atIndex: index) { body(index, &$0) }
        }
    }

    // 修改某个Index元素
    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> ()) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
    
    // 安全取值
    subscript (safe index: Int) -> Element? {
        return (0..<count).contains(index) ? self[index] : nil
    }
    
    // enumerated - 遍历
    func forEachEnumerated(_ body: @escaping (_ offset: Int, _ element: Element) -> Void) {
        enumerated().forEach(body)
    }
    
}


extension Array {
    var toString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
