//
//  Utility.swift

//
//  Created by macbook on 20/11/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
import FullMaterialLoader
import CoreLocation
import PhoneNumberKit
//import FBSDKCoreKit
//import FBSDKLoginKit
//import Foundation
//import  LanguageManager_iOS
import NVActivityIndicatorView
import Foundation
import Photos

protocol DatePickerDelegate {
    func timePicked(time: String)
}



//import Reachability

let AppUtility =  Utility.sharedUtility()
let phoneNumberKit = PhoneNumberKit()
let ud = UserDefaults.standard
var indicatorHud = MaterialLoadingIndicator(frame: CGRect(x:0, y:0, width: 50, height: 50))
var hudContainer = UIView(frame: CGRect(x:0, y:0, width: 50, height: 50))


struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

//MARK:- Server URL Definition
let imageDownloadUrl  = ""

//MARK:- Loading Colour
let strloadingColour = "FFCC02"

//MARK:- User Defaults Keys
let strToken = "strToken"
let strAPNSToken = "strAPNSToken"
let strDate = "strDate"
let strURL = "strURL"
let strPicURL = ""
let InternetConnected = "InternetConnected"
var isVerifiedPhone = "0"

var isUpated = false
var sstrCode = ""
var sstrflag = ""
var sstrPhoneNumber = ""

let delegate:AppDelegate = UIApplication.shared.delegate as!  AppDelegate

var loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: nil, color: nil, padding: nil)


//MARK:- Utility Initialization Methods
class Utility: NSObject {
    
    let vc = UIApplication.shared.keyWindow?.rootViewController?.view
    let backgroundView = UIView()
    
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertController.view.tintColor = #colorLiteral(red: 0.7568627451, green: 0.2784313725, blue: 0.2745098039, alpha: 1)
        guard let viewController = UIApplication.shared.keyWindow?.rootViewController else
        {
            fatalError("keyWindow has no rootViewController")
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //    Mark:- check whether image is gif or not
    func isAnimatedImage(_ imageUrl: URL) -> Bool {
        if let data = try? Data(contentsOf: imageUrl),
           let source = CGImageSourceCreateWithData(data as CFData, nil) {
            
            let count = CGImageSourceGetCount(source)
            return count > 1
        }
        return false
    }
    
    // Mark:-   Convert concatinate url with BASEURL
    func detectURL(ipString:String)-> String{
        let input = ipString
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
        
        if matches.isEmpty{
            return BASE_URL+ipString
        }else{
            
            var urlString = ""
            for match in matches {
                guard let range = Range(match.range, in: input) else { continue }
                let url = input[range]
                print(url)
                
                urlString = String(url)
            }
            
            return urlString
        }
        
    }
    
    func customPath() -> UIBezierPath {
        let path = UIBezierPath()
        let w = UIScreen.main.bounds.size.width/2
        let y = UIScreen.main.bounds.size.height
        path.move(to: CGPoint(x: w+50, y: y-100))
        
        let endPoint = CGPoint(x: w, y: y/2 )
        
        let randomYShift = 5 + drand48() * 200
        let cp1 = CGPoint(x: 222 - randomYShift, y: 500 )
        let cp2 = CGPoint(x: 200 + randomYShift, y: 500 )
        
        path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        return path
    //    path.move(to: CGPoint(x: 0, y: 200))
    //
    //    let endPoint = CGPoint(x: 400, y: 200)
    //
    //    let randomYShift = 200 + drand48() * 300
    //    let cp1 = CGPoint(x: 100, y: 100 - randomYShift)
    //    let cp2 = CGPoint(x: 200, y: 300 + randomYShift)
    //
    //    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    //    return path
    }
    //    MARK:- add device data
    func addDeviceData(){
        
        let uid = UserDefaultsManager.shared.user_id
        
//        guard uid != nil && uid != "" else{return}
        
        let fcm = UserDefaultsManager.shared.device_token// UserDefaults.standard.string(forKey: "DeviceToken")
        let ip = getIPAddress()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let deviceType = "iOS"
        
        
        ApiHandler.sharedInstance.addDeviceData(user_id: uid, device: deviceType, version: appVersion!, ip: ip, device_token: fcm) { (isSuccess, response) in
            if isSuccess{
                print("Data of Device Added: ",response)
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("Data of Device Added: ",response?.value(forKey: "msg") as Any)
                    
                    let msg = response!.value(forKey: "msg") as! NSDictionary
                    if let userObj = msg.value(forKey: "User") as? NSDictionary {
                        let country_id = (userObj.value(forKey: "country_id") as? String)!
                       // UserDefaultsManager.shared.country_id = country_id
                        let userImage = (userObj.value(forKey: "profile_pic") as? String)!
                        let userName = (userObj.value(forKey: "username") as? String)!
                        let followers = "\(userObj.value(forKey: "followers_count") ?? "")"
                        let followings = "\(userObj.value(forKey: "following_count") ?? "")"
                        let likesCount = "\(userObj.value(forKey: "likes_count") ?? "")"
                        let videoCount = "\(userObj.value(forKey: "video_count") ?? "")"
                        let firstName = (userObj.value(forKey: "first_name") as? String)!
                        let lastName = (userObj.value(forKey: "last_name") as? String)!
                        let gender = (userObj.value(forKey: "gender") as? String)!
                        let bio = (userObj.value(forKey: "bio") as? String)!
                        let dob = (userObj.value(forKey: "dob") as? String)!
                        let email = (userObj.value(forKey: "email") as? String)!
                        let website = (userObj.value(forKey: "website") as? String)!
                        let followBtn = (userObj.value(forKey: "button") as? String)
                        let wallet = (userObj.value(forKey: "wallet") as? String)
    //                    let paypal = (userObj.value(forKey: "paypal") as? String)
                        let verified = (userObj.value(forKey: "verified") as? String)

                        UserDefaults.standard.setValue(wallet, forKey: "wallet")

                        let userId = (userObj.value(forKey: "id") as? String)!
                    }
                    
//                    self.username = "\(userName)"
//                    self.fullname = "\(firstName)" + "\(lastName)"
//                    let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: email, userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: followBtn ?? "", wallet: wallet ?? "",paypal:"" , verified: verified ?? "0")
                    
                }else{
                    print("!200: ",response?.value(forKey: "msg") as Any)
                }
                
            }else{
                print("faild!!!!")
            }
        }
    }
    
