//
//  UIView+Quick.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/18.
//  Copyright © 2020 Jie. All rights reserved.
//


import UIKit
// 依赖 extension Optional
public extension UIView {
    // self Id
    static var defaultTypeIdentifier: String {
        return String(describing: self)
    }
    
    // 加载xib的view
    class func fromNib() -> Self {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first as! Self
    }
    
    // 添加圆角
    func addCorner(radius: CGFloat,type: UIRectCorner, borderWidth: CGFloat? = 0, borderColor: UIColor? = nil) {
        if borderColor.isSome {
            layer.borderWidth = borderWidth ?? 0
            layer.borderColor = borderColor?.cgColor
        }
        layer.cornerRadius = radius
        let caMask = CACornerMask(rawValue: type.rawValue)
        layer.maskedCorners = caMask
    }
    
    /// 将当前的UIView转化为UIImage
    func asImage() -> UIImage? {
        guard frame.size.height > 0 && frame.size.width > 0 else { return nil }
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func currentViewController() -> UIViewController? {
        var nextResponder: UIResponder? = self
        repeat {
            nextResponder = nextResponder?.next
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
        } while nextResponder != nil
        return nil
    }
}

public extension UIView {
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        // 使用 fillToSuperview 更佳
        contentView.fillInView(self)
        return contentView
    }
    
    func fillInView(_ container: UIView!) -> Void {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    // safe area layout fill to superview ( eg: contoller's tableView or collectionView
    // not like to (fillToSuperview)
    func safeAreaToSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let leading = leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor)
            let trailing = trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([leading, trailing, top, bottom])
        }
    }
}
