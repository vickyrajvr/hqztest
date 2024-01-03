//
//  LoginEmailViewController.swift
//  Binder
//
//  Created by Mac on 09/07/2021.
//

import UIKit

class LoginEmailViewController: UIViewController {
    
    //MARK:- VARS
    
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    var isShow = true

    
    //MARK: Outlets
    
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var btnForgetPassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnEye: UIButton!
    
    
    @IBOutlet weak var emailSignUpView: UIView!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if topTitle == "Login"{
            emailSignUpView.isHidden = true
        }else {
           
            emailSignUpView.isHidden = false
        }
        tfEmail.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: Button actions
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let textCount = textField.text?.count
        
        print("change textCount: ",textCount!)
        if textCount! > 3{
            btnLogin.backgroundColor = UIColor(named: "theme")!
            btnLogin.setTitleColor(UIColor(named: "white"), for: .normal)
            btnLogin.isUserInteractionEnabled = true
        }else{
            btnLogin.backgroundColor = UIColor(named: "lightGrey")
            btnLogin.setTitleColor(UIColor(named: "darkGrey"), for: .normal)
            btnLogin.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func eyebuttonPressed(sender:UIButton){
        if isShow == false {
            tfPassword.isSecureTextEntry = true
            btnEye.setImage(UIImage(named: "noeye"), for: .normal)
            isShow = true
        }else {
            tfPassword.isSecureTextEntry = false
            btnEye.setImage(UIImage(named: "ic_eye_white-1"), for: .normal)
            isShow = false
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        if !AppUtility!.isEmail(self.tfEmail.text!){
            let alert = UIAlertController(title: "Alert", message: "Your email is not valid", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
            
        }
        if AppUtility!.isEmpty(tfPassword.text!){
            let alert = UIAlertController(title: "Alert", message: "Enter your password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.loginEmail()
        
    }
    
    @IBAction func forgetButtonPressed(_ sender: UIButton) {
        let myViewController = ForgetPasswordViewController(nibName: "ForgetPasswordViewController", bundle: nil)
        
        
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    
    
//    MARK:- Login Email API func
        func loginEmail(){
            self.loader.isHidden = false
            ApiHandler.sharedInstance.login(email: tfEmail.text!, password: tfPassword.text!) { (isSuccess, response) in
                self.loader.isHidden = true
                if isSuccess{
                    if response?.value(forKey: "code") as! NSNumber == 200 {
                        
                        
                        
                        self.showToast(message: "Signin" as! String, font: .systemFont(ofSize: 12))
                        sleep(1)
                        
                        
                        let msgObj = response?.value(forKey: "msg") as! NSDictionary
                        let userObj = msgObj.value(forKey: "User") as! NSDictionary
                        print("user obj: ",userObj)
                        //if user already registered code it
                        let user = User()
                        user.id = userObj.value(forKey: "id") as? String
                        user.active = userObj.value(forKey: "active") as? String
                        user.city = userObj.value(forKey: "city") as? String
                        
                        UserDefaultsManager.shared.user_id = user.id
                        UserDefaultsManager.shared.auth_token = userObj.value(forKey: "auth_token") as? String ?? ""
                        
                        print("userdefault: ",UserDefaults.standard.string(forKey: "userID"))
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
                        user.wallet = userObj.value(forKey: "wallet") as? String
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
    
                            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                        }
                        
                    }else{
                        
                        let alert = UIAlertController(title: "Alert", message: response?.value(forKey: "msg") as! String, preferredStyle: UIAlertController.Style.alert)
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
    
  
   
    
}
