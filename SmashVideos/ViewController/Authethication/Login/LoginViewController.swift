//
//  LoginViewController.swift
//  MusicTok
//
//  Created by Mac on 14/10/2022.
//

import UIKit
import ActiveLabel
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit
class LoginViewController: UIViewController,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    //MARK:- VARS
    
    let signInConfig = GIDConfiguration(clientID: "504817722238-ake9cvrnlq7fknr9ruln06n6n6tvkfct.apps.googleusercontent.com")
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    var isApple = false
    var first_name = ""
    var last_name = ""
    
    
    
    //MARK:- OUTLET
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var fbView: UIView!
    @IBOutlet weak var googleView: UIView!
    @IBOutlet weak var siwaView: UIView!
    @IBOutlet weak var lblLogin: ActiveLabel!
    
    @IBOutlet weak var lblMainText: UILabel!
    
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activeSetupLabel()
        self.viewTapGesture()
        self.border()
        let appName = Bundle.appName()
        self.lblMainText.text = "Log in to \(appName)"
    }
    
    
    //MARK:-FUNCTION
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func border(){
        phoneView.layer.borderWidth = 0.4
        phoneView.layer.borderColor = UIColor(named: "darkGrey")?.cgColor
        
        fbView.layer.borderWidth = 0.4
        fbView.layer.borderColor = UIColor(named: "darkGrey")?.cgColor
        
        googleView.layer.borderWidth = 0.4
        googleView.layer.borderColor = UIColor(named: "darkGrey")?.cgColor
        
        siwaView.layer.borderWidth = 0.4
        siwaView.layer.borderColor = UIColor(named: "darkGrey")?.cgColor
    }
    
    
    func activeSetupLabel(){
        let customType = ActiveType.custom(pattern: "Terms of Use")
        let customType1 = ActiveType.custom(pattern: "Privacy Policy")
        lblLogin.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        lblLogin.textAlignment = .center
        lblLogin.enabledTypes = [.mention, .hashtag, .url, customType,customType1]
        lblLogin.text = "By signing up,you can confirm to agree our Terms of Use and Privacy Policy"
        lblLogin.textColor = UIColor(named: "black")
        lblLogin.customColor[customType] = UIColor(named: "theme")
        lblLogin.customSelectedColor[customType] = UIColor(named: "theme")
        lblLogin.customColor[customType1] = UIColor(named: "theme")
        lblLogin.customSelectedColor[customType1] = UIColor(named: "theme")
        
        lblLogin.handleCustomTap(for: customType) { element in
            print("Terms of Use")
            let myViewController =  WebViewController(nibName: "WebViewController", bundle: nil)
            myViewController.linkTitle = "Terms of Service"
            myViewController.myUrl = "https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
            myViewController.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(myViewController, animated: true)
        }
        lblLogin.handleCustomTap(for: customType1) { element in
            print("Privacy Policy")
            let myViewController =  WebViewController(nibName: "WebViewController", bundle: nil)
            myViewController.linkTitle = "Privacy Policy"
            myViewController.myUrl = "https://www.termsfeed.com/privacy-policy/4dec1a564a01ea0d15ed86c97c4e8253"
            myViewController.modalPresentationStyle = .fullScreen
            
            self.navigationController?.pushViewController(myViewController, animated: true)
            
        }
        
    }
    
    func viewTapGesture(){
        let tapGoogleView = UITapGestureRecognizer(target: self, action: #selector(self.googleTouchTapped(_:)))
        self.googleView.addGestureRecognizer(tapGoogleView)
        
        let tapPhoneView = UITapGestureRecognizer(target: self, action: #selector(self.phoneTouchTapped(_:)))
        self.phoneView.addGestureRecognizer(tapPhoneView)
        
        let tapFbView = UITapGestureRecognizer(target: self, action: #selector(self.fbTouchTapped(_:)))
        self.fbView.addGestureRecognizer(tapFbView)
        
        let tapSIWAView = UITapGestureRecognizer(target: self, action: #selector(self.siwaTouchTapped(_:)))
        
        self.siwaView.addGestureRecognizer(tapSIWAView)
        
        
    }
    
    
    //MARK:-BUTTON ACTION
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func googleTouchTapped(_ sender: UITapGestureRecognizer) {
        
//        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
//            guard error == nil else { return }
//            guard let user = user else { return }
//            let emailAddress = user.profile?.email
//            let fullName = user.profile?.name
//            let givenName = user.profile?.givenName
//            let familyName = user.profile?.familyName
//            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
//            print(user.authentication.accessToken)
//            print(user.authentication.refreshToken)
//            
//            self.first_name = fullName!
//            
//            let authCode = user.serverAuthCode
//            self.isApple = true
//            self.checkRegisterSocial(auth_token:user.authentication.accessToken,socail_type:"google",social_id:user.userID ?? "",emailAddress : emailAddress ?? "")
//            
//            // If sign in succeeded, display the app's main content View.
//        }
    }
    
    @objc func phoneTouchTapped(_ sender: UITapGestureRecognizer) {
        
        topTitle = "Login"
        let storyMain = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyMain.instantiateViewController(withIdentifier: "MainLoginViewController")as! MainLoginViewController
        self.navigationController?.isNavigationBarHidden = true
        vc.hidesBottomBarWhenPushed = true
        vc.mainTitle = "Login"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func fbTouchTapped(_ sender: UITapGestureRecognizer) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        print(fbloginresult.token?.tokenString ?? "")
                        print(fbloginresult.token?.userID ?? "")
                        
                        self.isApple = true
                        self.showDetails(token: fbloginresult.token?.tokenString ?? "")
                        //
                        
                    }
                }
            }else{
                print(error?.localizedDescription)
            }
        }
    }
    
    
    fileprivate func showDetails(token:String){
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender"]).start { (connection, result, err) in
            
            if err != nil {
                print("Failed to start graph request:", err ?? "")
                return
            }
            
            let dict = result as! NSDictionary
            
            let email = dict["email"] as! String?
            print("The result dict[email] of fb profile::: \(email)")
            let userID = dict["id"] as! String
            print("The result dict[id] of fb profile::: \(userID)")
            self.first_name = dict["first_name"] as! String? ?? ""
            self.last_name = dict["last_name"] as! String? ?? ""
            self.checkRegisterSocial(auth_token: token ,socail_type:"facebook", social_id: userID ?? "" ,emailAddress : email ?? "")
        }
    }
    
    
    @IBAction func btnSignup(_ sender: Any) {
        topTitle = "Signup"
        
        let storyMain = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyMain.instantiateViewController(withIdentifier: "MainLoginViewController")as! MainLoginViewController
        self.navigationController?.isNavigationBarHidden = true
        vc.hidesBottomBarWhenPushed = true
        vc.mainTitle = "Signup"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func siwaTouchTapped(_ sender: UITapGestureRecognizer) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        
        
    }
    
    
    //MARK:- API FUNCTION
    
    func checkRegisterSocial(auth_token:String,socail_type:String,social_id:String,emailAddress : String){
        
        self.loader.isHidden = false
        ApiHandler.sharedInstance.checkRegisterSocial(auth_token:auth_token,socail_type:socail_type,social_id:social_id) { (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    print(response)
                    
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
                        print("sussessfully registerd")
                        
                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                    }
                    
                    
                }else{
                    
                    let alert = UIAlertController(title: NSLocalizedString("MusicTok", comment: ""), message: "Want to create new account?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
                    alert.addAction(UIAlertAction(title: "Signup", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            
                            print("emailAddress",emailAddress)
                            if self.isApple == false {
                                
                                let myViewController = DobViewController(nibName: "DobViewController", bundle: nil)
                                myViewController.email = emailAddress
                                myViewController.phoneNoNew = ""
                                myViewController.social_type = "email"
                                myViewController.authtoken = auth_token
                                myViewController.social_id = social_id
                                self.navigationController?.isNavigationBarHidden = true
                                self.navigationController?.pushViewController(myViewController, animated: true)
                                
                            }else {
                                let myViewController = UsernameViewController(nibName: "UsernameViewController", bundle: nil)
                                myViewController.email = emailAddress
                                myViewController.phoneNoNew = ""
                                myViewController.first_name = self.first_name
                                myViewController.last_name = self.last_name
                                myViewController.social_type = socail_type
                                myViewController.authtoken = auth_token
                                myViewController.social_id = social_id
                                self.navigationController?.isNavigationBarHidden = true
                                self.navigationController?.pushViewController(myViewController, animated: true)
                            }
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                            
                        }}))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                
                
                
            }else {
                self.loader.isHidden = true
                
            }
        }
    }
    
    func loginButton(loginButton: FBLoginButton!, didCompleteWithResult result: LoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            print(error.localizedDescription)
            return
        }
        print("I'm in")
        
    }
    
    
    
    //MARK:- APPLE AUTHETICATION
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        var authtoken = ""
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let data = appleIDCredential.identityToken {
                let token = String(decoding: data, as: UTF8.self)
                print(token)
                authtoken = token
                // here send token to server
            }
            
            
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let firstName = appleIDCredential.fullName?.namePrefix
            let lastName = appleIDCredential.fullName?.nameSuffix
            
            
            print(userIdentifier) // 001269.ca6377678591436c94356a4e5c69faa7.1024
            self.isApple = true
            self.checkRegisterSocial(auth_token:authtoken,socail_type:"apple",social_id:userIdentifier ,emailAddress : email ?? "")
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print(error.localizedDescription)
    }
}

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleDisplayName"] as? String {
            return version
        } else {
            return ""
        }
    }
}
