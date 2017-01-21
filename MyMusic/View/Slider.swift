//
//  Slider.swift
//  MyMusic
//
//  Created by Anatoly on 09.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

let sliderTrackingStatusDidChangeNotification = Notification.Name("com.Anatoly-Sorochan.kSliderTrackingStatusDidChangeNotification")
let kTrackingStatus = "kTrackingStatus"

class Slider: UIControl {
    
    //MARK: - Public propeties
    var lineWidth: CGFloat = 2.0
    var radius: CGFloat = 5.0
    var minimumColor: UIColor = .green
    var maximumColor: UIColor = .red
    var growValue: CGFloat = 1.0
    
    var minimumValue: CGFloat = 0.0 {
        didSet {
            if value < minimumValue {
                value = minimumValue
            }
        }
    }
    
    var maximumValue: CGFloat = 1.0 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            }
        }
    }
    
    var value: CGFloat = 0.2 {
        didSet {
            if value > maximumValue {
                value = maximumValue
            }
            if value < minimumValue {
                value = minimumValue
            }
            self.setNeedsDisplay()
            self.sendActions(for: .valueChanged)
        }
    }
    
    var cursourBackgroundColor : UIColor = .white {
        didSet {
            self.setNeedsDisplay()
        }
    }

    //MARK: - Private propeties
    private var width: CGFloat = 0.0
    private var touchAbilitySurface: CGFloat = 50.0
    private var startTrackingValue: CGFloat = 0.0
    private var startLocation = CGPoint(x: 0.0, y: 0.0)
    private var trackingStatus = false
    private var isExpanded = false
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    private func valueFromTranslation(translation: CGFloat) -> CGFloat {
        return maximumValue * translation / width
    }
    
    private func locationFromValue(value: CGFloat) -> CGFloat {
        let location = calculateRect().minX + calculateRect().width * (value - minimumValue) / (maximumValue - minimumValue)
        return location
    }
    private func postTrackingStatusDidChangeNotification() {
        NotificationCenter.default.post(name: sliderTrackingStatusDidChangeNotification, object: self, userInfo: [kTrackingStatus: trackingStatus])
    }
    //MARK: - Touch events
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        startLocation = location
        let rect = CGRect(x: locationFromValue(value: value) - touchAbilitySurface / 2,
                          y: calculateRect().midY - touchAbilitySurface / 2,
                          width: touchAbilitySurface,
                          height: touchAbilitySurface)
        if rect.contains(location) {
            trackingStatus = true
            postTrackingStatusDidChangeNotification()
            startTrackingValue = value
            zoomIn()
            sendActions(for: .touchDown)
            return true
        }
        trackingStatus = false
        
        return super.beginTracking(touch, with: event)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        if trackingStatus {
            self.value = startTrackingValue + valueFromTranslation(translation: location.x - startLocation.x)
            self.sendActions(for: .touchDragExit)
            
            return true
        }
        return super.continueTracking(touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        trackingStatus = false
        self.sendActions(for: .touchUpOutside)
        postTrackingStatusDidChangeNotification()
        zoomOut()
        super.endTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        trackingStatus = false
        postTrackingStatusDidChangeNotification()
        zoomOut()
        super.cancelTracking(with: event)
    }
    //MARK: - Animation elements
    private func zoomOut() {
        if isExpanded {
            lineWidth -= growValue
            radius -= growValue
            isExpanded = false
        }
        setNeedsDisplay()
    }
    private func zoomIn() {
        if !isExpanded {
            lineWidth += growValue
            radius += growValue
            isExpanded = true
        }
        setNeedsDisplay()
    }
    //MARK: - Drawing
    private func calculateRect() -> CGRect {
        var frame: CGRect = .zero
        frame.size = CGSize(width: width - lineWidth, height: lineWidth)
        frame.origin = CGPoint(x: (self.frame.width - width ) / 2 + lineWidth / 2,
                               y: self.frame.height / 2 - lineWidth)
        return frame
    }
    
    override func draw(_ rect: CGRect) {
        width = self.frame.width - 2 * radius
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(maximumColor.cgColor)
        context?.setLineWidth(lineWidth)
        context?.move(to: CGPoint(x: calculateRect().minX, y: calculateRect().midY))
        context?.addLine(to: CGPoint(x: calculateRect().maxX, y: calculateRect().midY))
        context?.setLineCap(.round)
        
        context?.strokePath()
        
        context?.setFillColor(cursourBackgroundColor.cgColor)
        context?.setStrokeColor(minimumColor.cgColor)
        context?.move(to: CGPoint(x: calculateRect().minX, y: calculateRect().midY))
        context?.addLine(to: CGPoint(x: locationFromValue(value: value), y: calculateRect().midY))
        
        context?.strokePath()
        
        context?.addArc(center: CGPoint(x: locationFromValue(value: value), y: calculateRect().midY),
                        radius: radius, startAngle: 0, endAngle: CGFloat(M_PI * 2.0) , clockwise: false)
        
        context?.drawPath(using: .fillStroke)
    }
}
