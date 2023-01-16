//
//  UIImage+JExtension.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/6/16.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation
import UIKit

//      A         B
//       _________
//      |         |
//      |         |
//       ---------
//      C         D
enum GradientTyep {
    case LeftToRight            // AC - BD
    case TopToBottom            // AB - CD
    case BottomLeftToTopRight   // C - B
    case TopLeftToBottomRight   // A - D
    case Point(startPoint: CGPoint,endPoint: CGPoint)
    
    var startPoint: CGPoint {
        switch self {
        case .LeftToRight:
            return CGPoint(x: 0, y: 0)
        case .TopToBottom:
            return CGPoint(x: 0, y: 0)
        case .BottomLeftToTopRight:
            return CGPoint(x: 0, y: 1)
        case .TopLeftToBottomRight:
            return CGPoint(x: 0, y: 0)
        case .Point(let start, _):
            return start
        }
    }
    
    var endPoint: CGPoint {
        switch self {
        case .LeftToRight:
            return CGPoint(x: 1, y: 0)
        case .TopToBottom:
            return CGPoint(x: 0, y: 1)
        case .BottomLeftToTopRight:
            return CGPoint(x: 1, y: 0)
        case .TopLeftToBottomRight:
            return CGPoint(x: 1, y: 1)
        case .Point(_, let end):
            return end
        }
    }
}

public extension UIImage {
    
