//
//  NumberConvertible.swift
//  JianZhiAppSwift
//
//  Created by Jie on 2020/7/4.
//  Copyright © 2020 Jie. All rights reserved.
//

import Foundation

import CoreGraphics

// 暂没用
// https://academy.realm.io/cn/posts/richard-fox-casting-swift-2/

//// ================================================================================= //
// MARK: - NumberConvertible Protocol -
public protocol Dividable {
    static func / (lhs: Self, rhs: Self) -> Self
}
public protocol NumberConvertible: Numeric, Dividable, Comparable {
    init(_ value: Int)
    init(_ value: Float)
    init(_ value: Double)
    init(_ value: CGFloat)
    init(_ value: UInt8)
    init(_ value: Int8)
    init(_ value: UInt16)
    init(_ value: Int16)
    init(_ value: UInt32)
    init(_ value: Int32)
    init(_ value: UInt64)
    init(_ value: Int64)
    init(_ value: UInt)
}

// ================================================================================= //
// MARK: - Protocol Conform -
extension Double  : NumberConvertible {}
extension Float   : NumberConvertible {}
extension Int     : NumberConvertible {}
extension UInt8   : NumberConvertible {}
extension Int8    : NumberConvertible {}
extension UInt16  : NumberConvertible {}
extension Int16   : NumberConvertible {}
extension UInt32  : NumberConvertible {}
extension Int32   : NumberConvertible {}
extension UInt64  : NumberConvertible {}
extension Int64   : NumberConvertible {}
extension UInt    : NumberConvertible {}
extension CGFloat : NumberConvertible {
    @inlinable public init(_ value: CGFloat){
        self = value
    }
}

extension NumberConvertible {
    @usableFromInline
    internal func convert<T: NumberConvertible>() -> T {
        switch self {
            case let x as CGFloat: return T(x)
            case let x as Float: return T(x)
            case let x as Int: return T(x)
            case let x as Double: return T(x)
            case let x as UInt8: return T(x)
            case let x as Int8: return T(x)
            case let x as UInt16: return T(x)
            case let x as Int16: return T(x)
            case let x as UInt32: return T(x)
            case let x as Int32: return T(x)
            case let x as UInt64: return T(x)
            case let x as Int64: return T(x)
            case let x as UInt: return T(x)
            default:
                assert(false, "NumberConvertible convert cast failed!")
                return T(0)
        }
    }
}

// ================================================================================= //
//// MARK: - Operators -
//@inlinable public func + <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(rhs: T, lhs: U) -> V {
//    lhs.convert() + rhs.convert()
//}
//@inlinable public func - <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(rhs: T, lhs: U) -> V {
//    lhs.convert() - rhs.convert()
//}
//@inlinable public func * <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(rhs: T, lhs: U) -> V {
//    lhs.convert() * rhs.convert()
//}
//@inlinable public func / <T: NumberConvertible, U: NumberConvertible, V: NumberConvertible>(rhs: T, lhs: U) -> V {
//    lhs.convert() / rhs.convert()
//}
//
////// ----------------- /////
//
//@inlinable public func += <T: NumberConvertible, U: NumberConvertible>(rhs: inout T, lhs: U)  {
//    rhs = rhs + lhs.convert()
//}
//@inlinable public func -= <T: NumberConvertible, U: NumberConvertible>(rhs: inout T, lhs: U)  {
//    rhs = rhs - lhs.convert()
//}
//@inlinable public func *= <T: NumberConvertible, U: NumberConvertible>(rhs: inout T, lhs: U)  {
//    rhs = rhs * lhs.convert()
//}
//@inlinable public func /= <T: NumberConvertible, U: NumberConvertible>(rhs: inout T, lhs: U)  {
//    rhs = rhs / lhs.convert()
//}
//
//@inlinable public func == <T:NumberConvertible, U:NumberConvertible>(lhs: T, rhs: U) -> Bool {
//    lhs == rhs.convert()
//}
//@inlinable public func != <T:NumberConvertible, U:NumberConvertible>(lhs: T, rhs: U) -> Bool {
//    lhs != rhs.convert()
//}
//@inlinable public func >= <T:NumberConvertible, U:NumberConvertible>(lhs: T, rhs: U) -> Bool {
//    lhs >= rhs.convert()
//}
//@inlinable public func > <T:NumberConvertible, U:NumberConvertible>(lhs: T, rhs: U) -> Bool {
//    lhs > rhs.convert()
//}
//@inlinable public func <= <T:NumberConvertible, U:NumberConvertible>(lhs: T, rhs: U) -> Bool {
//    lhs <= rhs.convert()
//}
//@inlinable public func < <T:NumberConvertible, U:NumberConvertible>(lhs: T, rhs: U) -> Bool {
//    lhs < rhs.convert()
//}

//@inlinable public func ?? <T: NumberConvertible, U: NumberConvertible, V:NumberConvertible>(lhs: T?, rhs: U) -> V {
//    lhs?.convert() ?? rhs.convert()
//}

//prefix operator ~~
//@inlinable public prefix func ~~<T: NumberConvertible, U: NumberConvertible>(lhs: T) -> U {
//    lhs.convert()
//}
