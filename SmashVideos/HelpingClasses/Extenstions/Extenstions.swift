//
//  Extenstions.swift
//  D-Track
//
//  Created by Zubair Ahmed on 25/01/2022.
//


import Foundation
import UIKit
extension String {
    func getCharAtIndex(_ index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}



// Notification name for Objective-C
@objc public extension NSNotification {
    public static var SaveAudioPath: String {
        return "SaveAudioPath"
    }
}




extension Notification.Name {
    static let getCouponCode = Notification.Name("getCouponCode")
    static let createVideo = Notification.Name("createVideo")
    static let requestVerifyNotify = Notification.Name("requestVerifyNotify")
    static let requestChatImg = Notification.Name("requestChatImg")
    static let requestUpdateUserInfo = Notification.Name("requestUpdateUserInfo")
    static let updateInboxNotification = Notification.Name("updateInboxNotification")
    static let requestUpdateCompleteDetails = Notification.Name("requestUpdateCompleteDetails")
    static let updateUserProfileImg = Notification.Name("updateUserProfileImg")
    static let stopSoundPlayNotify = Notification.Name("stopSoundPlayNotify")
    static let getAudioPath = Notification.Name("getAudioPath")
    static let refreshHome = Notification.Name("refreshHome")
    static let stopTimer = Notification.Name("stopTimer")
    static let updateWallet = Notification.Name("updateWallet")
    static let RequestAccepted = Notification.Name("RequestAccepted")
    static let SaveAudioPath = Notification.Name("SaveAudioPath")
    static let getSaveVideoDraftNoti = Notification.Name("getSaveVideoDraftNoti")
    static let EditSaveAudioPath = Notification.Name("EditSaveAudioPath")
    static let OpenDraftController = Notification.Name("OpenDraftController")
}
extension UIViewController {
    func Alert(title:String,msg:String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
    
    func showToast2(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height*0.12, width: 350, height: 40))
        //    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.backgroundColor = #colorLiteral(red: 0, green: 0.6235294118, blue: 0.8156862745, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 2;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
        //    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
        //        var height = 100;
        ////        toastLabel.frame = new CGRect(View.Frame.Left, view.Frame.Y - height , view.Superview.Frame.Right, height);
        //        toastLabel.frame = CGRect(x: toastLabel.frame.origin.x, y: self.view.frame.size.height-440, width: toastLabel.frame.width, height: toastLabel.frame.height)
        //
        //    }) { (comp) in
        //        sleep(2)
        //        toastLabel.removeFromSuperview()
        //    }
    }

    
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height*0.12, width: 350, height: 40))
        //    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.backgroundColor = #colorLiteral(red: 0.3129099309, green: 0.3177284598, blue: 0.3219906092, alpha: 0.8590539384)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 2;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
        //    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
        //        var height = 100;
        ////        toastLabel.frame = new CGRect(View.Frame.Left, view.Frame.Y - height , view.Superview.Frame.Right, height);
        //        toastLabel.frame = CGRect(x: toastLabel.frame.origin.x, y: self.view.frame.size.height-440, width: toastLabel.frame.width, height: toastLabel.frame.height)
        //
        //    }) { (comp) in
        //        sleep(2)
        //        toastLabel.removeFromSuperview()
        //    }
    }

    func showToast1(message: String, font: UIFont) {
        let toastLabel = UILabel()
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = #colorLiteral(red: 0.3129099309, green: 0.3177284598, blue: 0.3219906092, alpha: 0.8590539384)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 2
        toastLabel.clipsToBounds = true
        
        let maxSize = CGSize(width: self.view.frame.size.width - 40, height: CGFloat.greatestFiniteMagnitude)
        let expectedSize = toastLabel.sizeThatFits(maxSize)
        

        toastLabel.frame = CGRect(x: 15, y: self.view.frame.size.height*0.12, width: self.view.frame.size.width - 30, height: expectedSize.height)
        toastLabel.autoresizingMask = [.flexibleWidth]
        
        self.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
//     func generateAnimatedViews() {
//        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "heartAniIcon") : #imageLiteral(resourceName: "heartAniIcon")
//        let imageView = UIImageView(image: image)
//        let dimension = 20 + drand48() * 10
//        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
//
//        let animation = CAKeyframeAnimation(keyPath: "position")
//
//        animation.path = AppUtility?.customPath().cgPath
//        animation.duration = 2 + drand48() * 3
//        animation.fillMode = CAMediaTimingFillMode.forwards
//        animation.isRemovedOnCompletion = true
//        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//
//        imageView.layer.add(animation, forKey: nil)
//        view.addSubview(imageView)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
//            imageView.removeFromSuperview()
//        }
//    }
//
}


extension Int {
    init(_ range: Range<Int> ) {
        let delta = range.lowerBound < 0 ? abs(range.lowerBound) : 0
        let min = UInt32(range.lowerBound + delta)
        let max = UInt32(range.upperBound   + delta)
        self.init(Int(min + arc4random_uniform(max - min)) - delta)
    }
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}
extension UILabel {
    func textDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    static func createCustomLabel() -> UILabel {
        let label = UILabel()
        label.textDropShadow()
        return label
    }
}




extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension String {
    
    func toDate(withFormat format: String = "EEEE HH:mm aa")-> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone //TimeZone(identifier: "UTC")
        dateFormatter.locale = Calendar.current.locale //Locale(identifier: "fa-IR")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
}

extension Date {
    
    func toString(withFormat format: String = "EEEE HH:mm aa") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale// Locale(identifier: "fa-IR")
        dateFormatter.timeZone = Calendar.current.timeZone// TimeZone(identifier: "UTC")
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        
        return str
    }
}
extension UIImage{
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
        ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func resizedImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    //MARK:- convenience function in UIImage extension to resize a given image
    func convert(toSize size:CGSize, scale:CGFloat) ->UIImage {
        let imgRect = CGRect(origin: CGPoint(x:0.0, y:0.0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: imgRect)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return copied!
        }
}
enum AssetsColor: String {
    case app_color
    case maincolor
    case black
    case bgColor
    case borderColor
    case btnColor
    case SubTitleColor
    case TitleColor
    case btnGreen
    case green
    case red
    case boxColor
    case lightGrey
    case white
    case transparent
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}

public extension UIDevice {
    var hasNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
#endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}



extension UIImage {
    
    func circularImage(size: CGSize?) -> UIImage {
        let newSize = size ?? self.size
        
        let minEdge = min(newSize.height, newSize.width)
        let size = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        
        self.draw(in: CGRect(origin: CGPoint.zero, size: size), blendMode: .copy, alpha: 1.0)
        
        context!.setBlendMode(.copy)
        context!.setFillColor(UIColor.clear.cgColor)
        
        let rectPath = UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size))
        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        rectPath.append(circlePath)
        rectPath.usesEvenOddFillRule = true
        rectPath.fill()
    
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
}