    // ---- 改变图片颜色 -----
    func tintWith(color: UIColor) -> UIImage {
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
    
    // https://www.19951128.xyz/2019/09/09/Swift-%E5%9B%BE%E7%89%87%E5%8E%BB%E8%89%B2-%E5%9B%BE%E7%89%87%E7%81%B0%E8%89%B2%E6%98%BE%E7%A4%BA/
    // ---- 图片去色 ----- ( 不准确 to fix
    private func grayImage() -> UIImage? {
           UIGraphicsBeginImageContext(self.size)
           let colorSpace = CGColorSpaceCreateDeviceGray()
           let context = CGContext(data: nil , width: Int(self.size.width), height: Int(self.size.height),bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
           context?.draw(self.cgImage!, in: CGRect.init(x: 0, y: 0, width: self.size.width, height: self.size.height))
           let cgImage = context!.makeImage()
           let grayImage = UIImage(cgImage: cgImage!, scale: self.scale, orientation: self.imageOrientation)
           return grayImage
    }
    
    // ---- 扣除黑色背景 ----- ( 不准确 to fix
    private func transparentColor(colorMasking:[CGFloat]) -> UIImage? {
        if let rawImageRef = self.cgImage {
            UIGraphicsBeginImageContext(self.size)
            if let maskedImageRef = rawImageRef.copy(maskingColorComponents: colorMasking) {
                let context: CGContext = UIGraphicsGetCurrentContext()!
                context.translateBy(x: 0.0, y: self.size.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.draw(maskedImageRef, in: CGRect(x:0, y:0, width:self.size.width, height:self.size.height))
                let result = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return result
            }
        }
        return nil
    }
    
    func transparentToGray() -> UIImage? {
         return transparentColor(colorMasking: [0, 32, 0, 32, 0, 32])
    }
    
    // ---- 颜色生成图片 -----
    static func fromColor(_ color: UIColor, size: CGSize? = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size!.width, height: size!.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 根据制定的宽高裁剪图片，目前用于拍照后图片裁剪
    /// - Parameters:
    ///   - myImage: 图片
    ///   - width: 宽度
    ///   - height: 高度
    /// - Returns: 裁剪后的图片
    class func imageByCropping(with myImage: UIImage? , width: CGFloat ,height: CGFloat) -> UIImage? {
        let Width = (myImage?.size.width ?? 0.0) * (myImage?.scale ?? 0.0)
        let Height = (myImage?.size.height ?? 0.0) * (myImage?.scale ?? 0.0)
        //图像的实际的尺寸(像素)等于image.size乘以image.scale
        let imageHeight : CGFloat = Width * height / width
        let rect = CGRect(x: 0, y: (Height - imageHeight) / 2.0, width: Width, height: imageHeight)

        let imageRef = myImage?.cgImage
        let imagePartRef = imageRef?.cropping(to: rect)
        var cropImage : UIImage = UIImage()
        if let imagePartRef = imagePartRef {
            cropImage = UIImage(cgImage: imagePartRef)
        }
        return cropImage
    }
    
    // ----------------------------- 【图片置灰】 ----------------------------------
    func makeItGray() -> UIImage? {
        // CGBitmapContextCreate 是无倍数的，所以要自己换算成1倍
        let size = sizeInPixel()
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let info: CGBitmapInfo = .byteOrder16Little
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: info.rawValue) else {
            return nil
        }
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.draw(cgImage!, in: imageRect)
        var grayImage: UIImage?
        guard let imageRef = context.makeImage() else {return nil}
        if qmui_opaque() {
            grayImage = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
        }else {
            let alphaInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue)
            guard let alphaContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: alphaInfo.rawValue) else {
                return nil
            }
            alphaContext.draw(cgImage!, in: imageRect)
            let mask = alphaContext.makeImage()
            guard let maskedGrayImageRef = imageRef.masking(mask!) else {return nil}
            grayImage = UIImage(cgImage: maskedGrayImageRef, scale: scale, orientation: imageOrientation)
        }
        return grayImage
    }
    
    private func sizeInPixel() -> CGSize {
        return CGSize(width: size.width * scale, height: size.height * scale)
    }
    
    private func qmui_opaque() -> Bool {
        guard let alphaInfo = cgImage?.alphaInfo else { return false }
        if alphaInfo == .noneSkipFirst || alphaInfo == .noneSkipLast || alphaInfo == .none {
            return true
        }
        return false
    }
    
    private func imageWith(size: CGSize, opaque: Bool, scale: CGFloat, actions: (CGContext) -> Void) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        actions(context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// --------------------------------------------------------------------------
// 图片压缩
public extension UIImage {
    
    // ---- 压缩图片（不超过最大值） -----
    /// - Parameters:
    ///   - maxLength: 图片大小 （ 2M -> 2048 * 1024 , 64kb -> 64 * 1024
    /// - Returns: 压缩后的data
    func compressTo(_ maxLength: Int) -> Data? {
        var compress: CGFloat = 0.6
        guard var data = jpegData(compressionQuality: compress) else {
             return nil
        }
        debugPrint("压缩前kb: \(Double((data.count)/1024))")
        if data.count < maxLength {
            return data
        }
        // 方案二 for 6 times
        for _ in 0..<8 {
            if data.count < maxLength {
                break
            }
            compress -= 0.05
            if let jpegData = jpegData(compressionQuality: compress) {
                data = jpegData
                debugPrint("压缩中kb: \( Double((data.count)/1024))")
            }
        }
        debugPrint("压缩后kb: \( Double((data.count)/1024))")
        return data
    }
    
    // ---- 压缩图片，精准压缩 -----
    /// - Parameters:
    ///   - maxLength: 图片大小 （ 2M -> 2048 * 1024 , 64kb -> 64 * 1024
    /// - Returns: 压缩后的data
    func accurateCompressTo(_ byteLength: Int) -> Data? {
        var compression: CGFloat = 1
        guard var data = jpegData(compressionQuality: compression) else {
             return nil
        }
        debugPrint("压缩前kb: \(Double((data.count)/1024))")
        if data.count < byteLength {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            debugPrint("compression - \(compression)")
            if let jpegData = jpegData(compressionQuality: compression) {
                data = jpegData
                debugPrint("压缩中kb: \( Double((data.count)/1024))")
                if CGFloat(data.count) < CGFloat(byteLength) * 0.9 {
                    min = compression
                } else if data.count > byteLength {
                    max = compression
                } else {
                    break
                }
            }
        }
        debugPrint("压缩后kb: \( Double((data.count)/1024))")
        return data
    }
}
