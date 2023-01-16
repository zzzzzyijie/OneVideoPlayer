//
//  OneVideoPlayerLoadingView.swift
//  OneVideoPlayer
//
//  Created by Jie on 2023/1/16.
//

import UIKit
import SnapKit

class OneVideoPlayerLoadingView: UIView {
    
    // MARK: - Lazy UI ----------------------------
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// loading
    private lazy var loadingView: OneVideoPlayerLoadingContentView = {
        let activityView = OneVideoPlayerLoadingContentView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        activityView.isUserInteractionEnabled = false
        return activityView
    }()
    
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Init Method ----------------------------
    func setupUI() {
        // Add UI
        addSubview(contentView)
        contentView.addSubview(loadingView)
        
        // Layout
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 44, height: 44))
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Public Method ----------------------------
    public func startLoading() {
        loadingView.startAnimating()
    }
    
    public func stopLoading() {
        loadingView.stopAnimating()
    }
    
    // MARK: - Touch Event ----------------------------
    
}

class OneVideoPlayerLoadingContentView: UIView {
    
    var isAnimating = false
    var duration: CGFloat = 1
    var lineWidth: CGFloat = 1
    var lineColor = UIColor.white
    
    /// shapeLayer
    private lazy var shapeLayer: CAShapeLayer = {
        let view = CAShapeLayer()
        view.strokeColor = lineColor.cgColor
        view.fillColor = UIColor.clear.cgColor
        view.strokeStart = 0.1
        view.strokeEnd = 1
        view.lineCap = .round
        view.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        return view
    }()
    
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = CGFloat(min(bounds.width / 2, bounds.height / 2)) - shapeLayer.lineWidth / 2
        let startAngle: CGFloat = 0
        let endAngle = CGFloat(2 * CGFloat.pi)
        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        shapeLayer.path = path.cgPath
    }
    
    private func setupUI() { }
    
    /// startAnimating
    func startAnimating() {
        if isAnimating {
            return
        }
        isAnimating = true
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnim.toValue = NSNumber(value: 2.0 * CGFloat.pi)
        rotationAnim.duration = duration
        rotationAnim.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
        rotationAnim.isRemovedOnCompletion = false
        shapeLayer.add(rotationAnim, forKey: "rotation")
    }
    
    /// startAnimating
    func stopAnimating() {
        if !isAnimating {
            return
        }
        isAnimating = false
        shapeLayer.removeAllAnimations()
    }
    
    private func fadeOutShow() {
        let headAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = duration / 1.5
        headAnimation.fromValue = NSNumber(value: 0.0)
        headAnimation.toValue = NSNumber(value: 0.25)

        let tailAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = duration / 1.5
        tailAnimation.fromValue = NSNumber(value: 0.0)
        tailAnimation.toValue = NSNumber(value: 1.0)

        let endHeadAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = duration / 1.5
        endHeadAnimation.duration = duration / 3.0
        endHeadAnimation.fromValue = NSNumber(value: 0.25)
        endHeadAnimation.toValue = NSNumber(value: 1.0)

        let endTailAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = duration / 1.5
        endTailAnimation.duration = duration / 3.0
        endTailAnimation.fromValue = NSNumber(value: 1.0)
        endTailAnimation.toValue = NSNumber(value: 1.0)

        let animations = CAAnimationGroup()
        animations.duration = duration
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = .infinity
        animations.isRemovedOnCompletion = false
        shapeLayer.add(animations, forKey: "strokeAnim")
    }
}
