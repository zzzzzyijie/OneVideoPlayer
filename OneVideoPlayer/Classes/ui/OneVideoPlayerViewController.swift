//
//  OneVideoPlayerViewController.swift
//  Pods
//
//  Created by Jie on 2023/1/16.
//

import UIKit
import OnePlayer

open class OneVideoPlayerViewController: UIViewController {
    
    /// 视频view
    private lazy var videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    /// 播放器
    private lazy var playerView: OnePlayerView = {
        let view = OnePlayerView()
        view.renderingView.playerLayer.videoGravity = .resizeAspect
        view.backgroundColor = .black
        return view
    }()
    
    /// 播放器显示容器
    private lazy var customCoordinator: OneVideoPlayerControlsCoordinator = {
        let view = OneVideoPlayerControlsCoordinator(playerView: playerView)
        view.isShowLock = false
        view.uiActionHandler = { [weak self] action in
            self?.handlerPlayerUIAction(action: action)
        }
        return view
    }()
    
    /// 返回的回调
    public var backTapHandler: ((UIViewController) -> Void)?
    /// 播放管理者
    private var playManager: OnePlayerManager?
    private let videoUrl: String
    private var videoTitle: String?
    // 支持的方向
    private var supportedOrientations: UIInterfaceOrientationMask?
    // present的方向
    private var presentationOrientation: UIInterfaceOrientation?
    
    // MARK: - Life Cycle ----------------------------
    /// 初始化video page
    /// - Parameters:
    ///   - videoUrl: 视频url
    ///   - title: 标题
    ///   - supportedOrientations: 支持的方向
    ///   - presentationOrientation: present的方向
    public init(url: String,
                title: String? = nil,
                supportedOrientations: UIInterfaceOrientationMask? = nil,
                presentationOrientation: UIInterfaceOrientation? = nil) {
        self.videoUrl = url
        self.videoTitle = title
        // 如果外部传进来有值，则取外部的
        self.supportedOrientations = supportedOrientations
        self.presentationOrientation = presentationOrientation
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        preSetup()
        
        setupInit()
        
        setupUI()
        
        setupPlayer()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //super.touchesBegan(touches, with: event)
        // 避免事件穿透
    }
    
    deinit {
        debugPrint("-- OneVideoPlayerViewController is deinit  --")
    }
    
    open override var shouldAutorotate: Bool {
        return super.shouldAutorotate
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let customSupport = supportedOrientations {
            return customSupport
        }else {
            return super.supportedInterfaceOrientations
        }
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let presentationOrientation = presentationOrientation {
            return presentationOrientation
        }else {
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    open override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // MARK: - Init Method ----------------------------
    /// pre
    open func preSetup() {
        
    }
    
    /// init
    private func setupInit() {
        view.backgroundColor = .black
    }
    
    /// ui
    private func setupUI() {
        // Add UI
        view.addSubview(videoView)
        videoView.addSubview(playerView)
        
        // Layout
        videoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        playerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    /// setup player
    private func setupPlayer() {
        playManager = OnePlayerManager(with: playerView, and: customCoordinator)
        playerView.useOnePlayerManager(manager: playManager)
        customCoordinator.configVideoTitleWith(videoTitle)
        startPlay()
    }
    
    // MARK: - Override Method ----------------------------
    // 用于子类重写，获取进度，处理业务逻辑
    open func updateProgress(with progress: CGFloat) {
        
    }
    
    // MARK: - Private Method ----------------------------
    /// 处理ui事件
    private func handlerPlayerUIAction(action: OnePlayerControlsAction) {
        switch action {
        case .back:
            if let backTapHandler = backTapHandler {
                backTapHandler(self)
            }else {
                dismissPageAction()
            }
            break
        case .playOrPause:
            let currentPlayStatus = playManager?.status
            if currentPlayStatus == .didEnd {
                playManager?.rePlay()
            }else {
                playManager?.togglePlayback()
            }
            break
        case .timeChange(let progress):
            updateProgress(with: progress)
            break
        case .slider(let status):
            let total = customCoordinator.endTimeDuration
            switch status {
            case .began:
                debugPrint("----began")
                customCoordinator.isBeginDrag = true
                break
            case .changed(let progress):
                customCoordinator.updateSlider(with: progress)
                break
            case .ended(let progress):
                customCoordinator.updateSlider(with: progress)
                let value = Double(progress) * total
                let isPlaying = playManager?.isVideoPlaying() ?? false
                playManager?.seek(to: value, isAutoPlay: isPlaying,
                                  completionHandler: { [weak self] isFinish in
                    if isFinish {
                        self?.customCoordinator.isBeginDrag = false
                    }
                })
                updateProgress(with: progress)
                break
            case .onTap(let progress):
                customCoordinator.isBeginDrag = true
                customCoordinator.updateSlider(with: progress)
                let value = Double(progress) * total
                let isPlaying = playManager?.isVideoPlaying() ?? false
                playManager?.seek(to: value, isAutoPlay: isPlaying,
                                  completionHandler: { [weak self] isFinish in
                    if isFinish {
                        self?.customCoordinator.isBeginDrag = false
                    }
                })
                updateProgress(with: progress)
                break
            case .cancel:
                customCoordinator.isBeginDrag = false
                debugPrint("----cancel,fial")
                break
            }
            break
        case .lock(let isLock):
            debugPrint(isLock)
            break
        }
    }
    
    /// 退出
    private func dismissPageAction() {
        let controllers: [UIViewController] = navigationController?.viewControllers ?? []
        if controllers.count > 1 { // nav栈里vc > 1 -> pop
            navigationController?.popViewController(animated: true)
        }else { // nav栈里vc只有一个
            if presentingViewController != nil { // 当前是present出来 -> dismiss
                dismiss(animated: true, completion: nil)
            }else { // push -> pop
                navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /// 开始播放
    private func startPlay() {
        guard let url = URL(string: videoUrl) else { return }
        let item = OnePlayerItem(url: url)
        playerView.set(item: item)
    }
}


