//
//  ContentCreatePopupviewcontroller.swift
//  SmashVideos
//
//  Created by Murali karthick Rama Krishnan on 27/12/23.
//

import UIKit
import SDWebImage

class ContentCreatePopupviewcontroller: UIViewController {

    @IBOutlet weak var uploadiew: UIView!
    @IBOutlet weak var goLiveView: UIView!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var goLiveBtn: UIButton!
    @IBOutlet weak var MainContentView: UIView!

    //MARK: Local variables
    var userData = [userMVC]()
    var privacySettingData = [privacySettingMVC]()
    var pushNotiSettingData = [pushNotiSettingMVC]()
    var userID = ""
    var isVideoDelete = false
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator(self.view))!

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initalLoads()
        // Do any additional setup after loading the view.
    }
    

    
}

//MARK: inital load
extension ContentCreatePopupviewcontroller {
    
    func initalLoads() {
        MainContentView.clipsToBounds = true
        MainContentView.layer.cornerRadius = 15
        MainContentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        goLiveView.layer.cornerRadius = 25
        uploadiew.layer.cornerRadius = 25
        uploadBtn.addTarget(self, action: #selector(uploadTap), for: .touchUpInside)
        goLiveBtn.addTarget(self, action: #selector(goLiveTap), for: .touchUpInside)
        closeBtn.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        getUserDetails()
    }
    
    @objc func uploadTap() {
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "actionMediaVC") as! actionMediaViewController
        UserDefaults.standard.set("", forKey: "url")
        let nav = UINavigationController(rootViewController: vc1)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    
    }
    
    @objc func goLiveTap() {
        let myViewController = MainLiveStreamingViewController(nibName: "MainLiveStreamingViewController", bundle: nil)
        myViewController.userData = self.userData
        let navigationController = UINavigationController(rootViewController: myViewController)
        navigationController.navigationBar.isHidden =  true
        //        KeyCenter.isAudience =  false
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func closeTap() {
        self.navigationController?.dismiss(animated: true)
    }
    
    //MARK:- GET USER OWN DETAILS
    func getUserDetails(){
        
        self.userID = UserDefaultsManager.shared.user_id
        
        ApiHandler.sharedInstance.showOwnDetail(user_id: self.userID) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                self.isVideoDelete = true

                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as? NSDictionary
                    let userObj = userObjMsg?.value(forKey: "User") as! NSDictionary
                    
                    let privSettingObj = userObjMsg?.value(forKey: "PrivacySetting") as! NSDictionary
                    let pushNotiSettingObj = userObjMsg?.value(forKey: "PushNotification") as! NSDictionary
                    
                    //                    MARK:- PRIVACY SETTING DATA
                    let direct_message = privSettingObj.value(forKey: "direct_message") as! String
                    let duet = privSettingObj.value(forKey: "duet") as! String
                    let liked_videos = privSettingObj.value(forKey: "liked_videos") as! String
                    let video_comment = privSettingObj.value(forKey: "video_comment") as! String
                    let videos_download = privSettingObj.value(forKey: "videos_download")
                    let privID = privSettingObj.value(forKey: "id")
                    
                    let privObj = privacySettingMVC(direct_message: direct_message, duet: duet, liked_videos: liked_videos, video_comment: video_comment, videos_download: "\(videos_download!)", id: "\(privID!)")
                    self.privacySettingData.append(privObj)
                    
                    //                    MARK:- PUSH NOTIFICATION SETTING DATA
                    let cmnt = pushNotiSettingObj.value(forKey: "comments")
                    let direct_messages = pushNotiSettingObj.value(forKey: "direct_messages")
                    let likes = pushNotiSettingObj.value(forKey: "likes")
                    let pushID = pushNotiSettingObj.value(forKey: "id")
                    let new_followers = pushNotiSettingObj.value(forKey: "new_followers")
                    let video_updates = pushNotiSettingObj.value(forKey: "video_updates")
                    let mentions = pushNotiSettingObj.value(forKey: "mentions")
                    
                    let pushObj = pushNotiSettingMVC(comments: "\(cmnt!)", direct_messages: "\(direct_messages!)", likes: "\(likes!)", mentions: "\(mentions!)", new_followers: "\(new_followers!)", video_updates: "\(video_updates!)", id: "\(pushID!)")
                    
                    self.pushNotiSettingData.append(pushObj)
                    
                    
                    
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
                    let website = (userObj.value(forKey: "website") as? String)!
                    let followBtn = (userObj.value(forKey: "button") as? String)
                    let wallet = (userObj.value(forKey: "wallet") as? String)
                    UserDefaultsManager.shared.wallet = wallet ?? "0"
                    //                    let paypal = (userObj.value(forKey: "paypal") as? String)
                    let verified = (userObj.value(forKey: "verified") as? String)
                    
                    let userId = (userObj.value(forKey: "id") as? String)!
                    
                    let privat = (userObj.value(forKey: "private") as? String)!
                    
                    let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: followBtn ?? "", wallet: wallet ?? "",paypal:"" ?? "", verified: verified ?? "0")
                    
                    
                    if self.userData.count > 0 {
                        for i in 0..<self.userData.count {
                            self.userData.removeAll()
                            self.userData.append(user)
                        }
                    }else{
                        self.userData.append(user)
                        
                        
                    }
                    print("privat",privat)
                    
                    
                   
                    
        
                    
                    
                    
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
                }
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
            }
        }
        
    }
}
