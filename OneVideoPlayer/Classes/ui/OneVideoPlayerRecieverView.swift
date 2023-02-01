//
//  OneVideoPlayerRecieverView.swift
//  Pods
//
//  Created by Jie on 2023/1/16.
//


import UIKit

public class OneVideoPlayerRecieverView: UIView {
    
    public override var canBecomeFocused: Bool {
        return true
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        _updateUI()
    }
    
    public func _updateUI() {
        if let container = superview {
            translatesAutoresizingMaskIntoConstraints = false
            topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
    }
}