    //MARK: Get user level
    func getUserLevel(CounyValue : String) -> (Int,String) {
        let count = Int("\(CounyValue)")
        ?? 1
        
        if count<3000 {
            return (1,"ic_star1")
        }
        else if(count<=10000){
            return (2,"ic_star2")
        }

        else if(count<=100000){
            return (3,"ic_star3")
        }

        else if(count<=1000000){
            return (4,"ic_star4")
        }

        else if(count<=3000000){
            return (5,"ic_star5")
        }

        else if(count<=35000000){
            return (6,"ic_star6")
        }

        else {
            return (6,"ic_star6")
        }
    }
 
//    func showToast(string:String,view:UIView) {
//        view.makeToast(string, duration: 1.0, position: .bottom)
//    }
//    

    func btnHoverAnimation(viewName:UIView)
    {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        viewName.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                        viewName.layer.cornerRadius = 6
                       },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            viewName.transform = CGAffineTransform.identity
                        }
                       })
        
    }
    
    
    func startLoader(view: UIView){


        
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6)
        backgroundView.tag = 475647
        
        loader = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), type: .circleStrokeSpin, color: .white, padding: view.frame.width * 0.46)
        
        print("view.frame.width: ",view.frame.width * 0.46)
        
        loader.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6)
        
        
