//
//  CircuarProgressIndicator.swift
//  MyMusic
//
//  Created by Anatoly on 08.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

class CircuarProgressIndicator: UIView {
    
    let circlePathLayer = CAShapeLayer()
    
    
    let circleRadius: CGFloat = 82.0
    
    
    
    
    var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        backgroundColor = .clear
        progress = 0
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor(white: 1, alpha: 0).cgColor
        circlePathLayer.strokeColor = UIColor.colorWith(red: 155, green: 0, blue: 0).cgColor
        
        layer.addSublayer(circlePathLayer)
        
        
    }

    func circlePath() -> UIBezierPath {
        
        
        return UIBezierPath(arcCenter: CGPoint(x: bounds.width / 2, y: bounds.height / 2),
                                radius: circleRadius,
                                startAngle: CGFloat(-M_PI_2),
                                endAngle: CGFloat(3 * M_PI_2),
                                clockwise: true)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
