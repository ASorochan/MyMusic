//
//  TickerLabel.swift
//  MyMusic
//
//  Created by Anatoly on 13.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

public enum Direction : Int {
    case right = 0
    case left = 1
}

class TickerLabel: UIControl {
    
    //MARK: - Private properties
    private lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = false
        scrollView.backgroundColor = .clear
        return scrollView
    }()
    
    private let defaultText = "Hello World!"
    
    private lazy var firstTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.font = self.font
        label.textColor = self.textColor
        label.text = self.displayingText
        return label
    }()
    
    private lazy var secondTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.font = self.font
        label.textColor = self.textColor
        label.text = self.displayingText
        return label
    }()
    
    private var rect: CGRect = .zero
    private var gradientRect : CGRect = .zero
    
    private var textSize: CGSize! {
        return sizeFor(text: displayingText)
    }
    
    //MARK: - Public API
    var delay: TimeInterval = 5.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var fadeLength: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var scrollSpeed: CGFloat = 100.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var spacing: CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var direction: Direction = .left {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var textColor: UIColor = .black {
        didSet {
            firstTextLabel.textColor = textColor
            secondTextLabel.textColor = textColor
            setNeedsDisplay()
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: 17.0) {
        didSet {
            firstTextLabel.font = font
            secondTextLabel.font = font
            setNeedsDisplay()
        }
    }
    
    var displayingText : String = "Hello Text!" {
        didSet {
            firstTextLabel.text = displayingText
            secondTextLabel.text = displayingText
            setNeedsDisplay()
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
    //MARK: - Helpers
    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(firstTextLabel)
        scrollView.addSubview(secondTextLabel)
        displayingText = defaultText
        backgroundColor = .clear
    }
    
    private func sizeFor(text: String) -> CGSize {
        let convertedText = NSString(string: text)
        let size = convertedText.size(attributes: [NSFontAttributeName: self.font])
        return size
    }
    //MARK: - Animation
    private func animateIfNeeded() {
        self.scrollView.layer.removeAllAnimations()
        
        let duration : TimeInterval = Double((textSize.width * 2 + spacing) / scrollSpeed)
        
        var offset: CGPoint = .zero
        
        switch self.direction {
        case .left:
            offset = CGPoint(x: self.textSize.width + self.spacing  , y: 0)
        case .right:
            offset = CGPoint(x: -self.textSize.width - self.spacing , y: 0)
        }
        
        UIView.animate(withDuration: duration, delay: self.delay , options: [ .curveLinear, .repeat], animations: {
            
            self.scrollView.contentOffset = offset
            
        }, completion: nil)
        
        
    }
    //MARK: - Drawing
    private func applyGradientMaskFor(fadeLength: CGFloat) {
        if fadeLength > 0 {
            let gradientMask = CAGradientLayer()
            gradientMask.bounds = self.layer.bounds
            gradientMask.position = CGPoint(x: self.rect.midX, y: self.rect.midY)
            gradientMask.shouldRasterize = true
            gradientMask.rasterizationScale = UIScreen.main.scale
            gradientMask.startPoint = CGPoint(x: 0, y: self.gradientRect.midY)
            gradientMask.endPoint = CGPoint(x: 1, y: self.gradientRect.midY)
            
            let transparent = UIColor(white: 1.0, alpha: 0.0).cgColor
            let opaque = UIColor.black.cgColor
            
            gradientMask.colors = [transparent, opaque, opaque, transparent]
            
            let fadePoint = fadeLength / self.gradientRect.width
            let leftFadepoint = NSNumber(value: Float(fadePoint))
            let rigthFadePoint = NSNumber(value: Float(1 - fadePoint))
            
            gradientMask.locations = [0, leftFadepoint, rigthFadePoint , 1 ]
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            self.layer.mask = gradientMask
            CATransaction.commit()
        }else {
            self.layer.mask = nil
        }
    }
    
    private func removeGradient() {
        self.layer.mask = nil
    }
    
    override func draw(_ rect: CGRect) {
        
        
        if self.rect == .zero {
            self.rect = rect
            self.scrollView.frame = rect
            self.gradientRect = rect
        }else {
            self.scrollView.frame = self.rect
            self.gradientRect = self.rect
        }
        
        
        if textSize.width < self.rect.width {
            self.scrollView.contentSize = self.rect.size
            firstTextLabel.frame = self.rect
            secondTextLabel.isHidden = true
            self.scrollView.layer.removeAllAnimations()
            self.scrollView.contentOffset = CGPoint(x: -(self.rect.width / 2 - textSize.width / 2), y: 0)
            removeGradient()
        }else {
            self.scrollView.contentSize = CGSize(width: textSize.width * 2 + spacing, height: textSize.height)
            switch self.direction {
            case .left:
                firstTextLabel.frame = CGRect(x: 0, y: self.rect.origin.y, width: textSize.width, height: rect.height )
                secondTextLabel.frame = CGRect(x: firstTextLabel.frame.width + spacing, y: self.rect.origin.y, width: textSize.width, height: self.rect.height)
            case .right:
                firstTextLabel.frame = CGRect(x: 0, y: self.rect.origin.y, width: textSize.width, height: self.rect.height )
                secondTextLabel.frame = CGRect(x: -firstTextLabel.frame.width - spacing, y: self.rect.origin.y, width: textSize.width, height: self.rect.height)
            }
            self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            secondTextLabel.isHidden = false
            animateIfNeeded()
            applyGradientMaskFor(fadeLength: fadeLength)
        }
    }
    
    
    
    
}