//        view.addSubview(loader)

    
        backgroundView.addSubview(loader)
        loader.startAnimating()
        DispatchQueue.main.async { [self] in
            UIApplication.shared.keyWindow!.addSubview(backgroundView)
            UIApplication.shared.keyWindow!.bringSubviewToFront(backgroundView)
            vc?.bringSubviewToFront(backgroundView)
        }

        loader.isUserInteractionEnabled = false
        vc!.isUserInteractionEnabled = false
        backgroundView.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        UIApplication.shared.keyWindow?.rootViewController?.tabBarController?.tabBar.isUserInteractionEnabled = false
    }
    func stopLoader(view: UIView){
        
//        DispatchQueue.main.async { // Correct
//            loader.removeFromSuperview()
//        }
        loader.stopAnimating()
        DispatchQueue.main.async {
            if self.backgroundView.viewWithTag(475647) != nil{
            self.backgroundView.removeFromSuperview()
            }
        }
        
        vc?.isUserInteractionEnabled = true
        backgroundView.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        loader.isUserInteractionEnabled = true
        UIApplication.shared.keyWindow?.rootViewController?.tabBarController?.tabBar.isUserInteractionEnabled = true
    }
    
    // MARK:- Dismiss and Pop ViewControllers
    func dismissPopAllViewViewControllers() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController?.dismiss(animated: true, completion: nil)
            (appDelegate.window?.rootViewController as? UINavigationController)?.popToRootViewController(animated: true)
        }
    }
    
    //var fbLogin:FBSDKLoginManager!
    var datePickerDelegate : DatePickerDelegate?
    class func sharedUtility()->Utility!
    {
        struct Static
        {
            static var sharedInstance:Utility?=nil;
            static var onceToken = 0
        }
        Static.sharedInstance = self.init();
        return Static.sharedInstance!
    }
    required override init() {
        
    }
    
    internal func createActivityIndicator(_ uiView : UIView)->UIView{

        let container: UIView = UIView(frame: CGRect.zero)
        container.layer.frame.size = uiView.frame.size
        container.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height/2)
        container.backgroundColor = #colorLiteral(red: 0.9217679501, green: 0.9217679501, blue: 0.9217679501, alpha: 0.4444028253) //UIColor(white: 0.2, alpha: 0.3)

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = container.center
        loadingView.backgroundColor = UIColor.clear  // UIColor(white:0.1, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        loadingView.layer.shadowRadius = 5
        loadingView.layer.shadowOffset = CGSize(width: 0, height: 4)
        loadingView.layer.opacity = 2
        loadingView.layer.masksToBounds = false
        // loadingView.layer.shadowColor = .clear

        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.clipsToBounds = true
        actInd.color = UIColor(named: "theme")!
        actInd.style = .whiteLarge

        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        container.isHidden = true
        uiView.addSubview(container)
        actInd.startAnimating()

        return container

    }
    
    
    
    //MARK:- Get Date Method
    func getDateFromUnixTime(_ unixTime:String) -> String {
        let date = Date(timeIntervalSince1970: Double(unixTime)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let currentTime =  formatter.string(from: date as Date)
        return currentTime;
    }
    
    func getAgeYears(birthday:String)-> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd,MMMM yyyy" //"dd-MM-yyyy"
        let birthdate = formatter.date(from: birthday)
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthdate!, to: now)
        let age = ageComponents.year!
        return age
    }
    
    func calculateAge(dob: String, format: String = "YYYY-dd-MM") -> String{
        let df = DateFormatter()
        df.dateFormat = format
        let date = df.date(from: dob)
        guard let val = date else{
            return ""
        }
        var years = 0
        var months = 0
        var days = 0
        
        let cal = Calendar.current
        years = cal.component(.year, from: Date()) - cal.component(.year, from: val)
        
        let currentMonth = cal.component(.month, from: Date())
        let birthMonth = cal.component(.month, from: val)
        
        months = currentMonth - birthMonth
        
        if months < 0 {
            years = years - 1
            months = 12 - birthMonth
            if cal.component(.day, from: Date()) < cal.component(.day, from: val){
                months = months - 1
            }
        }else if months == 0 && cal.component(.day, from: Date()) < cal.component(.day, from: val){
            years = years - 1
            months = 11
        }
        if cal.component(.day, from: Date()) > cal.component(.day, from: val){
            days = cal.component(.day, from: Date()) - cal.component(.day, from: val)
        }else if cal.component(.day, from: Date()) < cal.component(.day, from: val){
            let today = cal.component(.day, from: Date())
            let date = cal.date(byAdding: .month, value: -1, to: Date())
            days = date!.daysInMonth - cal.component(.day, from: val) + today
        }else{
            days = 0
            if months == 12 {
                years = years + 1
                months = 0
            }
        }
        print("Years: \(years), Months: \(months), Days: \(days)")
        if years > 0{
            if years == 1{
                return "\(years)"
            }else{
                return "\(years)"
            }
        }else if months > 4{
            return "\(months)"
        }else {
            if  months >= 1{
                let daysleftInMonth = months * 30
                print(daysleftInMonth)
                days += daysleftInMonth
            }
            
            let weeks = days / 7
            return "\(weeks)"
        }
    }
    func showDatePicker(fromVC : UIViewController){
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 250)
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        pickerView.datePickerMode = .date
        //pickerView.locale = NSLocale(localeIdentifier: "\(Formatter.getInstance.getAppTimeFormat().rawValue)") as Locale
        vc.view.addSubview(pickerView)
        
        let alertCont = UIAlertController(title: "Choose Date", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertCont.setValue(vc, forKey: "contentViewController")
        let setAction = UIAlertAction(title: "Select", style: .default) { (action) in
            if self.datePickerDelegate != nil{
                //let selectedTime = Formatter.getInstance.convertDateToTime(date: pickerView.date)
                //self.datePickerDelegate!.timePicked(time: selectedTime)
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                formatter.timeZone = TimeZone.current
                let selectedTime = formatter.string(from: pickerView.date)
                self.datePickerDelegate!.timePicked(time: selectedTime)
            }
        }
        alertCont.addAction(setAction)
        alertCont.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        fromVC.present(alertCont, animated: true)
    }
    // MARK:- Phone Number Validation Check
    func isValidPhoneNumber(strPhone:String) -> Bool{
        do {
            _ = try phoneNumberKit.parse(strPhone)
            return true
        }
        catch {
            print("Generic parser error")
            return false
        }
    }
    
    //MARK: Check Internet
    func connected() -> Bool
    {
//        let reachibility = Reachability.forInternetConnection()
//        let networkStatus = reachibility?.currentReachabilityStatus()
//
        return true //networkStatus != NotReachable
        
    }
    
    //    MARK:- validate username
    func validateUsername(str: String) -> Bool
    {
        let RegEx = "\\w{4,14}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: str)
    }
    
    //MARK:- Validation Text
    func hasValidText(_ text:String?) -> Bool
    {
        if let data = text
        {
            let str = data.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if str.count>0
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
        
    }
    
    //MARK:- Validation Atleast 1 special schracter or number
    
    func checkTextHaveChracterOrNumber( text : String) -> Bool{
        
        
        //        let text = text
        //        let capitalLetterRegEx  = ".*[A-Z]+.*"
        //        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        //        let capitalresult = texttest.evaluate(with: text)
        //        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: text)
        print("\(numberresult)")
        
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        let specialresult = texttest2.evaluate(with: text)
        print("\(specialresult)")
        
        //return capitalresult || numberresult || specialresult
        return numberresult || specialresult
        
    }
    
    //MARK:- Validation Email
    func isEmail(_ email:String  ) -> Bool
    {
        let strEmailMatchstring = "\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", strEmailMatchstring)
        if(!isEmpty(email as String?) && regExPredicate.evaluate(with: email))
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    
    //MARK:- Validation Empty
    func isEmpty(_ thing : String? )->Bool {
        
        if (thing?.count == 0) {
            return true
        }
        return false;
    }
    
    //MARK:- CNIC Validation
    func isValidIdentityNumber(_ value: String) -> Bool {
        guard
            value.count == 11,
            let digits = value.map({ Int(String($0)) }) as? [Int],
            digits[0] != 0
        else { return false }
        
        let check1 = (
            (digits[0] + digits[2] + digits[4] + digits[6] + digits[8]) * 7
                - (digits[1] + digits[3] + digits[5] + digits[7])
        ) % 10
        
        guard check1 == digits[9] else { return false }
        
        let check2 = (digits[0...8].reduce(0, +) + check1) % 10
        
        return check2 == digits[10]
    }
    //MARK:- Show Alert
    func displayAlert(title titleTxt:String, messageText msg:String, delegate controller:UIViewController) ->()
    {
        let alertController = UIAlertController(title: titleTxt, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = UIColor(named:strloadingColour )
        
    }
    
    /*//MARK:- Customize Textfield for mulitple language
     func CustomizetextField(tf:CustomTextField,Padding:CGFloat){
     if LanguageManager.shared.currentLanguage == .ar {
     tf.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
     tf.textAlignment = .right
     tf.paddingRight = Padding
     tf.paddingLeft = 0
     }else{
     tf.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
     tf.textAlignment = .left
     tf.paddingLeft = Padding
     tf.paddingRight = 0
     }
     }
     //MARK:- Customize Button for mulitple language
     func CustomizeButton(btn:CustomButton){
     if LanguageManager.shared.currentLanguage == .ar {
     btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
     }else{
     btn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
     }
     }
     
     //MARK:- Customize label for mulitple language
     func CustomizeLabel(lbl:UILabel){
     if LanguageManager.shared.currentLanguage == .ar {
     lbl.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft
     lbl.textAlignment = .right
     
     }else{
     lbl.semanticContentAttribute = UISemanticContentAttribute.forceLeftToRight
     lbl.textAlignment = .left
     }
     }*/
    
    //MARK:- Color with HEXA
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    //MARK:- Get & Set Methods For UserDefaults
    
    func saveObject(obj:String,forKey strKey:String){
        ud.set(obj, forKey: strKey)
    }
    
    func getObject(forKey strKey:String) -> String {
        if let obj = ud.value(forKey: strKey) as? String{
            let obj2 = ud.value(forKey: strKey) as! String
            return obj2
        }else{
            return ""
        }
    }
    
    func deleteObject(forKey strKey:String) {
        ud.set(nil, forKey: strKey)
    }
    
    //MARK:- FullMaterialLoader Hud Methods
    
    func showHud(viewHud:UIView, hudColor:String){
        hudContainer.frame = viewHud.frame
        hudContainer.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        hudContainer.isUserInteractionEnabled = false
        indicatorHud.indicatorColor = [self.hexStringToUIColor(hex: hudColor).cgColor]
        indicatorHud.center = viewHud.center
        //viewHud.isUserInteractionEnabled = false
        hudContainer.addSubview(indicatorHud)
        viewHud.addSubview(hudContainer)
        indicatorHud.startAnimating()
    }
    
    func hideHud(viewHud:UIView){
        indicatorHud.stopAnimating()
        hudContainer.removeFromSuperview()
        //viewHud.isUserInteractionEnabled = true
    }
    
    //MARK: Add Delay
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    //MARK: Calculate Time
    
    func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    func calculateTimeDifference(start: String) -> String {
        let formatter = DateFormatter()
        //        2018-12-17 18:01:34
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var startString = "\(start)"
        if startString.count < 4 {
            for _ in 0..<(4 - startString.count) {
                startString = "0" + startString
            }
        }
        let currentDateTime = Date()
        let strcurrentDateTime = formatter.string(from: currentDateTime)
        var endString = "\(strcurrentDateTime)"
        if endString.count < 4 {
            for _ in 0..<(4 - endString.count) {
                endString = "0" + endString
            }
        }
        let startDate = formatter.date(from: startString)!
        let endDate = formatter.date(from: endString)!
        let difference = endDate.timeIntervalSince(startDate)
        if (difference / 3600) > 24{
            let differenceInDays = Int(difference/(60 * 60 * 24 ))
            return "\(differenceInDays) DAY AGO"
        }else{
            return "\(Int(difference) / 3600)HOURS \(Int(difference) % 3600 / 60)MIN AGO"
        }
    }
    
    func offsetFrom(dateFrom : Date,dateTo:Date) -> String {
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: dateFrom, to: dateTo);
        
        let seconds = "\(difference.second ?? 0)s"
        let minutes = "\(difference.minute ?? 0)m" + ":" + seconds
        let hours = "\(difference.hour ?? 0)h" + ":" + minutes
        let days = "\(difference.day ?? 0)d" + ":" + hours
        
        if let day = difference.day, day          > 0 { return days }
        if let hour = difference.hour, hour       > 0 { return hours }
        if let minute = difference.minute, minute > 0 { return minutes }
        if let second = difference.second, second > 0 { return seconds }
        return ""
    }
    
    //MARK: Random Number
    func getCurrentMillis()->Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    //MARK: Send Notification
    /*func sendPushNotification(body: [String : Any]) {
     print("push body",body)
     //let paramString  = ["to" : token, "notification" : ["title" : "Group Tag", "body" : "You recieved cake"]/*, "data" : ["user" : self.myUser![0].email]*/] as [String : Any]
     
     let urlString = "https://fcm.googleapis.com/fcm/send"
     let url = NSURL(string: urlString)!
     let request = NSMutableURLRequest(url: url as URL)
     request.httpMethod = "POST"
     let json = try! JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted])
     let outString = String(data:json, encoding:.utf8)
     
     print("outstring",outString!)
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     request.setValue("key=AIzaSyBhZyP653nt4vu3insFqTK7I0c5RAk4voM", forHTTPHeaderField: "Authorization")
     //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     request.httpBody = json
     
     let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
     do {
     print("task",response!)
     if let jsonData = data {
     let outString = String(data:jsonData, encoding:.utf8)
     print("out",outString!)
     if let jsonDataDict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: AnyObject] {
     NSLog("Received data:\n\(jsonDataDict))")
     }
     }
     } catch let err as NSError {
     print(err.debugDescription)
     }
     }
     task.resume()
     }*/
    
    //MARK: Location
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        if !self.connected(){
            return
        }
        //var addressString : String = ""
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            print(pm.country)
                                            print(pm.locality)
                                            print(pm.subLocality)
                                            print(pm.thoroughfare)
                                            print(pm.postalCode)
                                            print(pm.subThoroughfare)
                                            if pm.locality != nil {
                                                //addressString = addressString + pm.subLocality! + ", "
                                                //User have option to chnage his city
                                                //strCurrentCityName = pm.locality!
                                            }
                                            if pm.country != nil {
                                                //  strCurrentCountryName = pm.country!
                                            }
                                            NotificationCenter.default.post(name: Notification.Name("LocationGeoCoding"), object: nil)
                                            /*if pm.thoroughfare != nil {
                                             addressString = addressString + pm.thoroughfare! + ", "
                                             }
                                             if pm.locality != nil {
                                             addressString = addressString + pm.locality! + ", "
                                             }
                                             if pm.country != nil {
                                             addressString = addressString + pm.country! + ", "
                                             }
                                             if pm.postalCode != nil {
                                             addressString = addressString + pm.postalCode! + " "
                                             }*/
                                            //print(addressString)
                                        }
                                    })
    }
    
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }

}
extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

