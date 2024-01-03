//
//  newProfileViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 13/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import DropDown
import Lottie

import QCropper
protocol setUserDefalault {
    func userLogin(isLogin : Bool)
}
class newProfileViewController:UIViewController,setUserDefalault, UIGestureRecognizerDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var switchAccountBtn: UIButton!
    func userLogin(isLogin: Bool) {
        if isLogin == true {
            setup()
        }else {
            newLoginScreenAppear()
        }
    }
    
    
    func newLoginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
    
    //MARK: - VARS
    var isVideoDelete = false
    var userID = ""
    var willapprearCallApi = false
    var user_name = ""
    var full_nam = ""
    var notifKey = ""
    var img_URL = ""
    var userData = [userMVC]()
    var recommendUsersData = [userMVC]()
    var isSuggExpended = false
    var privacySettingData = [privacySettingMVC]()
    var pushNotiSettingData = [pushNotiSettingMVC]()
    var isFoll = ""
    var userVidArr = [videoMainMVC]()
    var videosMainArr = [videoMainMVC]()
    var likeVidArr = [videoMainMVC]()
    var privateVidArr = [videoMainMVC]()
    var indexSelected = 0
    var LikedVideoStartPoint = 0
    var privateVideoStartPoint = 0
    var startPoint = 0
    var indexrow = 0
    var hasUserVideos = false
    var storeSelectedIP = IndexPath(item: 0, section: 0)
    var hasLikedVideos = false
    var hasPrivateVideos = false
    var isLoading = false
    var total_videos : Int?
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator(self.view))!

    }()
    
    var userItem = [["Image":"music tok icon-2","ImageSelected":"music tok icon-5","isSelected":"true"],["Image":"music tok icon-1","ImageSelected":"music tok icon-4","isSelected":"false"],["Image":"likeVideo","ImageSelected":"music tok icon-6","isSelected":"false"]]
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"theme")!
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    //MARK:- OUTLET
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgUser: CustomImageView!
    
    
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var lblLikesCount: UILabel!
    
    @IBOutlet weak var privateView: UIView!
    
    @IBOutlet weak var btnEditProfile: UIButton!
    
    
    @IBOutlet weak var privateVideoView: UIView!
    @IBOutlet weak var lblprivate: UILabel!
    @IBOutlet weak var lblPrivateDescr: UILabel!
    
    
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var userItemsCollectionView: UICollectionView!
    @IBOutlet weak var videosCV: UICollectionView!
    
    
    @IBOutlet weak var uperViewHeightConst: NSLayoutConstraint!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        userItemsCollectionView.delegate = self
        userItemsCollectionView.dataSource = self
        videosCV.delegate = self
        videosCV.dataSource = self
        
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        //
        //        self.imgUser.addGestureRecognizer(tap)
        //
        //        self.imgUser.isUserInteractionEnabled = true
        //
        
        
        self.scrollViewOutlet.delegate = self
        self.loader.isHidden = false
        self.setup()
        if #available(iOS 10.0, *) {
            scrollViewOutlet.refreshControl = refresher
        } else {
            scrollViewOutlet.addSubview(refresher)
        }
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressVideo))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.videosCV.addGestureRecognizer(lpgr)
        
        switchAccountBtn.addTarget(self, action: #selector(switchAccountTap), for: .touchUpInside)
    }

    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.backgroundColor = UIColor(named: "black")
        setNeedsStatusBarAppearanceUpdate()


        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
        
        self.hidesBottomBarWhenPushed = false
        print("isRun",isRun)
        if isRun == false {
            
        }else {
            isRun = false
            setup()
            
        }
    }
    
    func setup(){
        if UserDefaultsManager.shared.user_id == "" {
            
        }else {
            
            

            self.getUserDetails()
            
            if self.indexSelected == 0 {
                self.getUserVideos(startPoint: "\(self.startPoint)")
            }else if self.indexSelected == 1{
                self.getPrivateVideos(startPoint: "\(self.privateVideoStartPoint)")
            }else {
                self.getLikedVideos(startPoint: "\(self.LikedVideoStartPoint)")
            }
            
        }
        
    }
    
    
    @IBAction func spacesButtonPressed(_ sender: UIButton) {
        let myViewController = SpacesViewController(nibName: "SpacesViewController", bundle: nil)
        myViewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    
    
    @objc func switchAccountTap() {
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "SwtichAccountViewController") as! SwtichAccountViewController
       
        let nav = UINavigationController(rootViewController: vc1)
        nav.navigationBar.isHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    //    MARK:- handleLongPressVideo
    @objc func handleLongPressVideo(gestureReconizer: UILongPressGestureRecognizer) {
        
        print("longPressed")
        //        func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        
        //            if (gestureReconizer.state != UIGestureRecognizer.State.ended){
        //                return
        //            }
        
        if isVideoDelete == true {
            
            let p = gestureReconizer.location(in: self.videosCV)
            
            if let indexPath : IndexPath = (self.videosCV?.indexPathForItem(at: p)) as IndexPath?{
                //do whatever you need to do
                
                let alert = UIAlertController(title: "Delete Video", message: "Are you sure you want to delete the item ? ", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    
                    self.deleteVideoAPI(indexPath: indexPath)
                }
                
                //Add the actions to the alert controller
                alert.addAction(cancelAction)
                alert.addAction(deleteAction)
                
                //Present the alert controller
                present(alert, animated: true, completion: nil)
            }
        }else {
            
        }
       
        
        //        }
    }
    
    //     MARK:- DELETE VIDEO FUNC
    func deleteVideoAPI(indexPath:IndexPath){
        
        let videoID = videosMainArr[indexPath.row].videoID
        self.loader.isHidden = false
        
        ApiHandler.sharedInstance.deleteVideo(video_id: videoID) { (isSuccess, response) in
            
            self.loader.isHidden = true
            if isSuccess{
                let code = response?.value(forKey: "code") as! NSNumber
                if code == 200{
                    DispatchQueue.main.async {
                        //                        self.namesArray.remove(at: indexPath.row)
                        //                        self.imagesArray.remove(at: indexPath.row)
                        //                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.isLoading = true
                        self.videosMainArr.remove(at: indexPath.row)
                        self.videosCV.deleteItems(at: [indexPath])
                    }
                    
                }else{
                    AppUtility?.displayAlert(title: "Try Again", message: "Something went Wrong")
                }
            }
        }
    }
    
    
    
    @objc
    func requestData() {
        print("requesting data")
        self.isLoading = true
        for i in 0..<self.userItem.count {
            var obj  = self.userItem[i]
            obj.updateValue("false", forKey: "isSelected")
            self.userItem.remove(at: i)
            self.userItem.insert(obj, at: i)
            
        }
        
        self.getUserDetails()
        self.StoreSelectedIndex(index: storeSelectedIP.row)
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    
    @objc func StoreSelectedIndex(index:Int){
        var obj  =  self.userItem[index]
        obj.updateValue("true", forKey: "isSelected")
        self.userItem.remove(at: index)
        self.userItem.insert(obj, at: index)
        print("index",index)
        if index == 0{
            
            self.privateVideoView.isHidden = true
            self.hasUserVideos = false
            self.indexrow = 0
            print("my vid")
            self.loader.isHidden = false
            self.startPoint = 0
            getUserVideos(startPoint: "\(startPoint)")
        }else if index == 1{
            
            self.uploadView.isHidden = true
            self.hasPrivateVideos = false
            self.indexrow = 1
            print("private")
            self.loader.isHidden = false
            self.privateVideoStartPoint = 0
            
            self.getPrivateVideos(startPoint: "\(privateVideoStartPoint)")
            
            
        }else{
            
            self.uploadView.isHidden = true
            self.hasLikedVideos = false
            self.indexrow = 2
            print("liked")
            self.loader.isHidden = false
            self.LikedVideoStartPoint = 0
            getLikedVideos(startPoint: "\(LikedVideoStartPoint)")
            
        }
        self.userItemsCollectionView.reloadData()
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
                    
                    
                    if privat == "0"{
                        self.privateView.isHidden = true
                    }else {
                        self.privateView.isHidden = false
                    }
                    
                    if firstName == "" || lastName == ""{
                        self.lblName.text = "\(userName)"
                    }else {
                        self.lblName.text = firstName + lastName
                    }
                    
                    
                    self.lblUsername.text = "@\(userName)"
                    self.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.img_URL = userImage
                    self.imgUser.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: userImage ?? ""))!), placeholderImage: UIImage(named:"noUserImg"))
                    self.lblDesc.text = bio
                    let followings_Count = Double(followings)
                    let followings_ = self.formatPoints(num: followings_Count ?? 0.0)
                    
                    let followers_Count = Double(followers)
                    let followers_ = self.formatPoints(num: followers_Count ?? 0.0)
                    
                    let likes_Count = Double(likesCount)
                    let likes_ = self.formatPoints(num: likes_Count ?? 0.0)
                    
                    
                    
                    self.lblFollowingCount.text = followings_
                    self.lblFollowersCount.text = followers_
                    self.lblLikesCount.text = likes_
                    
                    
                    
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
    
    
    //    MARK:- GET LIKED VIDEOS
    func getLikedVideos(startPoint: String){
        
        
        //        AppUtility?.stopLoader(view: view)
        isLoading = true
        print("userID test: ",userID)
        if hasLikedVideos == false {
            self.likeVidArr.removeAll()
            self.videosMainArr.removeAll()
        }else {
            
        }
        self.hasPrivateVideos = false
        
        var uid = UserDefaultsManager.shared.user_id
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showUserLikedVideos(user_id: uid, starting_point: startPoint) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                self.isVideoDelete = false

                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let vidObjMsg = response?.value(forKey: "msg") as! NSArray
                    //                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                   
                    for vidObject in vidObjMsg{
                        let vidObj = vidObject as! NSDictionary
                        
                        //                        let videoDic = vidObj.value(forKey: "Video") as! NSDictionary
                        let videoObj = vidObj.value(forKey: "Video") as! NSDictionary
                        let userObj = videoObj.value(forKey: "User") as! NSDictionary
                        let soundObj = videoObj.value(forKey: "Sound") as? NSDictionary
                        
                        let videoUrl = videoObj.value(forKey: "video") as! String
                        
                        let videoThum = soundObj?.value(forKey: "thum")
                        let videoGif = videoObj.value(forKey: "gif") as! String
                        let promote = videoObj.value(forKey: "promote")
                        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
                        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
                        let like = "\(videoObj.value(forKey: "like") ?? "")"
                        let allowComment = videoObj.value(forKey: "allow_comments") as! String
                        let videoID = videoObj.value(forKey: "id") as! String
                        let videoDesc = videoObj.value(forKey: "description") as! String
                        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
                        let created = videoObj.value(forKey: "created") as! String
                        let views = "\(videoObj.value(forKey: "view") ?? "")"
                        let duetVidID = videoObj.value(forKey: "duet_video_id")
                        
                        let userID = userObj.value(forKey: "id") as! String
                        let username = userObj.value(forKey: "username") as! String
                        let userOnline = userObj.value(forKey: "online") as! String
                        let userImg = userObj.value(forKey: "profile_pic") as! String
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        let verified = userObj.value(forKey: "verified")
                        
                        let soundID = soundObj?.value(forKey: "id") as? String
                        let soundName = soundObj?.value(forKey: "name") as? String
                        
                        let repost_count = videoObj.value(forKey: "repost_count")
                        let followers_count = userObj.value(forKey: "followers_count")
                        let thum1 = videoObj.value(forKey: "thum") as? String
                        let videoO = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: "\(videoThum ?? "")", videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", views: "\(views )", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg, role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", followersCount: "\(followers_count ?? "")", soundName: "\(soundName ?? "")")
                        
                        self.likeVidArr.append(videoO)
                    }
                    
                }else{
                    
                    self.hasLikedVideos = false
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                
                self.videosMainArr = self.likeVidArr
                if self.videosMainArr.count == 0{
                    self.privateVideoView.isHidden = false
                    self.uploadView.bringSubviewToFront(self.privateVideoView)
                    self.lblprivate.text = "Your liked videos"
                    self.lblPrivateDescr.text = "There is no liked videos so far."
                }else{
                    self.privateVideoView.isHidden = true
                }
                print("videosMainArr",self.videosMainArr.count)
                if self.videosMainArr.count == 20 {
                    self.isLoading = false
                    self.hasLikedVideos = true
                }else {
                    self.isLoading = true
                    self.hasLikedVideos = false
                }
                
                self.videosCV.reloadData()
                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    
    //    MARK:- GET PRIVATE VIDEOS
    func getPrivateVideos(startPoint: String){
        
        print("userID test: ",userID)
        
        if hasPrivateVideos == false {
            self.privateVidArr.removeAll()
            self.videosMainArr.removeAll()
            
        }else {
            
        }
        
        var uid = UserDefaultsManager.shared.user_id
        
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: uid, starting_point: startPoint) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                self.isVideoDelete = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userPrivateObj = userObjMsg.value(forKey: "private") as! NSArray
                    
                   
                    for i in 0..<userPrivateObj.count{
                        let privateObj  = userPrivateObj.object(at: i) as! NSDictionary
                        
                        let videoObj = privateObj.value(forKey: "Video") as! NSDictionary
                        let userObj = privateObj.value(forKey: "User") as! NSDictionary
                        let soundObj = privateObj.value(forKey: "Sound") as! NSDictionary
                        
                        let videoUrl = videoObj.value(forKey: "video") as! String
                        let videoThum = videoObj.value(forKey: "thum") as! String
                        let videoGif = videoObj.value(forKey: "gif") as! String
                        
                        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
                        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
                        let like = "\(videoObj.value(forKey: "like") ?? "")"
                        let allowComment = videoObj.value(forKey: "allow_comments") as! String
                        let videoID = videoObj.value(forKey: "id") as! String
                        let videoDesc = videoObj.value(forKey: "description") as! String
                        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
                        let created = videoObj.value(forKey: "created") as! String
                        let views = "\(videoObj.value(forKey: "view") ?? "")"
                        let duetVidID = videoObj.value(forKey: "duet_video_id")
                        
                        let userID = userObj.value(forKey: "id") as! String
                        let username = userObj.value(forKey: "username") as! String
                        let userOnline = userObj.value(forKey: "online") as! String
                        let userImg = userObj.value(forKey: "profile_pic") as! String
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        let verified = userObj.value(forKey: "verified")
                        
                        let soundID = soundObj.value(forKey: "id") as? String
                        let soundName = soundObj.value(forKey: "name") as? String
                        
                        let repost_count = videoObj.value(forKey: "repost_count")
                        let followers_count = userObj.value(forKey: "followers_count")
                        
                        let promote = videoObj.value(forKey: "promote")
                        
                        let thum1 = videoObj.value(forKey: "thum") as? String
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: "\(videoThum ?? "")", videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", views: "\(views )", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg, role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", followersCount: "\(followers_count ?? "")", soundName: "\(soundName ?? "")")
                        
                        self.privateVidArr.append(video)
                    }
                    
                }else{
                    self.hasPrivateVideos = false
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                }
                print("videosMainArr",self.videosMainArr.count)
                self.videosMainArr = self.privateVidArr
                if self.videosMainArr.count == 0{
                    self.privateVideoView.isHidden = false
                    self.uploadView.bringSubviewToFront(self.privateVideoView)
                    self.lblprivate.text = "Your private videos"
                    self.lblPrivateDescr.text = "There is no private videos so far."
                }else{
                    self.privateVideoView.isHidden = true
                }
                
                if self.videosMainArr.count == 20 {
                    self.isLoading = false
                    self.hasPrivateVideos = true
                }else {
                    self.isLoading = true
                    self.hasPrivateVideos = true
                }
                
                
                self.videosCV.reloadData()
                
                
                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //    MARK:- GET USERS VIDEOS
    func getUserVideos(startPoint: String){
        
        print("userID test: ",userID)
        if hasUserVideos == false {
            self.userVidArr.removeAll()
            self.videosMainArr.removeAll()
        }
        self.hasPrivateVideos = false
        isLoading = true
        var uid = UserDefaultsManager.shared.user_id
        print("uid: ",uid)
        
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: uid, starting_point: startPoint) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
               
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                    
                    for i in 0..<userPublicObj.count{
                        let publicObj  = userPublicObj.object(at: i) as! NSDictionary
                        
                        let videoObj = publicObj.value(forKey: "Video") as! NSDictionary
                        let userObj = publicObj.value(forKey: "User") as! NSDictionary
                        let soundObj = publicObj.value(forKey: "Sound") as! NSDictionary
                        
                        let videoUrl = videoObj.value(forKey: "video") as! String
                        let promote = videoObj.value(forKey: "promote")
                        let thum = soundObj.value(forKey: "thum")
                        let videoGif = videoObj.value(forKey: "gif") as! String
                        
                        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
                        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
                        let like = "\(videoObj.value(forKey: "like") ?? "")"
                        let allowComment = videoObj.value(forKey: "allow_comments") as! String
                        let videoID = videoObj.value(forKey: "id") as! String
                        let videoDesc = videoObj.value(forKey: "description") as! String
                        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
                        let created = videoObj.value(forKey: "created") as! String
                        let views = "\(videoObj.value(forKey: "view") ?? "")"
                        let duetVidID = videoObj.value(forKey: "duet_video_id")
                        
                        let userID = userObj.value(forKey: "id") as! String
                        let username = userObj.value(forKey: "username") as! String
                        let userOnline = userObj.value(forKey: "online") as! String
                        let userImg = userObj.value(forKey: "profile_pic") as! String
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        let verified = userObj.value(forKey: "verified")
                        
                        let soundID = soundObj.value(forKey: "id") as? String
                        let soundName = soundObj.value(forKey: "name") as? String
                        
                        let repost_count = videoObj.value(forKey: "repost_count")
                        let followers_count = userObj.value(forKey: "followers_count")
                        
                        let thum1 = videoObj.value(forKey: "thum") as? String
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: "\(thum ?? "")", videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", views: "\(views )", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg, role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", followersCount: "\(followers_count ?? "")", soundName: "\(soundName ?? "")")
                        
                        
                        self.userVidArr.append(video)
                    }
                    
                }else{
                    self.hasUserVideos = false
                    //  self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    
                }
                
                
                
                
                print("videosMainArr.count: ",self.videosMainArr.count)
                self.videosMainArr = self.userVidArr
                if self.userVidArr.count == 0 {
                    self.uploadView.isHidden = false

                }else {
                    self.uploadView.isHidden = true
                }
                if self.videosMainArr.count == 20 {
                    self.isLoading = false
                    self.hasUserVideos = true
                }else {
                    self.isLoading = true
                    self.hasUserVideos = true
                }
                
                
                self.videosCV.reloadData()
                
                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height + 30
                self.uperViewHeightConst.constant = height
                print("height: ",height)
                //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
                self.view.layoutIfNeeded()
                self.videosCV.reloadData()
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //MARK:- SCROLL VIEW
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollViewOutlet {
            let contentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - contentOffset <= 20.0 {
                //                   print("gggggggg")
                if indexrow == 0 {
                    if hasUserVideos == true && isLoading == false {
                        print("111111111")
                        startPoint = startPoint + 1
                        self.getUserVideos(startPoint: "\(startPoint)")
                    }else {

                    }

                }

                if indexrow == 1 {
                    if hasPrivateVideos == true && isLoading == false {
                        print("222")
                        privateVideoStartPoint = privateVideoStartPoint + 1
                        // self.isLiked = true
                        self.getPrivateVideos(startPoint: "\(privateVideoStartPoint)")

                    }else {

                    }

                }
//
                if indexrow == 2 {
                    if hasLikedVideos == true && isLoading == false {
                        print("liked video")
                        LikedVideoStartPoint = LikedVideoStartPoint + 1
                        // self.isLiked = true
                        self.getLikedVideos(startPoint: "\(LikedVideoStartPoint)")

                    }else {

                    }

                }

                //                   if ((!self.isLoading) && (isHasMore)) {
                //                       findRideHistoryOfCustomerAPI()
                //                   }
            }
        }
    
    }
    
    //MARK: -BUTTON ACTION
    
    
    @IBAction func uploadVideoButtonPressed(_ sender: UIButton) {
        let vc1 = storyboard?.instantiateViewController(withIdentifier: "actionMediaVC") as! actionMediaViewController
        UserDefaults.standard.set("", forKey: "url")
        let nav = UINavigationController(rootViewController: vc1)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
        
    }
    
    
    @IBAction func profileViewButtonPressed(_ sender: UIButton) {
        let myViewController = ProfileViewsViewController(nibName: "ProfileViewsViewController", bundle: nil)
        myViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    
    
    @IBAction func btnLiveButtonPressed(_ sender: UIButton) {
        
        
        let myViewController = MainLiveStreamingViewController(nibName: "MainLiveStreamingViewController", bundle: nil)
        myViewController.userData = self.userData
        let navigationController = UINavigationController(rootViewController: myViewController)
        navigationController.navigationBar.isHidden =  true
        //        KeyCenter.isAudience =  false
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
        
       
        
        
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainViewController
//
//        vc.userData = self.userData
//
//
//        let navigationController = UINavigationController(rootViewController: vc)
//        navigationController.navigationBar.isHidden =  true
//        //        KeyCenter.isAudience =  false
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        
        let myViewController = SettingViewController(nibName: "SettingViewController", bundle: nil)
        myViewController.user_name = userData[0].username
        myViewController.full_name = userData[0].first_name + userData[0].last_name
        myViewController.image_url = userData[0].userProfile_pic
        myViewController.delegate = self
        myViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myViewController, animated: true)
        
    }
    
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        let myViewController = LikesViewController(nibName: "LikesViewController", bundle: nil)
        myViewController.username = userData[0].username
        myViewController.likes_count = userData[0].likesCount
        myViewController.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(myViewController, animated: false, completion: nil)
    }
    
    @IBAction func editProfileButtonPressed(_ sender: CustomButton) {
        let myViewController = EditProfileViewController(nibName: "EditProfileViewController", bundle: nil)
        myViewController.userData = self.userData
        myViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(myViewController, animated: true)
    }
    @IBAction func followingButtonPressed(_ sender: UIButton) {
        if let rootViewController = UIApplication.topViewController() {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc =  storyMain.instantiateViewController(withIdentifier: "MainFFSViewController") as! MainFFSViewController
            vc.userData = self.userData
            isOtherUserVisit = false
            
            if sender.tag == 0 {
                vc.data =  "Following"
                vc.SelectedIndex = 0
                following_total_count = Int(userData[0].following)!
                
            }else {
                vc.data =  "Followers"
                vc.SelectedIndex = 1
                followers_total_count = Int(userData[0].followers)!
                
            }
            vc.hidesBottomBarWhenPushed = true
            rootViewController.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW

extension newProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == userItemsCollectionView {
            return userItem.count
        }else {
            return videosMainArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newProfileItemsCVC", for: indexPath)as! newProfileItemsCollectionViewCell
        if collectionView == userItemsCollectionView {
            
            if indexPath.row == 0 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 1 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            if indexPath.row == 2{
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.horizontalView.isHidden  = true
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["Image"]!)
                }else{
                    cell.horizontalView.isHidden  = false
                    cell.imgItems.image = UIImage(named: self.userItem[indexPath.row]["ImageSelected"]!)
                }
            }
            
        }else {
            
            let videoObj = videosMainArr[indexPath.row]
            //            cell.imgVideoTrimer.sd_setImage(with: URL(string:videoObj.videoGIF), placeholderImage: UIImage(named: "videoPlaceholder"))
            
            let gifURL = AppUtility?.detectURL(ipString: videoObj.videoGIF)
            
            if self.hasPrivateVideos == false {
                cell.imgLock.isHidden = true
            }else {
                cell.imgLock.isHidden = false
            }
            
            
            cell.imgVideoTrimer.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgVideoTrimer.sd_setImage(with: URL(string:(gifURL!)), placeholderImage: UIImage(named:"videoPlaceholder"))
            let view = Double(videoObj.view)
            let view_Count = formatPoints(num: view ?? 0.0)
           
            cell.lblViewerCount.setTitle("\(view_Count)", for: .normal)
            
            //            cell.lblViewerCount.text(videoObj.view)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == userItemsCollectionView{
            
            for i in 0..<self.userItem.count {
                var obj  = self.userItem[i]
                obj.updateValue("false", forKey: "isSelected")
                self.userItem.remove(at: i)
                self.userItem.insert(obj, at: i)
                
            }
            
            self.StoreSelectedIndex(index: indexPath.row)
            self.indexSelected =  indexPath.row
            self.storeSelectedIP = indexPath
        }else if collectionView == videosCV{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileHomeScreenViewController") as! ProfileHomeScreenViewController
            vc.userVideoArr = videosMainArr
            vc.indexAt = indexPath
            vc.otherUserID =  UserDefaultsManager.shared.user_id
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }else {
            
        }
        
    }
    


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == userItemsCollectionView {
            return CGSize(width: Int(self.userItemsCollectionView.frame.size.width)/(self.userItem.count), height: Int(self.userItemsCollectionView.frame.size.height))
        }else {
            return CGSize(width: self.videosCV.frame.size.width/3-1, height: 204)
            
        }
        
    }
    
    
    //MARK: - COLLEC ACTION
    
    
    func formatPoints(num: Double) ->String{
        var thousandNum = num/1000
        var millionNum = num/1000000
        if num >= 1000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            return("\(thousandNum.roundToPlaces(places: 1))k")
        }
        if num > 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return ("\(millionNum.roundToPlaces(places: 1))M")
        }
        else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
        
    }
    
    
}
