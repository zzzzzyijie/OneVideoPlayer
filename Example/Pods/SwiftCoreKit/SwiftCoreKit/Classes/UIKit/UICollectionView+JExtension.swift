//
//  UICollectionView+Extension.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/18.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit
// 依赖  UIView+Quick

public enum ReusableViewType: String {
    case header = "UICollectionElementKindSectionHeader" // 等价--> UICollectionView.elementKindSectionHeader
    case footer = "UICollectionElementKindSectionFooter" // 等价--> UICollectionView.elementKindSectionFooter
}

public extension UICollectionView {
    
    func registerCell(type: UICollectionViewCell.Type) {
        register(type, forCellWithReuseIdentifier: type.defaultTypeIdentifier)
    }
    
    func registerNib(type: UICollectionViewCell.Type) {
        register(UINib(nibName: type.defaultTypeIdentifier, bundle: nil), forCellWithReuseIdentifier: type.defaultTypeIdentifier)
    }
    
    func registerReusableView(type: UICollectionReusableView.Type, ofKind reusableType: ReusableViewType) {
        register(type, forSupplementaryViewOfKind: reusableType.rawValue, withReuseIdentifier: type.defaultTypeIdentifier)
    }
    
    func registerXibReusableView(type: UICollectionReusableView.Type, ofKind reusableType: ReusableViewType) {
        register(UINib(nibName: type.defaultTypeIdentifier, bundle: nil), forSupplementaryViewOfKind: reusableType.rawValue, withReuseIdentifier: type.defaultTypeIdentifier)
    }
    
    
    func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(type: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: type.defaultTypeIdentifier, for: indexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(type.defaultTypeIdentifier).  Ensure you have registered the cell" )
        }
        return cell
    }
    
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(type: T.Type,ofKind kind:ReusableViewType, indexPath: IndexPath) -> T {
        guard let reuseView = self.dequeueReusableSupplementaryView(ofKind: kind.rawValue, withReuseIdentifier: type.defaultTypeIdentifier, for: indexPath) as? T else {
            fatalError( "Failed to dequeue a reuseView with identifier \(type.defaultTypeIdentifier).  Ensure you have registered the reuseView" )
        }
        return reuseView
    }
    
    func scrollToTop(animated: Bool? = true) {
        setContentOffset(.zero, animated: animated.or(true))
    }
    
    // 刷新数据
    func safeReloadData() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.reloadData()
        CATransaction.commit()
    }
    
    // 重新布局
    func safeLayoutInvalidateLayout() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.collectionViewLayout.invalidateLayout()
        CATransaction.commit()
    }
    
}
