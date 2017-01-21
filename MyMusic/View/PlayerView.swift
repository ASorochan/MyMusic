//
//  PlayerView.swift
//  MyMusic
//
//  Created by Anatoly on 07.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerView: UIView {
    
    //MARK: - SmallPlayer
    
    lazy var progresBar : UIProgressView = {
        let progress = UIProgressView()
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.progress = 0.0
        progress.progressTintColor = .red
        return progress
    }()
    
    lazy var smallAlbumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "no_image")
        return imageView
    }()
    
    //MARK: - BigPlayer
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    var isExpanded = false
    var smallImageSize = CGSize(width: 64.0, height: 63.0)
    var bigImageSize = CGSize(width: 160.0, height: 160.0)
    
    var mediaItem: MPMediaItem? {
        didSet {
            
            if mediaItem != nil {
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTimerUpdate), userInfo: nil, repeats: true)
//                var smallImage = getArtworkImage(item: mediaItem!, ofSize: smallImageSize)
//                var bgImage = getArtworkImage(item: mediaItem!, ofSize: self.frame.size)
//                var bigImage = getArtworkImage(item: mediaItem!, ofSize: bigImageSize)
//                
//                
//                smallAlbumImageView.image = nil
//                bigAlbumImageView.image = nil
//                backgroundImageView.image = nil
                
                smallAlbumImageView.image = mediaItem!.artwork?.image(at: smallImageSize)
                bigAlbumImageView.image = mediaItem!.artwork?.image(at: bigImageSize)
                backgroundImageView.image = mediaItem!.artwork?.image(at: self.frame.size)
//                
//                smallImage = nil
//                bgImage = nil
//                bigImage = nil
//                

            currentDurationLabel.text = formatTime(time: 0)
            circularProgress.progress = 0
            progresBar.progress = 0
            trackSeekSlider.value = 0
            durationLabel.text = formatTime(time: mediaItem!.playbackDuration)
            trackSeekSlider.maximumValue = CGFloat(mediaItem!.playbackDuration)
            if let title = mediaItem?.title {
                songTitleLabel.displayingText = title
            }
            albumArtistNameLabel.displayingText = formatMediaItemArtistNameAndAlbumTitle(mediaItem: mediaItem!)
            
            }
        }
    }
    
    //MARK: - Image and circular progress
    lazy var bigAlbumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 80.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var circularProgress: CircuarProgressIndicator = {
        let indicator = CircuarProgressIndicator()
        indicator.progress = 0.0
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    //MARK: - Track seek and time labels
    lazy var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var trackSeekSlider: Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.lineWidth = 2.0
        slider.radius = 5.0
        slider.minimumColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        slider.maximumColor = .white
        slider.cursourBackgroundColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        slider.addTarget(self, action: #selector(handleSlide), for: .valueChanged)
        return slider
    }()
    
    var trackSeekSliderTouched = false
    
    lazy var currentDurationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00"
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var durationLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "3:43"
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var originalFrame : CGRect = .zero
    
    //MARK: - Play pause forward backward buttons
    lazy var controlsContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        //view.backgroundColor = .green
        return view
    }()
    
    lazy var playPauseButton: SpringButton = {
        let button = SpringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transformedIconTintColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        button.iconImage = UIImage(named: "pause")
        button.addTarget(self, action: #selector(handlePlayPause(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var forwardButton: SpringButton = {
        let button = SpringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transformedIconTintColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        button.iconImage = UIImage(named: "forward")
        button.addTarget(self, action: #selector(handleForward(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var backwardButton: SpringButton = {
        let button = SpringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transformedIconTintColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        button.iconImage = UIImage(named: "backward")
        button.addTarget(self, action: #selector(handleBackward(sender:)), for: .touchUpInside)
        return button
    }()
    //MARK: - Song titles labels
    lazy var titlesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var songTitleLabel: TickerLabel = {
        let label = TickerLabel()
        label.delay = 5.0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.fadeLength = 30.0
        label.scrollSpeed = 100.0
        label.spacing = 25.0
        return label
    }()
    
    lazy var albumArtistNameLabel: TickerLabel = {
        let label = TickerLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.delay = 5.0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.fadeLength = 30.0
        label.scrollSpeed = 100.0
        label.spacing = 25.0
        return label
    }()
    //MARK: - Volume controls
    var volumeView = MPVolumeView()
    
    lazy var volumeControlsContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var standartVolumeSlider = UISlider()
    
    lazy var volumeSlider : Slider = {
        let slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.lineWidth = 3.0
        slider.radius = 10.0
        slider.value = CGFloat(self.standartVolumeSlider.value)
        slider.growValue = 0.0
        slider.maximumValue = CGFloat(self.standartVolumeSlider.maximumValue)
        slider.minimumColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        slider.maximumColor = .white
        slider.cursourBackgroundColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        slider.addTarget(self, action: #selector(handleVolumeSlide), for: .valueChanged)
        return slider
    }()
    
    lazy var volumeOffSpeakerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "volume-off")
        return imageView
    }()
    
    lazy var volumeOnSpeakerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "volume-on")
        return imageView
    }()
    //MARK: - Shuffle repeat buttons
    
    lazy var shuffleButton: SpringButton = {
        let button = SpringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.iconImage = UIImage(named: "shuffle")
        button.iconTintColor = self.shuffleMode == .off ? .white : UIColor.colorWith(red: 155, green: 0, blue: 0)
        button.addTarget(self, action: #selector(handleShuffle), for: .touchUpInside)
        return button
    }()
    
   private var shuffleMode : MPMusicShuffleMode {
        return SongManager.sharedManager.player.shuffleMode
    }
    
    private var repeatMode: MPMusicRepeatMode {
        return SongManager.sharedManager.player.repeatMode
    }
    lazy var repeatButton: SpringButton = {
        let button = SpringButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRepeat), for: .touchUpInside)
        button.iconImage = self.repeatMode == .one ? UIImage(named: "repeatOne") : UIImage(named:"repeat")
        button.iconTintColor = self.repeatMode == .none ? .white : UIColor.colorWith(red: 155, green: 0, blue: 0)
        return button
    }()
    
    lazy var gestureView = UIView()
    
    private var smallViewIsExist = false
    private var bigViewIsExist = false
    
    var timer: Timer?
    
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
        
        standartVolumeSlider = volumeView.subviews.filter { NSStringFromClass($0.classForCoder) == "MPVolumeSlider" }.first as! UISlider
        standartVolumeSlider.isHidden = true
        volumeView.showsVolumeSlider = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTrackingStatusDidChange), name: sliderTrackingStatusDidChangeNotification, object: trackSeekSlider)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleNowPlayingItemDidChange),
                                               name: Notification(name:.MPMusicPlayerControllerNowPlayingItemDidChange).name,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlaybackDidChange), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleVolumeDidChange), name: .MPMusicPlayerControllerVolumeDidChange, object: nil)
        
        
        
        SongManager.sharedManager.player.beginGeneratingPlaybackNotifications()
        
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTimerUpdate), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    
    private func setupView() {
        self.backgroundColor = .clear
        self.hideViews()
        
        
        if bigViewIsExist && smallViewIsExist {
            
            
            self.bigAlbumImageView.image = getArtworkImage(item: self.mediaItem!, ofSize: self.bigImageSize)
            self.backgroundImageView.image = getArtworkImage(item: self.mediaItem!, ofSize: self.frame.size)
            if let title = self.mediaItem!.title {
                self.songTitleLabel.displayingText = title
            }
            self.albumArtistNameLabel.displayingText = formatMediaItemArtistNameAndAlbumTitle(mediaItem: self.mediaItem!)
            DispatchQueue.main.async(execute: {
                self.titlesContainerView.setNeedsDisplay()
            })
            
            let playbackState = SongManager.sharedManager.player.playbackState
            
            switch playbackState {
            case .playing:
                self.playPauseButton.iconImage = UIImage(named:"pause")
            case .paused:
                self.playPauseButton.iconImage = UIImage(named:"play")
            case .stopped:
                self.playPauseButton.iconImage = UIImage(named:"play")
            default:
                break
            }
            
            
            return
        }
        
        if !isExpanded {
            addSubview(progresBar)
            addSubview(smallAlbumImageView)
            self.alpha = 1
            smallAlbumImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            smallAlbumImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            smallAlbumImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true
            smallAlbumImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            
            progresBar.topAnchor.constraint(equalTo: smallAlbumImageView.topAnchor).isActive = true
            progresBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            progresBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            progresBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            
            if let item = self.mediaItem {
                smallAlbumImageView.image = nil
                smallAlbumImageView.image = getArtworkImage(item: item, ofSize: smallImageSize)
            }
            self.smallViewIsExist = true
        }else {
            
            self.setupBackground()
            
            addSubview(bigAlbumImageView)
            addSubview(circularProgress)
            
            
            
            self.bigAlbumImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            self.bigAlbumImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 64).isActive = true
            self.bigAlbumImageView.heightAnchor.constraint(equalToConstant: 160).isActive = true
            self.bigAlbumImageView.widthAnchor.constraint(equalToConstant: 160).isActive = true
            self.bigAlbumImageView.image = nil
            self.bigAlbumImageView.image = getArtworkImage(item: self.mediaItem!, ofSize: bigImageSize)
            
            self.circularProgress.centerXAnchor.constraint(equalTo: self.bigAlbumImageView.centerXAnchor).isActive = true
            self.circularProgress.topAnchor.constraint(equalTo: self.topAnchor, constant: 64).isActive = true
            self.circularProgress.heightAnchor.constraint(equalToConstant: 160).isActive = true
            self.circularProgress.widthAnchor.constraint(equalToConstant: 160).isActive = true
            
            self.setupContainerView()
            self.setupTitlesContainerView()
            self.setupControlsContainerView()
            self.setupVolumeControlsContainerView()
            self.setupRepeatShuffleButtons()
            self.bigViewIsExist = true
        }
    }
    
    
    private func setupRepeatShuffleButtons() {
        
        self.addSubview(shuffleButton)
        self.addSubview(repeatButton)
        
        self.shuffleButton.topAnchor.constraint(equalTo: self.volumeControlsContainerView.bottomAnchor, constant: 32).isActive = true
        self.shuffleButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 32).isActive = true
        self.shuffleButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.shuffleButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        self.repeatButton.topAnchor.constraint(equalTo: self.volumeControlsContainerView.bottomAnchor, constant: 32).isActive = true
        self.repeatButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -32).isActive = true
        self.repeatButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.repeatButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        
    }
    
    
    private func setupVolumeControlsContainerView() {
        addSubview(volumeControlsContainerView)
        
        self.volumeControlsContainerView.topAnchor.constraint(equalTo: self.controlsContainerView.bottomAnchor, constant: 16).isActive = true
        self.volumeControlsContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.volumeControlsContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.volumeControlsContainerView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.volumeControlsContainerView.addSubview(volumeSlider)
        self.volumeControlsContainerView.addSubview(volumeOnSpeakerImageView)
        self.volumeControlsContainerView.addSubview(volumeOffSpeakerImageView)
    
        self.volumeOffSpeakerImageView.leftAnchor.constraint(equalTo: self.volumeControlsContainerView.leftAnchor).isActive = true
        //self.volumeOffSpeakerImageView.rightAnchor.constraint(equalTo: self.volumeSlider.leftAnchor, constant: -4).isActive = true
        self.volumeOffSpeakerImageView.centerYAnchor.constraint(equalTo: self.volumeControlsContainerView.centerYAnchor).isActive = true
        self.volumeOffSpeakerImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.volumeOffSpeakerImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        self.volumeSlider.centerXAnchor.constraint(equalTo: self.volumeControlsContainerView.centerXAnchor).isActive = true
        self.volumeSlider.centerYAnchor.constraint(equalTo: self.volumeControlsContainerView.centerYAnchor).isActive = true
        //        self.volumeSlider.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -68).isActive = true
        self.volumeSlider.leftAnchor.constraint(equalTo: self.volumeOffSpeakerImageView.rightAnchor, constant: 4).isActive = true
        self.volumeSlider.rightAnchor.constraint(equalTo: self.volumeOnSpeakerImageView.leftAnchor, constant: -4).isActive = true
        self.volumeSlider.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // self.volumeOnSpeakerImageView.leftAnchor.constraint(equalTo: self.volumeSlider.rightAnchor, constant: 4).isActive = true
        self.volumeOnSpeakerImageView.rightAnchor.constraint(equalTo: self.volumeControlsContainerView.rightAnchor).isActive = true
        self.volumeOnSpeakerImageView.centerYAnchor.constraint(equalTo: self.volumeControlsContainerView.centerYAnchor).isActive = true
        self.volumeOnSpeakerImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        self.volumeOnSpeakerImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        
    }
    
    
    private func setupTitlesContainerView() {
        addSubview(titlesContainerView)
        
        self.titlesContainerView.topAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: 8).isActive = true
        self.titlesContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.titlesContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.titlesContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.titlesContainerView.addSubview(songTitleLabel)
        self.titlesContainerView.addSubview(albumArtistNameLabel)
        
        self.songTitleLabel.topAnchor.constraint(equalTo: self.titlesContainerView.topAnchor).isActive = true
        self.songTitleLabel.rightAnchor.constraint(equalTo: self.titlesContainerView.rightAnchor).isActive = true
        self.songTitleLabel.leftAnchor.constraint(equalTo: self.titlesContainerView.leftAnchor).isActive = true
        self.songTitleLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        
        self.albumArtistNameLabel.topAnchor.constraint(equalTo: self.songTitleLabel.bottomAnchor, constant: 4).isActive = true
        self.albumArtistNameLabel.rightAnchor.constraint(equalTo: self.titlesContainerView.rightAnchor).isActive = true
        self.albumArtistNameLabel.leftAnchor.constraint(equalTo: self.titlesContainerView.leftAnchor).isActive = true
        self.albumArtistNameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        if let title = mediaItem!.title {
            self.songTitleLabel.displayingText = title
        }
        self.albumArtistNameLabel.displayingText = formatMediaItemArtistNameAndAlbumTitle(mediaItem: mediaItem!)
        
    }
    
    private func setupControlsContainerView() {
        
        addSubview(controlsContainerView)
        
        self.controlsContainerView.topAnchor.constraint(equalTo: self.titlesContainerView.bottomAnchor, constant: 16).isActive = true
        self.controlsContainerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.controlsContainerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.controlsContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.controlsContainerView.addSubview(backwardButton)
        self.controlsContainerView.addSubview(playPauseButton)
        self.controlsContainerView.addSubview(forwardButton)
        
        self.playPauseButton.centerYAnchor.constraint(equalTo: self.controlsContainerView.centerYAnchor).isActive = true
        self.playPauseButton.centerXAnchor.constraint(equalTo: self.controlsContainerView.centerXAnchor).isActive = true
        self.playPauseButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.playPauseButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        self.backwardButton.centerXAnchor.constraint(equalTo: self.controlsContainerView.centerXAnchor, constant: -96).isActive = true
        self.backwardButton.centerYAnchor.constraint(equalTo: self.controlsContainerView.centerYAnchor).isActive = true
        self.backwardButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.backwardButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        self.forwardButton.centerXAnchor.constraint(equalTo: self.controlsContainerView.centerXAnchor, constant: 96).isActive = true
        self.forwardButton.centerYAnchor.constraint(equalTo: self.controlsContainerView.centerYAnchor).isActive = true
        self.forwardButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.forwardButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
    }
    private func setupContainerView() {
        
        addSubview(containerView)
        
        self.containerView.topAnchor.constraint(equalTo: self.bigAlbumImageView.bottomAnchor, constant: 16).isActive = true
        self.containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.containerView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        self.containerView.addSubview(trackSeekSlider)
        self.containerView.addSubview(currentDurationLabel)
        self.containerView.addSubview(durationLabel)
        
        self.trackSeekSlider.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 4).isActive = true
        self.trackSeekSlider.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -4).isActive = true
        self.trackSeekSlider.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.trackSeekSlider.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        
        self.currentDurationLabel.leftAnchor.constraint(equalTo: self.containerView.leftAnchor, constant: 8).isActive = true
        self.currentDurationLabel.topAnchor.constraint(equalTo: self.trackSeekSlider.bottomAnchor).isActive = true
        self.currentDurationLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.currentDurationLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        
        self.durationLabel.rightAnchor.constraint(equalTo: self.containerView.rightAnchor, constant: -8).isActive = true
        self.durationLabel.topAnchor.constraint(equalTo: self.trackSeekSlider.bottomAnchor).isActive = true
        self.durationLabel.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.durationLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
    }
    
    
    private func setupBackground() {
        
        backgroundImageView.frame = self.frame
        backgroundImageView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        addSubview(backgroundImageView)
        self.backgroundImageView.image = nil
        self.backgroundImageView.image = getArtworkImage(item: self.mediaItem!, ofSize: self.frame.size)
        blurEffectView.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        addSubview(blurEffectView)
        blurEffectView.frame = self.frame
        
        
        gestureView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2, height: self.frame.height / 3))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(hanleMinimize))
        gestureView.backgroundColor = .clear
        
        gestureView.addGestureRecognizer(panGesture)
        
        self.addSubview(gestureView)
        let arrowImageView = UIImageView(frame: CGRect(x: 10, y: 20, width: 32, height: 32))
        arrowImageView.image = UIImage(named: "arrow")
        arrowImageView.backgroundColor = .clear
        gestureView.addSubview(arrowImageView)
        
    }
    
    //MARK: - Actions
    
    func handleRepeat(sender:SpringButton) {
        switch repeatMode {
        case .all:
            repeatButton.iconImage = UIImage(named: "repeatOne")
            SongManager.sharedManager.player.repeatMode = .one
        case .one:
            repeatButton.iconImage = UIImage(named: "repeat")
            repeatButton.iconTintColor = .white
            SongManager.sharedManager.player.repeatMode = .none
        case .none:
            repeatButton.iconImage = UIImage(named: "repeat")
            repeatButton.iconTintColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
            SongManager.sharedManager.player.repeatMode = .all
        default:
            break
        }
        
        
    }
    
    func handleShuffle(sender:SpringButton) {
        switch shuffleMode {
        case .off:
            SongManager.sharedManager.player.shuffleMode = .songs
            shuffleButton.iconTintColor = UIColor.colorWith(red: 155, green: 0, blue: 0)
        case .songs:
            SongManager.sharedManager.player.shuffleMode = .off
            shuffleButton.iconTintColor = .white
        default:
            break
        }
        
    }
    
    func handlePlayPause(sender: SpringButton) {
        let playerState = SongManager.sharedManager.currentPlaybackState()
        
        if playerState == .paused {
            playPauseButton.iconImage = UIImage(named: "pause")
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTimerUpdate), userInfo: nil, repeats: true)
            SongManager.sharedManager.player.play()
            
            
        }else if playerState == .playing {
            timer?.invalidate()
            timer = nil
            SongManager.sharedManager.player.pause()
            playPauseButton.iconImage = UIImage(named: "play")
            
            
        }
        
    }
    func handleForward(sender: SpringButton) {
        
        SongManager.sharedManager.forward()
    }
    
    func handleBackward(sender: SpringButton) {
        SongManager.sharedManager.backward()
        
        
    }
    
   
    
    func handleSlide(slider: Slider) {
        if trackSeekSliderTouched {
                if let duration = SongManager.sharedManager.player.nowPlayingItem?.playbackDuration {
                    let currentTime = TimeInterval(slider.value)
                    self.circularProgress.progress = CGFloat(currentTime / self.mediaItem!.playbackDuration)
                    let remainingTime = duration - currentTime
                    
                    self.currentDurationLabel.text = formatTime(time: currentTime)
                    self.durationLabel.text = formatTime(time: remainingTime)

            }
        }
    }
    
   
    
    func handleVolumeSlide(slider: Slider) {
        volumeView.showsVolumeSlider = false
        standartVolumeSlider.value = Float(slider.value)
    }
    
    
    //MARK: - Helpers
    
    
    func handleTrackingStatusDidChange(notification:Notification) {
        
        let status = notification.userInfo?[kTrackingStatus] as! Bool
        
        if status {
            trackSeekSliderTouched = true
            timer?.invalidate()
            timer = nil
        }else {
            SongManager.sharedManager.player.currentPlaybackTime = TimeInterval(trackSeekSlider.value)
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTimerUpdate), userInfo: nil, repeats: true)
        }
        
        trackSeekSliderTouched = status
    }
    
    func handleTimerUpdate() {
        if !trackSeekSliderTouched{
        if let duration = mediaItem?.playbackDuration {
            let currentTime = SongManager.sharedManager.player.currentPlaybackTime
            let remainingTime = duration - currentTime
            
            self.currentDurationLabel.text = formatTime(time: currentTime)
            self.durationLabel.text = formatTime(time: remainingTime)
            self.trackSeekSlider.value = CGFloat(currentTime)
            let progress = CGFloat(currentTime / mediaItem!.playbackDuration)
            self.progresBar.progress = Float(progress)
            self.circularProgress.progress = progress
            
        }
        }
    }
    
    func handleVolumeDidChange() {
        self.volumeSlider.value = CGFloat(standartVolumeSlider.value)
        
    }
    
    func handlePlaybackDidChange() {
        
        
        
    }
    
    
    func handleNowPlayingItemDidChange() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        if let currentItem = SongManager.sharedManager.player.nowPlayingItem {
            mediaItem = nil
            mediaItem = currentItem
        }
        //SongManager.sharedManager.player.nowPlayingItem = nil
    }
    
    func hideViews() {
        if isExpanded {
            
            self.smallAlbumImageView.isHidden = true
            self.progresBar.isHidden = true
            
            self.backgroundImageView.isHidden = false
            self.blurEffectView.isHidden = false
            self.circularProgress.isHidden = false
            self.bigAlbumImageView.isHidden = false
            self.containerView.isHidden = false
            self.controlsContainerView.isHidden = false
            self.titlesContainerView.isHidden = false
            self.gestureView.isHidden = false
            self.volumeControlsContainerView.isHidden = false
            self.shuffleButton.isHidden = false
            self.repeatButton.isHidden = false
            self.titlesContainerView.setNeedsDisplay()
            
        }else {
            
            self.backgroundImageView.isHidden = true
            self.blurEffectView.isHidden = true
            self.circularProgress.isHidden = true
            self.bigAlbumImageView.isHidden = true
            self.containerView.isHidden = true
            self.controlsContainerView.isHidden = true
            self.titlesContainerView.isHidden = true
            self.gestureView.isHidden = true
            self.volumeControlsContainerView.isHidden = true
            self.shuffleButton.isHidden = true
            self.repeatButton.isHidden = true
            
            self.smallAlbumImageView.isHidden = false
            self.progresBar.isHidden = false
            
        }
    }
    
    
    //MARK: - Gestures
    
    
    func handleTap() {
        if !isExpanded {
            guard let keyWindow = UIApplication.shared.keyWindow else {return}
            
            isExpanded = true
            let finalFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height)
            
            
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut,
                           animations: {
                            self.frame = finalFrame
                            self.setupView()
            }, completion: nil)
            self.volumeSlider.setNeedsDisplay()
            self.trackSeekSlider.setNeedsDisplay()
        }
    }
    
    
    
    func hanleMinimize(gesture:UIPanGestureRecognizer) {
        let screenFrame = UIScreen.main.bounds
        
        let translation = gesture.translation(in: self)
        
        if isExpanded {
            
            
            if gesture.state == .began {
                originalFrame = self.frame
                
                
            }else if gesture.state == .changed {
                if translation.y > 0 {
                    var newFrame = originalFrame
                    newFrame.origin.x += translation.y
                    
                    
                    newFrame.origin.y += translation.y
                    newFrame.size.width -= translation.y
                    newFrame.size.height -= translation.y
                    self.frame = newFrame
                    
                }
                if translation.y > self.frame.size.height / 3 {
                    forceMinimize(screenFrame: screenFrame, translation: translation)
                }
            }else if gesture.state == .cancelled || gesture.state == .ended || gesture.state == .failed {
                
                forceMinimize(screenFrame: screenFrame, translation: translation)
            }
            self.volumeSlider.setNeedsDisplay()
            self.trackSeekSlider.setNeedsDisplay()
        }
    }
    
    private func forceMinimize(screenFrame:CGRect, translation: CGPoint) {
        var finalFrame = originalFrame
        if translation.y > self.frame.size.height / 3 {
            finalFrame.size.width = smallPlayerSide
            finalFrame.size.height = smallPlayerSide
            finalFrame.origin.x = screenFrame.width - smallPlayerSide
            finalFrame.origin.y = screenFrame.height - smallPlayerSide - tabBarHeight
            self.isExpanded = false
            self.setupView()
            
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame = finalFrame
            self.alpha = 1
        }, completion: nil)
        
    }
}

