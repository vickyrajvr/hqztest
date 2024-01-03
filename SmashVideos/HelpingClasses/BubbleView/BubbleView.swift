//
//  BubbleView.swift
//  WOOW
//
//  Created by Mac on 25/08/2022.
//

import Foundation
import UIKit

@IBDesignable class BubbleView: UIView { // 1
    
    override init(frame: CGRect) { // 2
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        super.backgroundColor = .clear // 3
    }
    
    private var bubbleColor: UIColor? { // 4
        didSet {
            setNeedsDisplay() // 5
        }
    }
    
    override var backgroundColor: UIColor? { // 6
        get { return bubbleColor }
        set { bubbleColor = newValue }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 0 { // 1
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear { // 2
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath()
        bezierPath.lineWidth = borderWidth // 3
        
        let bottom = rect.height - borderWidth // 4
        let right = rect.width - borderWidth
        let top = borderWidth
        let left = borderWidth
        
        
        
        if arrowDirection == .right { // 4
            
            bezierPath.move(to: CGPoint(x: right - 22, y: bottom)) // 5
            bezierPath.addLine(to: CGPoint(x: 17 + borderWidth, y: bottom))
            bezierPath.addCurve(to: CGPoint(x: left, y: bottom - 18), controlPoint1: CGPoint(x: 7.61 + borderWidth, y: bottom), controlPoint2: CGPoint(x: left, y: bottom - 7.61))
            bezierPath.addLine(to: CGPoint(x: left, y: 17 + borderWidth))
            bezierPath.addCurve(to: CGPoint(x: 17 + borderWidth, y: top), controlPoint1: CGPoint(x: left, y: 7.61 + borderWidth), controlPoint2: CGPoint(x: 7.61 + borderWidth, y: top))
            bezierPath.addLine(to: CGPoint(x: right - 21, y: top))
            bezierPath.addCurve(to: CGPoint(x: right - 4, y: 17 + borderWidth), controlPoint1: CGPoint(x: right - 11.61, y: top), controlPoint2: CGPoint(x: right - 4, y: 7.61 + borderWidth))
            bezierPath.addLine(to: CGPoint(x: right - 4, y: bottom - 11))
            bezierPath.addCurve(to: CGPoint(x: right, y: bottom), controlPoint1: CGPoint(x: right - 4, y: bottom - 1), controlPoint2: CGPoint(x: right, y: bottom))
            bezierPath.addLine(to: CGPoint(x: right + 0.05, y: bottom - 0.01))
            bezierPath.addCurve(to: CGPoint(x: right - 11.04, y: bottom - 4.04), controlPoint1: CGPoint(x: right - 4.07, y: bottom + 0.43), controlPoint2: CGPoint(x: right - 8.16, y: bottom - 1.06))
            bezierPath.addCurve(to: CGPoint(x: right - 22, y: bottom), controlPoint1: CGPoint(x: right - 16, y: bottom), controlPoint2: CGPoint(x: right - 19, y: bottom))
            
            // ... unchanged
        } else {
            bezierPath.move(to: CGPoint(x: 22 + borderWidth, y: bottom)) // 5
            bezierPath.addLine(to: CGPoint(x: right - 17, y: bottom))
            bezierPath.addCurve(to: CGPoint(x: right, y: bottom - 17), controlPoint1: CGPoint(x: right - 7.61, y: bottom), controlPoint2: CGPoint(x: right, y: bottom - 7.61))
            bezierPath.addLine(to: CGPoint(x: right, y: 17 + borderWidth))
            bezierPath.addCurve(to: CGPoint(x: right - 17, y: top), controlPoint1: CGPoint(x: right, y: 7.61 + borderWidth), controlPoint2: CGPoint(x: right - 7.61, y: top))
            bezierPath.addLine(to: CGPoint(x: 21 + borderWidth, y: top))
            bezierPath.addCurve(to: CGPoint(x: 4 + borderWidth, y: 17 + borderWidth), controlPoint1: CGPoint(x: 11.61 + borderWidth, y: top), controlPoint2: CGPoint(x: borderWidth + 4, y: 7.61 + borderWidth))
            bezierPath.addLine(to: CGPoint(x: borderWidth + 4, y: bottom - 11))
            bezierPath.addCurve(to: CGPoint(x: borderWidth, y: bottom), controlPoint1: CGPoint(x: borderWidth + 4, y: bottom - 1), controlPoint2: CGPoint(x: borderWidth, y: bottom))
            bezierPath.addLine(to: CGPoint(x: borderWidth - 0.05, y: bottom - 0.01))
            bezierPath.addCurve(to: CGPoint(x: borderWidth + 11.04, y: bottom - 4.04), controlPoint1: CGPoint(x: borderWidth + 4.07, y: bottom + 0.43), controlPoint2: CGPoint(x: borderWidth + 8.16, y: bottom - 1.06))
            bezierPath.addCurve(to: CGPoint(x: borderWidth + 22, y: bottom), controlPoint1: CGPoint(x: borderWidth + 16, y: bottom), controlPoint2: CGPoint(x: borderWidth + 19, y: bottom))
        }
        bezierPath.close()
        
        backgroundColor?.setFill()
        borderColor.setStroke() // 6
        bezierPath.fill()
        bezierPath.stroke()
    }
    enum ArrowDirection: String { // 1
        case left = "left"
        case right = "right"
    }
    
    var arrowDirection: ArrowDirection = .right { // 2
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var arrowDirectionIB: String { // 3
        get {
            return arrowDirection.rawValue
        }
        set {
            if let direction = ArrowDirection(rawValue: newValue) {
                arrowDirection = direction
            }
        }
    }
    
    
}
