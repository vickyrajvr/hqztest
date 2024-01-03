//
//  UsernameViewController.swift
//  SmashVideos
//
//  Created by Mac on 16/10/2022.
//

import UIKit

class UsernameViewController: UIViewController ,UITextFieldDelegate{
    
    //MARK:- VARS
    var social_type = ""
    var social_id = ""
    var authtoken = ""
    
    var email = ""
    var phoneNoNew = ""
    
    var dob = ""
    var password = ""
    
    var username = ""
    var gender = ""
    
    var first_name = ""
    var last_name = ""
    
   
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    //MARK:- OUTLET
    
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("social_type",social_type)
        print("social_id",social_id)
        print("email",email)
        print("first_name",first_name)
        print("last_name",last_name)
        usernameTxtField.delegate = self
        btnSignup.backgroundColor = UIColor(named: "lightGrey")
        btnSignup.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
        btnSignup.isUserInteractionEnabled = false

    }
    
    //MARK:- TEXTFIELD DELEGATE

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 24
        let currentString = (usernameTxtField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        print(usernameTxtField.text ?? "")
        print(newString)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        }
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        if newString.rangeOfCharacter(from: characterset.inverted) != nil {
            print("string contains special characters")
            self.lblUsername.isHidden = false
            self.lblUsername.text = "Only Letters, numbers, underscores or periods are allowed."
            
        }else {
            self.lblUsername.isHidden = true
            if textField == self.usernameTxtField {
                self.registerUsernameCheck(username: newString as String)
                
               
                
            }
            
            return newString.count <= maxLength
        }
        
        
        return true
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        lblCount.text = "\(Int(usernameTxtField.text!.count))/24"
    
    }

    
    @IBAction func btnSignup(_ sender: Any) {
        
        self.username = usernameTxtField.text!
        if username == "" {
            let alert = UIAlertController(title: "Alert", message: "Enter your valid username", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.registerPhone(phone: phoneNoNew, dob: dob, username: username, email: email, gender: gender, referral_code: "", first_name: first_name, last_name: last_name, auth_token:  authtoken, device_token: UserDefaultsManager.shared.device_token, ip: "", profile_pic: "", socail_type: social_type, social_id: social_id, password: password)
        
    }
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - API CALLING
    func registerUsernameCheck(username: String){
        
        ApiHandler.sharedInstance.registerUsernameCheck(username: username) { (isSuccess, response) in
            
            if isSuccess{
                let msg = response?["msg"] as? String ?? ""
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    if self.usernameTxtField.text?.count ?? 0 < 3 {
                        self.lblUsername.isHidden = false
                        self.lblUsername.text = "username is too short"
                        self.btnSignup.backgroundColor = UIColor(named: "lightGrey")
                        self.btnSignup.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
                        self.btnSignup.isUserInteractionEnabled = false
                    }else {
                        
                        self.lblUsername.isHidden = true
                        self.username = username
                        
                        self.btnSignup.backgroundColor = UIColor(named: "theme")
                        self.btnSignup.setTitleColor(.white, for: .normal)
                        self.btnSignup.isUserInteractionEnabled = true
                    }
                }else{
                    
                    let msg = response?["msg"] as? String ?? ""
                    if msg == "already exist" {
                        self.lblUsername.isHidden = false
                        self.lblUsername.text = "this username is not available try a new one"
                        self.btnSignup.backgroundColor = UIColor(named: "lightGrey")
                        self.btnSignup.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
                        self.btnSignup.isUserInteractionEnabled = false
                    }else {
                        self.lblUsername.isHidden = true
                    }
                    
                }
                
            }else {
                self.username = ""
            }
            
        }
        
    }
    
    func registerPhone(phone:String,dob:String,username:String,email:String,gender:String ,referral_code:String,first_name:String,last_name:String,auth_token:String,device_token:String,ip:String,profile_pic:Any,socail_type:String,social_id:String,password:String){
        self.loader.isHidden = false
        if social_type == "google" || social_type == "facebook" || social_type == "apple" {
            
            ApiHandler.sharedInstance.registerPhone(phone: phone, dob: dob, username: username, email: email, gender: gender, referral_code: referral_code, first_name: first_name, last_name: last_name, auth_token: auth_token, device_token: device_token, ip: ip, profile_pic: profile_pic,socail_type: socail_type, social_id: social_id, password: password) { (isSuccess, response) in
                self.loader.isHidden = true
                if isSuccess{
                   
                    if response?.value(forKey: "code") as! NSNumber == 200 {
                        AppUtility?.stopLoader(view: self.view)
                        
                     
                        if let msg = response?.value(forKey: "msg") as? String {
                            self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
                            return
                        }
                        
                        let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                        let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                        print("user obj: ",userObj)
                        UserObject.shared.Objresponse(response: userObjMsg as! [String : Any],isLogin: true)
                        //if user already registered code it
                        let user = User()
                        user.id = userObj.value(forKey: "id") as? String
                        user.active = userObj.value(forKey: "active") as? String
                        user.city = userObj.value(forKey: "city") as? String
                        
                        //                    UserDefaults.standard.set(userObj.value(forKey: "id") as? String, forKey: "userID")
                        //                    UserDefaults.standard.set(userObj.value(forKey: "auth_token") as? String, forKey: "authToken")
                        
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
                            print("sussessfully registerd")
                            //                        self.navigationController?.popToRootViewController(animated: true)
                            //                        NotificationCenter.default.post(name: Notification.Name("dismissVCnoti"), object: nil)
                            self.tabBarController?.selectedIndex = 0
                            self.navigationController?.popViewController(animated: true)
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }
                        //                    self.otpTextField.text?.removeAll()
                        
                    }else{
                        let msgObj = response?.value(forKey: "msg") as? String
                        let alert = UIAlertController(title: "Alert", message: msgObj, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else {
                    self.loader.isHidden = false
                }
                
            }
        }else {
            
            ApiHandler.sharedInstance.registerPhone(phone: phone, dob: dob, username: username, email: email, gender: gender, referral_code: referral_code, first_name: first_name, last_name: last_name, auth_token: auth_token, device_token: device_token, ip: ip, profile_pic: ["file_data":profile_pic],socail_type: socail_type, social_id: social_id, password: password) { (isSuccess, response) in
                self.loader.isHidden = true
                if isSuccess{
                   
                    if response?.value(forKey: "code") as! NSNumber == 200 {
                        AppUtility?.stopLoader(view: self.view)
                        
                     
                        if let msg = response?.value(forKey: "msg") as? String {
                            self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
                            return
                        }
                        
                        let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                        let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                        print("user obj: ",userObj)
                        UserObject.shared.Objresponse(response: userObjMsg as! [String : Any],isLogin: true)
                        //if user already registered code it
                        let user = User()
                        user.id = userObj.value(forKey: "id") as? String
                        user.active = userObj.value(forKey: "active") as? String
                        user.city = userObj.value(forKey: "city") as? String
                        
                        //                    UserDefaults.standard.set(userObj.value(forKey: "id") as? String, forKey: "userID")
                        //                    UserDefaults.standard.set(userObj.value(forKey: "auth_token") as? String, forKey: "authToken")
                        
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
                            print("sussessfully registerd")
                            //                        self.navigationController?.popToRootViewController(animated: true)
                            //                        NotificationCenter.default.post(name: Notification.Name("dismissVCnoti"), object: nil)
                            self.tabBarController?.selectedIndex = 0
                            self.navigationController?.popViewController(animated: true)
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }
                        //                    self.otpTextField.text?.removeAll()
                        
                    }else{
                        let msgObj = response?.value(forKey: "msg") as? String
                        let alert = UIAlertController(title: "Alert", message: msgObj, preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }else {
                    self.loader.isHidden = false
                }
                
            }
        }

        
    }
  
}
