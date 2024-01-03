//
//  CustomSlide.swift
//  WOOW
//
//  Created by Mac on 25/08/2022.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 3
    
    @IBInspectable var thumbRadius: CGFloat = 20
    
    @IBInspectable var borderColor: UIColor? {
            set {
                layer.borderColor = newValue?.cgColor
            }
            get {
                guard let color = layer.borderColor else {
                    return nil
                }
                return UIColor(cgColor: color)
            }
        }
    
    // Custom thumb view which will be converted to UIImage
    // and set as thumb. You can customize it's colors, border, etc.
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = borderColor//thumbTintColor
       // thumb.layer.borderWidth = 0.4
        //thumb.layer.borderColor = borderColor as! CGColor
        return thumb
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
        setThumbImage(thumb, for: .highlighted)
    }
    
    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb
        
        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2
        
        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585
        
        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }
    
}

//@IBDesignable class BigSwitch: UISwitch {
//
//    @IBInspectable var scale : CGFloat = 1{
//        didSet{
//            setup()
//        }
//    }
//
//    //from storyboard
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    //from code
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    private func setup(){
//        self.transform = CGAffineTransform(scaleX: scale, y: scale)
//    }
//
//    override func prepareForInterfaceBuilder() {
//        setup()
//        super.prepareForInterfaceBuilder()
//    }
//
//
//}
