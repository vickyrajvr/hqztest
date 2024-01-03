//
//  NotificationProfileViewController.swift
//  WOOW
//
//  Created by Wasiq Tayyab on 12/06/2022.
//

import UIKit
import SDWebImage
protocol followUserDelegate {
    func setFollowUser(followUser : String)
    func setTurnOnNotification(isON : Bool)
}
class NotificationProfileViewController: UIViewController {
    
    var Follow = true
    var user_name = ""
    var otherUserID = ""
    var img = ""
    var noti = ""
    //MARK:- OUTLET
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var followUserNameText: UILabel!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var imgNotification: UIImageView!
    @IBOutlet weak var imgNotificationCircle: UIImageView!
    
    @IBOutlet weak var followView: UIView!
    @IBOutlet weak var viewBac: UIView!
    
    @IBOutlet weak var imgNoNotificationCircle: UIImageView!
    
    var delegate: followUserDelegate?
    
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewBac.alpha = 0.5
        
        
        if (Follow == true){
            followView.isHidden = true
            notificationView.isHidden = false
        }else{
            followView.isHidden = false
            notificationView.isHidden = true
        }
        
        imgProfile.layer.cornerRadius = imgProfile.frame.height / 2.0
        imgProfile.layer.masksToBounds = true
        let userImgUrl = URL(string: img)
        imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgProfile.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
        self.lblUsername.text = self.user_name
        followUserNameText.text = "Follow \(self.user_name) to set up LIVE notifications"
        print("noti",noti)
        if noti == "1"{
            self.imgNotificationCircle.image = UIImage(named: "red circle")
            self.imgNotificationCircle.tintColor = UIColor(named: "theme")!
            self.imgNoNotificationCircle.image = UIImage(named: "gray_circle")
            self.imgNoNotificationCircle.tintColor = UIColor(named: "darkGrey")!
        }else {
            self.imgNoNotificationCircle.image = UIImage(named: "red circle")
            self.imgNoNotificationCircle.tintColor = UIColor(named: "theme")!
            self.imgNotificationCircle.image = UIImage(named: "gray_circle")
            self.imgNotificationCircle.tintColor = UIColor(named: "darkGrey")!
        }
        
        
    }
    
    func setup(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewBac.addGestureRecognizer(tap)
        
    }
   
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    //    MARK: - Follow user API
    func followUser(){
        
        let uid = UserDefaultsManager.shared.user_id
        
       // self.loader.isHidden = false
        ApiHandler.sharedInstance.followUser(sender_id: uid, receiver_id: otherUserID) { (isSuccess, response) in
           
            if isSuccess {
               // self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    let followBtn = (userObj.value(forKey: "button") as? String)!
                    if followBtn == "following" || followBtn == "friends" {
                        self.lblUsername.text = "LIVE notification settings"
                        self.followView.isHidden = true
                        self.notificationView.isHidden = false
                        self.delegate?.setFollowUser(followUser: followBtn)

                    }else {
                        
                    }
                }else{
                }
                
            }else{
//                AppUtility?.stopLoader(view: self.view)
            }
        }
    }
    
    //    MARK: - followerNotification API
    func followerNotification(notification : String){
        
        let uid = UserDefaultsManager.shared.user_id
        
        self.loader.isHidden = false
        ApiHandler.sharedInstance.followerNotification(sender_id: uid, receiver_id: otherUserID, notification: notification) { (isSuccess, response) in
            
            if isSuccess {
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let Follower = userObjMsg.value(forKey: "Follower") as! NSDictionary
                    let notification = (Follower.value(forKey: "notification") as? String)!
                    
                    if notification == "1"{
                        self.imgNotificationCircle.image = UIImage(named: "red circle")
                        self.imgNotificationCircle.tintColor = UIColor(named: "theme")!
                        self.imgNoNotificationCircle.image = UIImage(named: "gray_circle")
                        self.imgNoNotificationCircle.tintColor = UIColor(named: "darkGrey")!
                        self.delegate?.setTurnOnNotification(isON: true)
                    }else {
                        self.imgNoNotificationCircle.image = UIImage(named: "red circle")
                        self.imgNoNotificationCircle.tintColor = UIColor(named: "theme")!
                        self.imgNotificationCircle.image = UIImage(named: "gray_circle")
                        self.imgNotificationCircle.tintColor = UIColor(named: "darkGrey")!
                        self.delegate?.setTurnOnNotification(isON: false)
                    }
                    
                }else{
                }
                
            }else{
                //AppUtility?.stopLoader(view: self.view)
            }
        }
    }
    //MARK:- BUTTON ACTION
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func setLiveButtonPressed(_ sender: UIButton) {
        
        
        
//        imgNotificationCircle.image = UIImage(named: "red circle")
//        imgNoNotificationCircle.image = UIImage(named: "gray_circle")
//        self.dismiss(animated: false, completion: nil)
        
        followerNotification(notification: "1")
        self.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func turnOffLiveButtonPressed(_ sender: UIButton) {
//        imgNoNotificationCircle.image = UIImage(named: "red circle")
//        imgNotificationCircle.image = UIImage(named: "gray_circle")
//        self.dismiss(animated: false, completion: nil)
        followerNotification(notification: "0")
        self.dismiss(animated: false, completion: nil)

    }
    
    @IBAction func followButtonPressed(_ sender: UIButton) {
        self.followUser()
        
        
    }
    
}
