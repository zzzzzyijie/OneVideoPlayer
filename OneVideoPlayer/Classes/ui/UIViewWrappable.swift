//
//  UIViewWrappable.swift
//  Pods
//
//  Created by Jie on 2023/1/16.
//


protocol NamespaceWrappable {
    associatedtype WrapperType
    var one: WrapperType { get }
    static var one: WrapperType.Type { get }
}

extension NamespaceWrappable {
    var one: NamespaceWrapper<Self> {
        get { return NamespaceWrapper(value: self) }
        set { }
    }

    static var one: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var base: WrappedType { get }
    init(value: WrappedType)
}

struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let base: T
    public init(value: T) {
        self.base = value
    }
}

extension UIView: NamespaceWrappable { }
extension TypeWrapperProtocol where WrappedType: UIView {
    
    var x: CGFloat {
        set { base.frame = CGRect(x: _pixelIntegral(newValue),
                                          y: y,
                                          width: width,
                                          height: height)
            }
        get { return base.frame.origin.x }
    }

    var y: CGFloat {
        set { base.frame = CGRect(x: x,
                                          y: _pixelIntegral(newValue),
                                          width: width,
                                          height: height)
            }
        get { return base.frame.origin.y }
    }
    
    var centerX: CGFloat {
        set { base.center = CGPoint(x: newValue, y: centerY) }
        get { return base.center.x }
    }
    
    var centerY: CGFloat {
        set { base.center = CGPoint(x: centerX, y: newValue) }
        get { return base.center.y }
    }
    
    var width: CGFloat {
        set { base.frame = CGRect(x: x,
                                  y: y,
                                  width: _pixelIntegral(newValue),
                                  height: height)
            }
        get { return base.frame.size.width }
    }
    
    var height: CGFloat {
        set { base.frame = CGRect(x: x,
                                  y: y,
                                  width: width,
                                  height: _pixelIntegral(newValue))
            }
        get { return base.frame.size.height }
    }

    // MARK: - Private Methods
    fileprivate func _pixelIntegral(_ pointValue: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return (round(pointValue * scale) / scale)
    }
}
