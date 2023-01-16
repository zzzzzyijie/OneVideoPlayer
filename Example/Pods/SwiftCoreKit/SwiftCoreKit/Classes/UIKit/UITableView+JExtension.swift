//
//  UITableView+Extension.swift
//  CoolMoive
//
//  Created by Jie on 2020/3/18.
//  Copyright © 2020 Jie. All rights reserved.
//

import UIKit
// 依赖  UIView+Quick

public extension UITableView {
    
    func registerCell(type: UITableViewCell.Type) {
        register(type, forCellReuseIdentifier: type.defaultTypeIdentifier)
    }
    
    func registerCellList(_ cellList: [UITableViewCell.Type]) {
        cellList.forEach { (type) in
            registerCell(type: type)
        }
    }
    
    func registerNib(type: UITableViewCell.Type) {
        register(UINib(nibName: type.defaultTypeIdentifier, bundle: nil), forCellReuseIdentifier: type.defaultTypeIdentifier)
    }
    
    // todo:  header footer
    func dequeueReusableCellForIndexPath<T: UITableViewCell>(type: T.Type,indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.defaultTypeIdentifier, for: indexPath) as? T else {
            fatalError( "Failed to dequeue a cell with identifier \(type.defaultTypeIdentifier). Ensure you have registered the cell." )
        }
        return cell
    }
    
    func configCorner(cell: UITableViewCell,
                      radius: CGFloat,
                      padding: CGFloat,
                      fillColor: UIColor,
                      indexPath: IndexPath,
                      cententColor: UIColor? = .white
                      ) {
        let cornerRadius = CGSize(width: radius, height: radius)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        let pathLayer = CAShapeLayer()
        let bounds =  cell.bounds.insetBy(dx: padding, dy: 0)
        // rows
        let rowsNum = numberOfRows(inSection: indexPath.section)
        // path
        var path: UIBezierPath? = nil
        // currentRow
        let currentRow = indexPath.row
        if (currentRow == 0) && (currentRow == rowsNum - 1) {
            path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: cornerRadius)
        }else if currentRow == 0 {
            path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: cornerRadius)
        }else if currentRow == rowsNum - 1 {
            path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadius)
        }else {
            path = UIBezierPath(rect: bounds)
        }
        // layer
        pathLayer.path = path?.cgPath
        pathLayer.fillColor = fillColor.cgColor
        let tempView = UIView(frame: bounds)
        tempView.layer.insertSublayer(pathLayer, at: 0)
        tempView.backgroundColor = cententColor
        cell.backgroundView = tempView
    }
    
}