extension String {
    func shorten() -> String{
        let number = Double(self)
        let thousand = number! / 1000
        let million = number! / 1000000
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

func currentDate()-> Date{
    
    var today = Date()
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "EN")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timeStamp =  formatter.string(from: today)
   
    let dateFormatterNow = DateFormatter()
    dateFormatterNow.locale = Locale(identifier: "EN")

    dateFormatterNow.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let localCreateDate = dateFormatterNow.date(from: timeStamp)! as Date
    
    
    return localCreateDate
    
}

//extension UIView{
//
//    func activityStartAnimating() {
//        let backgroundView = UIView()
//        backgroundView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        backgroundView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 0.6)
//        backgroundView.tag = 475647
//
//        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
//        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 70))
//        activityIndicator.center = self.center
//        activityIndicator.hidesWhenStopped = true
//        activityIndicator.style = UIActivityIndicatorView.Style.gray
//        activityIndicator.color = .white
//        activityIndicator.startAnimating()
//        self.isUserInteractionEnabled = false
//
//        backgroundView.addSubview(activityIndicator)
//
//        self.addSubview(backgroundView)
//    }
//
//    func activityStopAnimating() {
//        if let background = viewWithTag(475647){
//            background.removeFromSuperview()
//        }
//        self.isUserInteractionEnabled = true
//    }
//}


extension String
{
    func hashtags() -> [String]
    {
        if let regex = try? NSRegularExpression(pattern: "#[a-z0-9]+", options: .caseInsensitive)
        {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "#", with: "").lowercased()
            }
        }

