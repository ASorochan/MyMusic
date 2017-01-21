//
//  SpringButton.swift
//  MyMusic
//
//  Created by Anatoly on 11.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

class SpringButton: UIControl {
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var isTransformed = false
    
    
    //MARK: - Public API
    var xScale: CGFloat = 0.8
    var yScale: CGFloat = 0.8
    
    var transformedIconTintColor: UIColor = .red
    var iconTintColor: UIColor = .white {
        didSet {
            self.tintColor = iconTintColor
        }
    }
    
    var iconImage: UIImage? {
        get {
            return iconImageView.image
        }
        set(newImage) {
            iconImageView.image = newImage?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    //MARK: - Initialization
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        iconImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        iconTintColor = .white
    }
    //MARK: - Animation
    private func zoomIn() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        self.tintColor = self.iconTintColor
                        self.alpha = 1.0
                        self.transform = CGAffineTransform.identity
        },
                       completion: nil)
    }
    
    private func zoomOut() {
        UIView.animate(withDuration: 0.15, animations: {
            self.tintColor = self.transformedIconTintColor
            self.alpha = 0.9
            self.transform = CGAffineTransform(scaleX: self.xScale, y: self.yScale)
        })
    }
    
    //MARK: - Touch events
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if !isTransformed {
            zoomOut()
            isTransformed = true
            self.sendActions(for: .touchDown)
            return true
        }
        return super.beginTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        if isTransformed {
            zoomIn()
            isTransformed = false
            if !self.bounds.contains((touch?.location(in: self))!) {
                self.sendActions(for: .touchUpInside)
                return
            }
            self.sendActions(for: .touchUpInside)
        }
        
    }
    
    override func cancelTracking(with event: UIEvent?) {
        if isTransformed {
            zoomIn()
            self.sendActions(for: .touchUpInside)
            isTransformed = false
        }
        super.cancelTracking(with: event)
    }
}

