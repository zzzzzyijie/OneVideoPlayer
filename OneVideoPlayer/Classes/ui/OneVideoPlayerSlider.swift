//
//  OneVideoPlayerSlider.swift
//  Pods
//
//  Created by Jie on 2023/1/16.
//

import UIKit

/// 滑块状态
public enum OneVideoPlayerSliderState {
    case began(progress: CGFloat)            // 滑动开始
    case changed(progress: CGFloat)          // 滑动改变
    case ended(progress: CGFloat)            // 滑动结束
    case onTap(progress: CGFloat)            // 点击滑杆某个位置
    case cancel                              // 取消
}

public class OneVideoPlayerSlider: UIView {
    
    // MARK: - API ----------------------------
    // 进度高度
    public var progressHeight: CGFloat = 8
    
    // 进度更新
    public var progress: CGFloat = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    // 缓存进度
    public var bufferProgress: CGFloat = 0.0 {
        didSet {
            updateUI()
        }
    }
    
    // 背景颜色
    public var contentBackgroundColor: UIColor = UIColor.clear {
        didSet {
            contentView.backgroundColor = contentBackgroundColor
        }
    }
    
    // 默认滑杆的颜色
    public var trackTintColor: UIColor = UIColor.white {
        didSet {
            trackProgressView.backgroundColor = trackTintColor
        }
    }
    
    // 播放进度颜色
    public var progressTintColor: UIColor = UIColor.white {
        didSet {
            sliderProgressView.backgroundColor = progressTintColor
        }
    }
    
    // 缓存进度颜色
    public var bufferTrackTintColor: UIColor = UIColor.white {
        didSet {
            bufferProgressView.backgroundColor = bufferTrackTintColor
        }
    }
    
    // 滑块图片
    public var thumbImage: UIImage? {
        didSet {
            sliderButton.setImage(thumbImage, for: .normal)
        }
    }
    
    // 滑块背景图片
    public var thumbBackgroundImage: UIImage? {
        didSet {
            sliderButton.setBackgroundImage(thumbBackgroundImage, for: .normal)
        }
    }
    
    // 滑块大小
    public var thumbSize: CGSize = CGSize(width: 20, height: 20)
    
    // 滑杆圆角
    public var sliderRadius: CGFloat = 5 {
        didSet {
            setupRadius()
        }
    }
    
    /// 视频总时长 （ 用于计算打点
    public var duration: TimeInterval = 0 {
        didSet {
            if duration > 0 {
                updateUI()
            }
        }
    }
    
    /// 打点列表
    var dotsTimeList: [Int] = [] {
        didSet {
            dotsViewList.forEach { $0.removeFromSuperview() }
            dotsViewList = dotsTimeList.map({ item in
                let imageView = UIImageView()
                imageView.isHidden = true
                if let img = dotsImage {
                    imageView.image = img
                }
                contentView.addSubview(imageView)
                return imageView
            })
            updateUI()
        }
    }
    
    // 是否允许Tap To progress
    public var isAllowTapToProgress: Bool = true
    // 是否允许动画 When Drag
    public var isAllowAnimateWhenDrag: Bool = true
    // 是否允许往后滑动
    public var isBackwardSlideAllowed: Bool = true
    // 滑块的偏移
    public var thumbOffset: CGFloat = 3
    // 滑块临时frame
    public var thumbViewFrame: CGRect = .zero
    // 打点的图片
    public var dotsImage: UIImage?
    // 打点列表
    private var dotsViewList: [UIView] = []
    
    // 回调
    public var handlerBlock: ((OneVideoPlayerSliderState) -> Void)?
    
    // MARK: - Lazy UI ----------------------------
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var trackProgressView: UIView = { /** 进度背景 */
        let view = UIView()
        return view
    }()
    
    private lazy var bufferProgressView: UIView = { /** 缓存进度 */
        let view = UIView()
        return view
    }()
    
    private lazy var sliderProgressView: UIView = { /** 滑动进度 */
        let view = UIView()
        return view
    }()
    