        return []
    }

    func mentions() -> [String]
    {
        if let regex = try? NSRegularExpression(pattern: "@[a-z0-9]+", options: .caseInsensitive)
        {
            let string = self as NSString

            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "@", with: "").lowercased()
            }
        }

        return []
    }

}
extension Date{
    var daysInMonth:Int{
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
}

//extension UIViewController {
//
//    func showToast(message : String, font: UIFont) {
//
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 175, y: self.view.frame.size.height*0.12, width: 350, height: 40))
//        //    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.backgroundColor = UIColor.darkGray
//        toastLabel.textColor = UIColor.white
//        toastLabel.font = font
//        toastLabel.textAlignment = .center;
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 5;
//        toastLabel.clipsToBounds  =  true
//        self.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
//            toastLabel.alpha = 0.0
//        }, completion: {(isCompleted) in
//            toastLabel.removeFromSuperview()
//        })
//
//        //    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
//        //        var height = 100;
//        ////        toastLabel.frame = new CGRect(View.Frame.Left, view.Frame.Y - height , view.Superview.Frame.Right, height);
//        //        toastLabel.frame = CGRect(x: toastLabel.frame.origin.x, y: self.view.frame.size.height-440, width: toastLabel.frame.width, height: toastLabel.frame.height)
//        //
//        //    }) { (comp) in
//        //        sleep(2)
//        //        toastLabel.removeFromSuperview()
//        //    }
//    }
//
//}
//
