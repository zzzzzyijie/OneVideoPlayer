//
//  UIView+Layer.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/19.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit

public extension UIView {
    
      // 圆角
      @IBInspectable
      var cornerReadius: CGFloat {
          get {
              return layer.cornerRadius
          }
          set {
              layer.cornerRadius = newValue
          }
      }

      // 阴影圆角
      @IBInspectable
      var shadowRadius: CGFloat {
          get {
              return layer.shadowRadius
          }
          set {
              layer.shadowRadius = newValue
          }
      }

      // 阴影透明度
      @IBInspectable
      var shawodOpacity: Float {
          get {
              return layer.shadowOpacity
          }
          set {
              layer.shadowOpacity = newValue
          }
      }
      // 阴影颜色
      @IBInspectable
      var shadowColor: UIColor? {
          get {
              return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil
          }
          set {
              layer.shadowColor = newValue?.cgColor
          }
      }
    
      // 阴影大小
      @IBInspectable
      var shadowOffset: CGSize {
          get {
              return layer.shadowOffset
          }
          set {
              layer.shadowOffset = newValue
          }
      }
    
    // MARK: - --------------
     @IBInspectable
     var masksToBounds: Bool {
          get {
             return layer.masksToBounds
            }
            set {
                layer.masksToBounds = newValue
            }
      }
    
     var borderColor: UIColor? {
            get {
                return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!): nil
            }
            set {
                layer.borderColor = newValue?.cgColor
            }
      }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // 添加指定的圆角
    func addRoundingCorners(frame: CGRect, corners: UIRectCorner, cornerReadius: CGFloat) {
        let path = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerReadius, height: cornerReadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = frame
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
