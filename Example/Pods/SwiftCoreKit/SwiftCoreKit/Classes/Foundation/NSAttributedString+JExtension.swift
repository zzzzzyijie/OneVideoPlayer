//
//  NSAttributedString+JExtension.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/6/30.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
    
    func height(maxWidth width: CGFloat) -> CGFloat {
        //style.lineBreakMode = .byTruncatingTail // 这是一个坑，计算高度的时候不能byTruncatingTail
        let maxSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
        return rect.height
    }
    

    func width(maxHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let rect = boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin], context: nil)
        return rect.width
    }
}

public extension NSMutableAttributedString {
    
    // Range
    var range: NSRange {
        return NSRange(location: 0, length: length)
    }
    
    @discardableResult
    func font(_ font: UIFont) -> Self {
        addAttributes([NSAttributedString.Key.font: font], range: range)
        return self
    }
    
    // paragraphStyle
    var paragraphStyle: NSMutableParagraphStyle? {
        return attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle
    }
    
    @discardableResult
    func color(_ color: UIColor) -> Self {
        addAttributes([NSAttributedString.Key.foregroundColor: color], range: range)
        return self
    }
    
    @discardableResult
    func wordSpaceing(_ wordSpaceing: CGFloat) -> Self {
        addAttributes([NSAttributedString.Key.kern: wordSpaceing], range: range)
        return self
    }
    
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.alignment = alignment
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.paragraphSpacing = paragraphSpacing
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func lineHeight(_ multiple: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.lineHeightMultiple = multiple
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.firstLineHeadIndent = indent
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func headIndent(_ indent: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.headIndent = indent
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func tailIndent(_ indent: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.tailIndent = indent
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func minimumLineHeight(_ height: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.minimumLineHeight = height
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func maximumLineHeight(_ height: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.maximumLineHeight = height
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func baseWritingDirection(_ direction: NSWritingDirection) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.baseWritingDirection = direction
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func paragraphSpacingBefore(_ spacing: CGFloat) -> Self {
        let style = paragraphStyle ?? NSMutableParagraphStyle()
        style.paragraphSpacingBefore = spacing
        addAttributes([NSAttributedString.Key.paragraphStyle: style], range: range)
        return self
    }
    
    @discardableResult
    func strikethroughStyle(_ style: NSUnderlineStyle) -> Self {
        addAttributes([NSAttributedString.Key.strikethroughStyle: style.rawValue], range: range)
        return self
    }
}
