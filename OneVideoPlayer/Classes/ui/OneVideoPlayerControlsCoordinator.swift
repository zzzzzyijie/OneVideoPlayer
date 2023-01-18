//
//  OneVideoPlayerControlsCoordinator.swift
//  Pods
//
//  Created by Jie on 2023/1/16.
//

import UIKit
import AVKit

/// UI 事件回调
public typealias OnePlayerHanderClosure = (_ action: OnePlayerControlsAction) -> Void
public enum OnePlayerControlsAction {
    case back   // 返回
    case playOrPause(Bool)   // 播放&暂停
    case slider(OneVideoPlayerSliderState) // 滑动状态
    case lock(Bool)  // 锁
}

class OneVideoPlayerControlsCoordinator: OnePlayerBaseControlsCoordinator {
    
    // MARK: - UI ----------------------------
    /// 背景
    private lazy var reciecerView: OneVideoPlayerRecieverView = {
        let view = OneVideoPlayerRecieverView()
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(reciecerTapHandler(with:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    /// 播放器元素
    lazy var controls: OneVideoPlayerControls = {
        let view = OneVideoPlayerControls()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(controlsTap(with:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        // 顶部
        view.topBarView.backButton.addTarget(self,
                                             action: #selector(backButtonAction),
                                             for: .touchUpInside)
        // 底部
        view.bottomBarView.playButton.addTarget(self,
                                                action: #selector(playButtonAction),
                                                for: .touchUpInside)
        // 进度
        view.bottomBarView.sliderView.handlerBlock = { [weak self] status in
            guard let self = self else { return }
            self.sliderStatusDidChange(status)
        }
        return view
    }()
    
    /// 加载中
    private lazy var loadingView: OneVideoPlayerLoadingView = {
        let view = OneVideoPlayerLoadingView()
        view.isUserInteractionEnabled = false
        return view
    }()
    
    /// 锁
    private lazy var lockButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 17/255.0, green: 0, blue: 0, alpha: 0.5)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.setImage(Icon.unlock.image, for: .normal)
        button.setImage(Icon.lock.image, for: .selected)
        button.addTarget(self,action: #selector(lockButtonAction),for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data ----------------------------
    // ------------------------------- public ---------------------------------
    /// 返回的事件
    var uiActionHandler: OnePlayerHanderClosure?
    /// 是否开始拖拽
    var isBeginDrag = false
    /// 是否显示锁
    var isShowLock: Bool = true {
        didSet {
            lockButton.isHidden = !isShowLock
        }
    }
    
    // ------------------------------- private ---------------------------------
    /// 是否锁住 ( 默认false
    private var isLock: Bool = false
    /// 时间formatter
    private let formatter = DateFormatter()
    /// 2s后没操作则隐藏锁、操作栏
    // var delayTask: DelayTask?
    
    // MARK: - Init ----------------------------
    override func _setupUI() {
        [reciecerView,controls,lockButton,loadingView].forEach {
            addSubview($0)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        lockButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 50, height: 50))
            $0.leading.equalTo(safeAreaLayoutGuide.snp.leading).inset(20)
        }
        
        loadingView.startLoading()
        makeAllControls(isHidden: true, isAnimate: false)
    }
    
    // MARK: - Public Method ----------------------------
    // 播放状态
    public override func playerStatusDidChanged(status: OneVideoPlayerManagerPlayerStatus) {
        debugPrint("status = \(status)")
        switch status {
        case .assetLoaded:
            loadingView.startLoading()
            break
        case .readyToPlay:
            controls.bottomBarView.sliderView.duration = endTimeDuration
            let totolTimeText = textWithTime(time: endTimeDuration)
            controls.bottomBarView.endTimeLabel.text = totolTimeText
            break
        case .buffering:
            loadingView.startLoading()
            break
        case .endBuffering:
            loadingView.stopLoading()
            break
        case .didPause:
            updatePlayButton(isPlay: false)
            break
        case .failed:
            updatePlayButton(isPlay: false)
            loadingView.startLoading()
            break
        case .didPlay:
            updatePlayButton(isPlay: true)
            break
        case .didEnd:
            loadingView.stopLoading()
            updatePlayButton(isPlay: false)
            break
        default:
            break
        }
    }
    
    /// 时间的改变
    /// - Parameter time: 时间
    public override func timeDidChange(time: TimeInterval) {
        if !isBeginDrag {
            if endTimeDuration <= 0 {
                return
            }
            let progress = CGFloat(time) / CGFloat(endTimeDuration)
            updateSlider(with: progress)
        }
    }
    
    /// 配置顶部标题
    /// - Parameter title: 标题
    public func configVideoTitleWith(_ title: String?) {
        controls.topBarView.titleLabel.text = title
    }
    
    // MARK: - Private Method ----------------------------
    /// 更新播放按钮按钮
    /// - Parameter isPlay: 是否播放
    private func updatePlayButton(isPlay: Bool) {
        controls.bottomBarView.playButton.isSelected = !isPlay
    }
    
    // 时间
    private func textWithTime(time: TimeInterval) -> String {
        var timeFormat: String = "HH:mm:ss"
        if time <= 3599 {
            timeFormat = "mm:ss"
        }
        let date = Date(timeIntervalSince1970: time)
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        formatter.dateFormat = timeFormat
        return formatter.string(from: date)
    }
    
    /// 让页面元素隐藏与否
    /// - Parameter isHidden: 是否隐藏
    private func makeAllControls(isHidden: Bool, isAnimate: Bool = true) {
        makeControlsVisible(isHidden: isHidden, isAnimate: isAnimate)
        makeLockButtonVisible(isHidden: isHidden, isAnimate: isAnimate)
    }
    
    /// 控制上下bar栏
    /// - Parameters:
    ///   - isHidden: 是否显示
    ///   - isAnimate: 是否动画
    private func makeControlsVisible(isHidden: Bool, isAnimate: Bool = true) {
        let duration: TimeInterval = isAnimate ? 0.25 : 0.01
        let alpha: CGFloat = isHidden ? 0 : 1
        UIView.animate(withDuration: duration) {
            self.controls.makeTopBottomBarVisible(alpha: alpha)
        }completion: { isFinish in
            self.controls.isHidden = isHidden
        }
    }
    
    /// 控制锁按钮
    /// - Parameters:
    ///   - isHidden: 是否显示
    ///   - isAnimate: 是否动画
    private func makeLockButtonVisible(isHidden: Bool, isAnimate: Bool = true) {
        if !isShowLock { return } // 如果不显示锁，则返回
        let duration: TimeInterval = isAnimate ? 0.25 : 0
        let alpha: CGFloat = isHidden ? 0 : 1
        UIView.animate(withDuration: duration) {
            self.lockButton.alpha = alpha
        } completion: { isFinish in
            self.lockButton.isHidden = isHidden
        }
    }
    
    /// 视频长度
    var endTimeDuration: Double {
        return playerView.player.endTime()
    }
    
    /// 更新slider
    func updateSlider(with progress: CGFloat) {
        // 进度
        controls.bottomBarView.sliderView.progress = progress
        // 时间进度
        let time = Double(progress) * endTimeDuration
        let currentTimeText = textWithTime(time: time)
        controls.bottomBarView.beginTimeLabel.text = currentTimeText
        
        let totolTimeText = textWithTime(time: endTimeDuration)
        controls.bottomBarView.endTimeLabel.text = totolTimeText
    }
    
    // MARK: - Touch Event ----------------------------
    // 背景点击
    @objc private func reciecerTapHandler(with sender: UITapGestureRecognizer) {
        debugPrint("reciecerTapHandler, isLock = \(isLock)")
        if isLock {
            makeControlsVisible(isHidden: true)
            makeLockButtonVisible(isHidden: !lockButton.isHidden)
        }else {
            makeAllControls(isHidden: false, isAnimate: true)
        }
    }
    
    // controls点击
    @objc private func controlsTap(with sender: UITapGestureRecognizer) {
        debugPrint("controlsTap, isLock = \(isLock)")
        makeControlsVisible(isHidden: true)
        makeLockButtonVisible(isHidden: !isLock)
    }
    
    // 滑杆状态改变
    private func sliderStatusDidChange(_ status: OneVideoPlayerSliderState) {
        if endTimeDuration <= 0 {
            controls.bottomBarView.sliderView.progress = 0
            return
        }
        uiActionHandler?(.slider(status))
    }
    
    /// 返回的点击
    @objc private func backButtonAction() {
        uiActionHandler?(.back)
    }
    
    /// 锁的点击
    @objc private func lockButtonAction() {
        isLock.toggle()
        makeControlsVisible(isHidden: isLock)
        lockButton.isSelected = isLock
        uiActionHandler?(.lock(isLock))
    }
    
    /// 播放的点击
    @objc private func playButtonAction() {
        // true = 播放状态的样式
        let isPlayMode = controls.bottomBarView.playButton.isSelected
        uiActionHandler?(.playOrPause(isPlayMode))
    }
}
