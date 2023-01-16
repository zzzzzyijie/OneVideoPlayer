//
//  UILabel+JExtension.swift
//  JianxiaozhiAI
//
//  Created by Mills on 2020/9/29.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit

public extension UILabel {
    
    /**
     Label富文本改变部分文字大小颜色
     使用方法:
     UILabel.attributedtext(text:"09-09/周一",mainColor:UIColor(hex:"#1FCC78"),mainFont:UIFont.mediumFont(16),mainText:"09-09",subColor:UIColor(hex: "#1FCC78"),subfont:UIFont.mediumFont(11),subText:"/周一")
     */
    class func attributedtext(text:String,mainColor:UIColor,
                              mainFont:UIFont,
                              mainText:String,
                              subColor:UIColor,
                              subfont:UIFont,
                              subText:String) ->NSMutableAttributedString{
        let attrString:NSMutableAttributedString = NSMutableAttributedString(string:text)
        let str = NSString(string: text)
        let theRange = str.range(of: mainText)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: mainColor, range: theRange)
        attrString.addAttribute(NSAttributedString.Key.font, value:mainFont, range: theRange)
        let theSubRange = str.range(of: subText)
        attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: subColor, range: theSubRange)
        attrString.addAttribute(NSAttributedString.Key.font, value:subfont, range: theSubRange)
        return attrString
    }
    
    func countLines(with text: String? = nil) -> Int {
        var countText: String?
        if text != nil {
            countText = text
        }else {
            countText = self.text
        }
        guard let myText = countText as NSString? else { return 0 }
        
        // Call self.layoutIfNeeded() if your view uses auto layout
        let rect = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / font.lineHeight))
    }

    /// 是否被截断
    /// - Returns: true or false
    func isTruncated(with text: String? = nil) -> Bool {
        guard numberOfLines > 0 else { return false }
        return countLines(with: text) > numberOfLines
    }
    
    /// 计算当前显示的文字的茶长度
    var vissibleTextLength: Int {
        return calculateVissibleTextLength(with: text)
    }
    
    func calculateVissibleTextLength(with text: String?) -> Int {
        guard let text = text else {
            return 0
        }
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: text, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (text as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text.count - index - 1)).location
                }
            } while index != NSNotFound && index < text.count && (text as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return text.count
    }
}
