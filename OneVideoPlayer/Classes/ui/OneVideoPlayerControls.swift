//
//  OneVideoPlayerControls.swift
//  Pods
//
//  Created by Jie on 2023/1/16.
//

import UIKit
import SnapKit

class OneVideoPlayerControls: UIView {
    
    // MARK: - Lazy UI ----------------------------
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 顶部栏
    lazy var topBarBackgroundView: UIView = {
        let view = UIView()
        view.layer.contents = Icon.top_shadow.image?.cgImage
        return view
    }()
    
    lazy var topBarView: UniversalControlsTopBarView = {
        let view = UniversalControlsTopBarView()
        return view
    }()
    
    /// 底部栏
    lazy var bottomBarBackgroundView: UIView = {
        let view = UIView()
        view.layer.contents = Icon.bottom_shadow.image?.cgImage
        return view
    }()
    
    lazy var bottomBarView: UniversalControlsBottomBarView = {
        let view = UniversalControlsBottomBarView()
        return view
    }()
    
    // MARK: - Data ----------------------------
    /// 顶部高度
    var topBarHeight: CGFloat {
        if isSafeAreaMode() {
            return 110.0
        }else {
            return 80.0
        }
    }
    
    /// 底部高度
    var bottomBarHeight: CGFloat {
        if isSafeAreaMode() {
            return 88.0
        }else {
            return 65.0
        }
    }
    
    /// isSafeAreaMode
    private func isSafeAreaMode() -> Bool {
        return topWindow()?.safeAreaInsets.top ?? 0.0 > 0
    }
    
    /// top Window
    private func topWindow() -> UIView? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .last?.windows
                .filter({ $0.isKeyWindow })
                .last
        }else {
            return UIApplication.shared.keyWindow
        }
    }
    
    // MARK: - Life Cycle ----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    deinit {
        debugPrint("PortraitPlayerControls is deinit")
    }
    
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let container = superview {
            translatesAutoresizingMaskIntoConstraints = false
            topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
            bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        }
    }
    
    // MARK: - Private Method ----------------------------
    func setupUI() {
        // add ui
        addSubview(contentView)
        [topBarBackgroundView,topBarView,bottomBarBackgroundView,bottomBarView].forEach {
            contentView.addSubview($0)
        }
        
        // layout
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topBarBackgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(topBarHeight)
        }

        topBarView.snp.makeConstraints {
            $0.height.equalTo(65)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
        }

        bottomBarBackgroundView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview().offset(0)
            $0.height.equalTo(bottomBarHeight)
        }

        bottomBarView.snp.makeConstraints {
            $0.height.equalTo(65)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
        }
    }
    
    /// 控制锁按钮
    /// - Parameters:
    ///   - isHidden: 是否显示
    ///   - isAnimate: 是否动画
    func makeTopBottomBarVisible(alpha: CGFloat) {
        self.topBarView.alpha = alpha
        self.bottomBarView.alpha = alpha
        self.topBarBackgroundView.alpha = alpha
        self.bottomBarBackgroundView.alpha = alpha
        self.layoutIfNeeded()
    }
}

// MARK: - 顶部栏 ----------------------------
class UniversalControlsTopBarView: UIView {
    
    // MARK: - Lazy UI ----------------------------
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// stackview
    private lazy var topBarStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [backButton,titleLabel])
        view.axis = .horizontal
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 12
        return view
    }()
    
    /// 返回
    lazy var backButton: ExpandClickButton = {
        let button = ExpandClickButton()
        button.expandInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        button.setImage(Icon.nav_back.image, for: .normal)
        return button
    }()
    
    /// 标题
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 18)
        label.textAlignment = .left
        label.textColor = .white
        return label
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
    
    // MARK: - Private Method ----------------------------
    func setupUI() {
        // add ui
        addSubview(contentView)
        contentView.addSubview(backButton)
        contentView.addSubview(titleLabel)
        
        // layout
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backButton.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            // To do fix 约束冲突
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

// MARK: - 底部栏 ----------------------------
class UniversalControlsBottomBarView: UIView {
    
    // MARK: - Lazy UI ----------------------------
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// stackView
    private lazy var bottomBarStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [playButton,beginTimeLabel,
                                                  sliderView,endTimeLabel])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 12
        return view
    }()
    
    /// 播放按钮
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(Icon.pause.image, for: .normal)
        button.setImage(Icon.play.image, for: .selected)
        return button
    }()
    
    /// 开始时间
    lazy var beginTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 15)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "00:00"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    /// 滑块
    lazy var sliderView: OneVideoPlayerSlider = {
        let view = OneVideoPlayerSlider()
        view.progressHeight = 4
        view.sliderRadius = 2
        view.progress = 0.0
        view.bufferProgress = 0.0
        view.isAllowAnimateWhenDrag = false
        view.thumbSize = CGSize(width: 20, height: 20)
        view.thumbImage = Icon.slider_dot.image
        view.trackTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        view.bufferTrackTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        view.progressTintColor = UIColor(red: 1, green: 187/255.0, blue: 0, alpha: 1.0)
        return view
    }()
    
    /// 结束时间
    lazy var endTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "PingFangSC-Semibold", size: 15)
        label.textColor = .white
        label.text = "00:00"
        label.adjustsFontSizeToFitWidth = true
        return label
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
    
    // MARK: - Private Method ----------------------------
    func setupUI() {
        // add ui
        addSubview(contentView)
        contentView.addSubview(bottomBarStackView)
        
        // layout
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomBarStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        playButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        sliderView.snp.makeConstraints {
            $0.height.equalTo(25)
        }
        
        [beginTimeLabel, endTimeLabel].forEach({
            $0.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 45, height: 20))
            }
        })
    }
}

class ExpandClickButton: UIButton {
    
    var expandInset: UIEdgeInsets = .zero
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = bounds
        // 负值是方法响应范围
        let x = -expandInset.left
        let y = -expandInset.top
        let width = bounds.width + expandInset.left + expandInset.right
        let height = bounds.height + expandInset.top + expandInset.bottom
        bounds = CGRect(x: x, y: y, width: width, height: height)
        return bounds.contains(point)
    }
}
