//
//  String+JExtension.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/6/17.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import CommonCrypto

// MARK: - 字符处理 ----------------------------
public extension String {
    
    // 去掉最后一个并返回
    var dropLast: String {
        return String(self.dropLast())
    }
    
    // Usage
    // let str = "Hello, world"
    // let strHello = String(str[...4])
    // let strWorld = String(str[7...])
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
    
    // Md5
    var md5: String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        
        guard let data = self.data(using: String.Encoding.utf8) else { return nil }
        
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash: [UInt8] = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        
        return (0..<length).map { String(format: "%02x", hash[$0]) }.joined()
    }
    
    // 本地化
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    // 前缀
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        return "\(prefix)\(self)"
    }
    
    // 字符串是否有空
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
    
    func ext2Range(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
    
    // 字符串解码
    func decode() -> String? {
        return self.removingPercentEncoding
    }
    
    // 字符串编码
    func encoded() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    //Base64编码
    func encodBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    //Base64解码
    func decodeBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    // 转dict
    func toDict() -> [String: Any]? {
        guard let jsonData = data(using: .utf8) else {
            return nil
        }
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return jsonObject as? [String: Any]
    }
}

// MARK: - 高度计算 ----------------------------
public extension String {
    
    func height(maxWidth width: CGFloat, font: UIFont, lineSpace: CGFloat = 0) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        var attri = [NSAttributedString.Key: Any]()
        attri[.font] = font
        if lineSpace > 0 {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpace
            attri[.paragraphStyle] = style
        }
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attri, context: nil)
        return ceil(boundingBox.height)
    }

    func width(maxHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}