    lazy var sliderButton: ExpandClickButton = { /** 滑动按钮 */
        let view = ExpandClickButton()
        view.expandInset = .init(top: 15, left: 15, bottom: 15, right: 15)
        view.addTarget(self, action: #selector(sliderButtonAction), for: .touchDown)
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    // MARK: - Private Method ----------------------------
    func setupUI() {
        addSubview(contentView)
        contentView.addSubview(trackProgressView)
        contentView.addSubview(sliderProgressView)
        contentView.addSubview(bufferProgressView)
        contentView.addSubview(sliderButton)
        
        sliderButton.setImage(thumbImage, for: .normal)
        sliderButton.setBackgroundImage(thumbBackgroundImage, for: .normal)
            
        setupBackgroundColor()
        
        setupRadius()
        
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        contentView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        contentView.addGestureRecognizer(pan)
        
        updateUI()
    }
    
    func updateUI() {
        if progress.isNaN {
            progress = 0.0
            return
        }
        if bufferProgress.isNaN {
            bufferProgress = 0.0
            return
        }
        contentView.frame = bounds
        
        let contentW = contentView.bounds.width
        let contentH = contentView.bounds.height
        
        let x = CGFloat(0)
        let y = CGFloat(0)
        var w = contentW
        let h = progressHeight
        let cententY = CGFloat((contentH - h)*0.5)
        
        trackProgressView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        let sliderW: CGFloat = thumbSize.width
        //let sliderX = progress * (w - sliderW) + thumbOffset
        let sliderCenterX = thumbOffset + (w - 2*thumbOffset) * progress
        let sliderCenterY = CGFloat((contentH - thumbSize.height)*0.5)
        sliderButton.frame = CGRect(x: 0, y: y, width: sliderW, height: thumbSize.height)
        sliderButton.one.centerX = sliderCenterX
        
        w = sliderButton.one.centerX
        sliderProgressView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        w = trackProgressView.one.width * bufferProgress
        bufferProgressView.frame = CGRect(x: x, y: y, width: w, height: h)
        
        // make it cenent Y
        trackProgressView.one.y = cententY
        sliderProgressView.one.y = cententY
        bufferProgressView.one.y = cententY
        sliderButton.one.y = sliderCenterY
        
        // 打点布局
        if duration > 0 {
            for (index, dot) in dotsTimeList.enumerated() {
                if index < dotsTimeList.count {
                    let dotView = self.dotsViewList[index]
                    dotView.isHidden = false
                    let dotTime = TimeInterval(dot)
                    let dotProgress = dotTime/self.duration
                    let x = dotProgress * contentW
                    let dotFrame = dotView.frame
                    let newFrame = CGRect(x: (x-1), y: cententY, width: dotFrame.size.width, height: dotFrame.size.height)
                    dotView.frame = newFrame
                }
            }
        }
    }
    
    func setupBackgroundColor() {
        contentView.backgroundColor = contentBackgroundColor
        trackProgressView.backgroundColor = trackTintColor
        sliderProgressView.backgroundColor = progressTintColor
        bufferProgressView.backgroundColor = bufferTrackTintColor
    }
    
    func setupRadius() {
        trackProgressView.layer.cornerRadius = sliderRadius
        bufferProgressView.layer.cornerRadius = sliderRadius
        sliderProgressView.layer.cornerRadius = sliderRadius
        trackProgressView.layer.masksToBounds = true
        bufferProgressView.layer.masksToBounds = true
        sliderProgressView.layer.masksToBounds = true
    }
     
    // MARK: - Touch Event ----------------------------
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        if !isAllowTapToProgress { return }
        let point = tap.location(in: trackProgressView)
        let contentW = trackProgressView.one.width
        if contentW.isNaN {
            return
        }
        var progress = (point.x - sliderButton.one.width * 0.5) * 1.0 / contentW
        progress = progress > 1.0 ? 1.0 : progress <= 0 ? 0 : progress
        self.progress = progress
        handlerBlock?(.onTap(progress: progress))
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            debugPrint("begin taouch")
            if isAllowAnimateWhenDrag {
                UIView.animate(withDuration: 0.25) {
                    self.sliderButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }
            }
            if thumbViewFrame.equalTo(.zero) {
                thumbViewFrame = sliderButton.frame
            }
            handlerBlock?(.began(progress: progress))
            break
        case .changed:
            let specifiedPoint = pan.translation(in: trackProgressView)
            let minX = sliderButton.bounds.width * 0.5
            let maxX = trackProgressView.bounds.width - minX
            var rect = thumbViewFrame
            // rect.origin.x += specifiedPoint.x
            // if rect.midX < minX {
            //     rect.origin.x = 0
            // }
            // if rect.midX > maxX {
            //     rect.origin.x = maxX - minX
            // }
            // progress = (rect.midX - minX) / (maxX - minX)
            // debugPrint("value = \(progress)")
            // handlerBlock?(.changed(progress: progress))
            
            var newX = rect.origin.x + specifiedPoint.x
            
            if !isBackwardSlideAllowed {
                // 如果不允许往后滑，则限制新的 X 坐标不大于当前位置
                newX = min(rect.origin.x, newX)
            }
            
            // 确保 newX 在有效范围内
            newX = max(0, min(newX, maxX - minX))
            
            rect.origin.x = newX
            
            // 更新进度
            progress = (rect.midX - minX) / (maxX - minX)
            progress = max(0, min(1, progress)) // 确保进度在 0 到 1 之间
            
            // 更新滑块位置
            sliderButton.frame = rect
            
            debugPrint("value = \(progress)")
            handlerBlock?(.changed(progress: progress))
            break
        case .ended:
            thumbViewFrame = .zero
            if isAllowAnimateWhenDrag {
                UIView.animate(withDuration: 0.25) {
                    self.sliderButton.transform = .identity
                }
            }
            handlerBlock?(.ended(progress: progress))
            break
        case .cancelled,.failed:
            handlerBlock?(.cancel)
            break
        default:
            break
        }
    }
    
    @objc func sliderButtonAction() {
        if isAllowAnimateWhenDrag {
            UIView.animate(withDuration: 0.25) {
                self.sliderButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }
    }
    
}
