//
//  PhoneOtpLoginViewController.swift
//  WOOW
//
//  Created by Wasiq Tayyab on 02/06/2022.
//

import UIKit
import DPOTPView
import PhoneNumberKit
class PhoneOtpLoginViewController: UIViewController {
    
    //MARK:- VARS
    
    var count = 60
    var number = ""
    var phoneNumber = ""
    var code = "+92"
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
  
    //MARK:- OUTLET
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var lblResendCode: UILabel!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var otpView: DPOTPView!
    
    @IBOutlet weak var btnResendCode: UIButton!
    
    @IBOutlet weak var stackConst: NSLayoutConstraint!
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        otpView.dpOTPViewDelegate = self
        self.setup()
    }

    //MARK:- FUNCTION
    
    func setup(){
        btnResendCode.isHidden = true
        lblPhoneNumber.text = "Your code was sent to \(phoneNumber)"
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    
    func verifyOTPfunc(code : String){
        let phoneNoNew = phoneNumber.trimmingCharacters(in: .whitespaces)
        
        ApiHandler.sharedInstance.verifyOTP(phone: phoneNoNew, verify: "1", code: code) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                
                    self.registerPhoneCeck()
                    
                }else{
                    let msgObj = response?.value(forKey: "msg") as? String
                    let alert = UIAlertController(title: "Alert", message: msgObj, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                
                }
            }else{
               
                let alert = UIAlertController(title: "Alert", message: response?.value(forKey: "msg") as! String, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func registerPhoneCeck(){

        let phoneNoNew = phoneNumber.trimmingCharacters(in: .whitespaces)
        self.loader.isHidden = false
                ApiHandler.sharedInstance.registerPhoneCheck(phone: phoneNoNew) { (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    

                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    print("user obj: ",userObj)
                    UserObject.shared.Objresponse(response: userObjMsg as! [String : Any],isLogin: true)
                    //if user already registered code it
                    let user = User()
                    user.id = userObj.value(forKey: "id") as? String
                    user.active = userObj.value(forKey: "active") as? String
                    user.city = userObj.value(forKey: "city") as? String
              
                    UserDefaultsManager.shared.user_id = user.id
                    UserDefaultsManager.shared.auth_token = userObj.value(forKey: "auth_token") as? String ?? ""

                    user.country = userObj.value(forKey: "country") as? String
                    user.created = userObj.value(forKey: "created") as? String
                    user.device = userObj.value(forKey: "device") as? String
                    user.dob = userObj.value(forKey: "dob") as? String

                    user.email = userObj.value(forKey: "email") as? String
                    user.fb_id = userObj.value(forKey: "fb_id") as? String

                    user.first_name = userObj.value(forKey: "first_name") as? String
                    user.gender = userObj.value(forKey: "gender") as? String
                    user.last_name = userObj.value(forKey: "last_name") as? String
                    user.ip = userObj.value(forKey: "ip") as? String
                    user.lat = userObj.value(forKey: "lat") as? String
                    user.long = userObj.value(forKey: "long") as? String
                    user.online = userObj.value(forKey: "online") as? String
                    user.password = userObj.value(forKey: "password") as? String
                    user.phone = userObj.value(forKey: "phone") as? String

                    user.profile_pic = userObj.value(forKey: "profile_pic") as? String
                    user.role = userObj.value(forKey: "role") as? String
                    user.social = userObj.value(forKey: "social") as? String
                    user.social_id = userObj.value(forKey: "social_id") as? String
                    user.username = userObj.value(forKey: "username") as? String
                    user.verified = userObj.value(forKey: "verified") as? String
                    user.version = userObj.value(forKey: "version") as? String
                    user.website = userObj.value(forKey: "website") as? String

                    user.comments = userObj.value(forKey: "comments") as? String
                    user.direct_messages = userObj.value(forKey: "direct_messages") as? String

                    user.likes = userObj.value(forKey: "likes") as? String
                    user.mentions = userObj.value(forKey: "mentions") as? String
                    user.new_followers = userObj.value(forKey: "new_followers") as? String
                    user.video_updates = userObj.value(forKey: "video_updates") as? String
                    user.direct_message = userObj.value(forKey: "direct_message") as? String

                    user.duet = userObj.value(forKey: "duet") as? String
                    user.liked_videos = userObj.value(forKey: "liked_videos") as? String
                    user.video_comment = userObj.value(forKey: "video_comment") as? String
                    user.videos_download = userObj.value(forKey: "videos_download") as? String

                    if User.saveUserToArchive(user: [user]){
                        self.tabBarController?.selectedIndex = 0
                        self.navigationController?.popViewController(animated: true)
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                    self.otpView.text?.removeAll()

                }else{
                    


                    let alert = UIAlertController(title: NSLocalizedString("MusicTok", comment: ""), message: "Want to create new account?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                    alert.addAction(UIAlertAction(title: "Signup", style: .default, handler: { action in
                          switch action.style{
                          case .default:
                                print("default")
                              
                              let myViewController = DobViewController(nibName: "DobViewController", bundle: nil)
                              myViewController.phoneNoNew = phoneNoNew
                              myViewController.social_type = "phone"
                              self.navigationController?.isNavigationBarHidden = true
                              self.navigationController?.pushViewController(myViewController, animated: true)
                          case .cancel:
                                print("cancel")

                          case .destructive:
                                print("destructive")

                    }}))

                    self.present(alert, animated: true, completion: nil)
                    //if user not registered


                }
            }else{
                
            }
        }
    }
    
    //MARK:- BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func update() {
        
        if(count > 10) {
            lblResendCode.text = "Resend code 00:\(count)"
            lblCall.text = "Call Me 00:\(count)"
            count -= 1
        }else if (count < 11 && count > 0) {
            
            lblResendCode.text = "Resend code 00:0\(count)"
            lblCall.text = "Call Me 00:0\(count)"
            count -= 1
            
        }else {
            lblResendCode.text = "Resend code 00:00"
            lblCall.text = "Call Me 00:00"
            
            btnResendCode.isHidden = false
            stackView.isHidden = true
            stackConst.constant = 0.0
            
        }
    }
    
    
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        count = 60
        stackConst.constant = 40.67
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        stackView.isHidden = false
        verifyPhoneFunc(countryCode: code, phoneNo: phoneNumber)
    }
    
    
    func verifyPhoneFunc(countryCode : String, phoneNo : String){
        self.loader.isHidden = false
    ApiHandler.sharedInstance.verifyPhoneNo(phone: phoneNo, verify: "0") { (isSuccess, response) in
        self.loader.isHidden = true

        self.btnResendCode.isHidden = true
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                   
                    print("respone: ",response?.value(forKey: "msg") as! String)
                    if #available(iOS 12.0, *) {
                        
        
                    } else {
                        // Fallback on earlier versions
                        print("iOS is not 12.0, *")
                    }
                    
                }else{
                   
                }
            }else{
                
            }
        }
    }
    
    
    
}


//MARK:- DPOTPViewDelegate

extension PhoneOtpLoginViewController: DPOTPViewDelegate {
    func dpOTPViewAddText(_ text: String, at position: Int) {
        if position <= 3 && text.count == 4{
           
            verifyOTPfunc(code: text)
           
        }else {
            
        }
    }
    
    func dpOTPViewRemoveText(_ text: String, at position: Int) {
        if position <= 3 && text.count == 4{
            
        }else {
            
        }
    }
    
    func dpOTPViewChangePositionAt(_ position: Int) {
    }
    
    func dpOTPViewBecomeFirstResponder() {
        
    }
    func dpOTPViewResignFirstResponder() {
        
        
    }
    
}


