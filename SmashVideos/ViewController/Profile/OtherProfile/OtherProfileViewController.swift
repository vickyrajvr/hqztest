//
//  OtherProfileViewController.swift
//  SmashVideos
//
//  Created by Mac on 27/10/2022.
//

import UIKit
import SDWebImage

class OtherProfileViewController: UIViewController,followUserDelegate,BlockUserProtocol,UIScrollViewDelegate {
    
    //MARK: - VARS
    var userID = ""
    var otherUserID = ""
    var isQrCode = false
    var btn_tag: Int?
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
    var indexSelected = 0
    var LikedVideoStartPoint = 0
    var startPoint = 0
    var indexrow = 0
    var hasUserVideos = false
    var storeSelectedIP = IndexPath(item: 0, section: 0)
    var hasLikedVideos = false
    var isLoading = false
    var total_videos : Int?
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    var userItem = [["Image":"music tok icon-2","ImageSelected":"music tok icon-5","isSelected":"true"],["Image":"likeVideo","ImageSelected":"music tok icon-6","isSelected":"false"]]
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named:"theme")!
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    var blockDelegate : BlockUserProtocol?
    var isblock = false
    
    //MARK: - OUTLET
    
    @IBOutlet weak var tickStackView: UIStackView!
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imgUser: CustomImageView!
    
    @IBOutlet weak var lblBlockContent: UILabel!
    
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var lblLikesCount: UILabel!
    
    @IBOutlet weak var blockView: UIView!
    
    @IBOutlet weak var lblBlock: UILabel!
    
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var followStackView: UIStackView!
    
    @IBOutlet weak var suggestionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewSuggestion: UIView!
    
    @IBOutlet weak var unfollowStackView: UIStackView!
    @IBOutlet weak var btnUnfollow: CustomButton!
    @IBOutlet weak var btnArrow: CustomButton!
    
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var suggestedCollectionView: UICollectionView!
    
    @IBOutlet weak var userItemsCollectionView: UICollectionView!
    @IBOutlet weak var videosCV: UICollectionView!
    
    @IBOutlet weak var whoopsView: UIView!
    
    @IBOutlet weak var lblWhoops: UILabel!
    
    @IBOutlet weak var uperViewHeightConst: NSLayoutConstraint!
    //MARK: - VIEW DID LOAD
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userItemsCollectionView.delegate = self
        userItemsCollectionView.dataSource = self
        videosCV.delegate = self
        videosCV.dataSource = self
        suggestedCollectionView.delegate = self
        suggestedCollectionView.dataSource = self
       
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))

        self.imgUser.addGestureRecognizer(tap)

        self.imgUser.isUserInteractionEnabled = true
        
        
        self.suggestionViewHeight.constant = 0
        self.scrollViewOutlet.delegate = self
        self.loader.isHidden = false
        self.getOtherUserDetails()
      
        if #available(iOS 10.0, *) {
            scrollViewOutlet.refreshControl = refresher
        } else {
            scrollViewOutlet.addSubview(refresher)
        }
        otherUser_id = otherUserID

        
        if self.indexSelected == 0 {
            self.getUserVideos(startPoint: "\(self.startPoint)")
        }else{
            self.getLikedVideos(startPoint: "\(self.LikedVideoStartPoint)")
        }
        
        self.ShowRecommendedUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController!.tabBar.backgroundColor = UIColor(named: "black")
        setNeedsStatusBarAppearanceUpdate()


        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("test")
        let vc = SharePopViewController(nibName: "SharePopViewController", bundle: nil)
        vc.profileID = userData[0].userID
        vc.objToShare.removeAll()
        vc.img_Url = userData[0].userProfile_pic
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false)
        
    }

    
    @objc
    func requestData() {
        print("requesting data")
        for i in 0..<self.userItem.count {
            var obj  = self.userItem[i]
            obj.updateValue("false", forKey: "isSelected")
            self.userItem.remove(at: i)
            self.userItem.insert(obj, at: i)
            
        }
        self.getOtherUserDetails()
        self.StoreSelectedIndex(index: self.storeSelectedIP.row)
        
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            
            self.refresher.endRefreshing()
        }
    }
    
    func BlockUser(isBlock: Bool) {
        
        if isBlock == true {
            print("isFoll",isFoll)
            self.btn_tag = 2
           
            self.lblBlock.text = "You blocked \(userData[0].username)"
            self.lblBlockContent.text = "You aren't able to see each other's content"
            self.btnFollow.setTitle("Unblock", for: .normal)
            self.btnFollow.setTitleColor(UIColor(named: "white"), for: .normal)
            self.btnFollow.backgroundColor = UIColor(named: "theme")
            self.lblDesc.text = ""
            self.unfollowStackView.isHidden = true
            self.btnNotification.isHidden = true
            self.blockView.isHidden = false
            self.isblock = isBlock
        
        }else {
           
            //self.isFoll = userData[0].followBtn
            print("isFoll",isFoll)
            
            self.btnNotification.isHidden = false
            self.lblDesc.text = userData[0].bio
            
            if self.isFoll == "following" || self.isFoll == "friends" {
                
                self.btnFollow.setTitle("Message", for: .normal)
                self.btnFollow.setTitleColor(UIColor.black, for: .normal)
                self.btnFollow.backgroundColor = UIColor.white
                self.btnFollow.layer.borderWidth = 1
                self.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
                self.btnFollow.layer.cornerRadius = 2
                self.unfollowStackView.isHidden = false
                self.btn_tag = 1
                
            }else {
                self.unfollowStackView.isHidden = true
                self.btnFollow.setTitle("Follow", for: .normal)
                self.btnFollow.setTitleColor(UIColor.white, for: .normal)
                self.btnFollow.backgroundColor = UIColor(named: "theme")!
                self.btn_tag = 0
            }
            
            // hide block view
             self.blockView.isHidden = true
            self.isblock = isBlock
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
        
        
        
        var uid = ""
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showUserLikedVideos(user_id: uid, starting_point: startPoint) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                self.isLoading = false
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let vidObjMsg = response?.value(forKey: "msg") as! NSArray
                    //                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                    if vidObjMsg.count > 0 {
                        self.hasLikedVideos = true
                    }
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
                if self.likeVidArr.count == 0{
                    self.whoopsView.isHidden = false
                    self.lblWhoops.text = "There is no liked videos so far."
                }else{
                    self.whoopsView.isHidden = true
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
    
    
    
    //    MARK:- GET USERS VIDEOS
    func getUserVideos(startPoint: String){
        
        print("userID test: ",userID)
        if hasUserVideos == false {
            self.userVidArr.removeAll()
            self.videosMainArr.removeAll()
        }
        
        isLoading = true
        var uid = ""
        if otherUserID != ""{
            uid = self.otherUserID
        }else{
            uid = self.userID
        }
        print("uid: ",uid)
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: uid, starting_point: startPoint) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                self.isLoading = false
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userPublicObj = userObjMsg.value(forKey: "public") as! NSArray
                    if userPublicObj.count > 0 {
                        self.hasUserVideos = true
                    }
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
                if self.userVidArr.count == 0{
                    self.whoopsView.isHidden = false
                    self.lblWhoops.text = "There is no videos so far."
                }else{
                    self.whoopsView.isHidden = true
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
    
    //MARK: - RECOMMENDED USERS
    
    func ShowRecommendedUsers(){
        
        
        self.recommendUsersData.removeAll()
        let country_id = UserDefaultsManager.shared.country_id
        var uid = UserDefaultsManager.shared.user_id
        ApiHandler.sharedInstance.showSuggestedUsers(user_id: uid, country_id: country_id) { (isSuccess, response) in
            
            if isSuccess{
                //                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userArray = response?.value(forKey: "msg") as! NSArray
                    
                    for i in 0..<userArray.count{
                        let dict  = userArray.object(at: i) as! NSDictionary
                        
                        let userObj = dict.value(forKey: "User") as! NSDictionary
                        let userImage = (userObj.value(forKey: "profile_pic") as? String)!
                        let userName = (userObj.value(forKey: "username") as? String)!
                        let followers = "\(userObj.value(forKey: "followers_count") ?? "")"
                        let followings = "\(userObj.value(forKey: "following_count") ?? "0")"
                        let likesCount = "\(userObj.value(forKey: "likes_count") ?? "")"
                        let videoCount = "\(userObj.value(forKey: "video_count") ?? "")"
                        let firstName = (userObj.value(forKey: "first_name") as? String)!
                        let lastName = (userObj.value(forKey: "last_name") as? String)!
                        let gender = (userObj.value(forKey: "gender") as? String)!
                        let bio = (userObj.value(forKey: "bio") as? String)!
                        let dob = (userObj.value(forKey: "dob") as? String)!
                        let website = (userObj.value(forKey: "website") as? String)!
                        let followBtn = (userObj.value(forKey: "button") as? String)
                        let wallet = (userObj.value(forKey: "wallet") as? String)!
                        let paypal = (userObj.value(forKey: "paypal") as? String)
                        let verified = (userObj.value(forKey: "verified") as? String)
                        
                        UserDefaults.standard.setValue(wallet, forKey: "wallet")
                        
                        let userId = (userObj.value(forKey: "id") as? String)!
                        
                        let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: followBtn ?? "", wallet: wallet,paypal:paypal ?? "", verified: verified ?? "0")
                        self.recommendUsersData.append(user)
                    }
                    
                    
                }else{
                    
                }
                
                
                self.suggestedCollectionView.reloadData()
                
            }else{
                
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
    }
    
    //MARK: - GET other USER DETAILS
    func getOtherUserDetails(){
        self.userData.removeAll()
        
        print("otheruser: ",self.otherUserID)
        print("userID: ",UserDefaultsManager.shared.user_id)
        
        ApiHandler.sharedInstance.showOtherUserDetail(user_id: UserDefaultsManager.shared.user_id, other_user_id: self.otherUserID) { (isSuccess, response) in
            
            self.loader.isHidden = true
            if isSuccess{
                
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    
                    let privSettingObj = userObjMsg.value(forKey: "PrivacySetting") as! NSDictionary
                    let pushNotiSettingObj = userObjMsg.value(forKey: "PushNotification") as! NSDictionary
                    
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
                    self.total_videos = Int(videoCount)
                    let firstName = (userObj.value(forKey: "first_name") as? String)!
                    let lastName = (userObj.value(forKey: "last_name") as? String)!
                    let gender = (userObj.value(forKey: "gender") as? String)!
                    let bio = (userObj.value(forKey: "bio") as? String)!
                    let dob = (userObj.value(forKey: "dob") as? String)!
                    let website = (userObj.value(forKey: "website") as? String)!
                    let followBtn = (userObj.value(forKey: "button") as? String)!
                    //                    let wallet = (userObj.value(forKey: "wallet") as? String)!
                    let paypal = (userObj.value(forKey: "paypal") as? String)
                    let verified = (userObj.value(forKey: "verified") as? String)
                    let privat  = (userObj.value(forKey: "private") as? String)
                    print("verified",verified)
                    if verified == "0" {
                        self.tickStackView.isHidden = true
                    }else {
                        self.tickStackView.isHidden = false
                    }
                    print("privat",privat)
                    print("followBtn",followBtn)
                    if privat == "0"{
                        self.lblBlock.isHidden = true

                    }else if followBtn == "Message" && privat == "1" {
                        self.lblBlock.isHidden = true

                    }else if followBtn == "Follow" && privat == "1" {
                        self.lblBlock.isHidden = false
                        self.lblBlockContent.text = "Follow this account to see the content and engagement"
                        self.lblBlock.text = "This account is private"
                    }
                    
                    
                    if let notificationKey = userObj.value(forKey: "notification") as? NSNumber {
                        print("notificationKey",notificationKey)
                        if notificationKey == 1 {
                            self.btnNotification.setImage(UIImage(named: "alert"), for: .normal)
                            self.notifKey = "1"
                        }else {
                            self.btnNotification.setImage(UIImage(named: "no notification"), for: .normal)
                            self.notifKey = "0"
                        }
                    }else {
                        print("notificationKey",userObj.value(forKey: "notification") as? String)
                        
                        if userObj.value(forKey: "notification") as? String == "1" {
                            self.btnNotification.setImage(UIImage(named: "alert"), for: .normal)
                            self.notifKey = "1"
                        }else {
                            self.btnNotification.setImage(UIImage(named: "no notification"), for: .normal)
                            self.notifKey = "0"
                        }
                    }
                    //                    print(notificationKey)
                    //
                    //                    if notificationKey == "1" {
                    //                        self.btnNotification.setImage(UIImage(named: "alert"), for: .normal)
                    //                    }else {
                    //                        self.btnNotification.setImage(UIImage(named: "no notification"), for: .normal)
                    //                    }
                    //
                    //                    self.notifKey = "\(notificationKey)"
                    //                    UserDefaults.standard.setValue(wallet, forKey: "wallet")
                    //
                    let userId = (userObj.value(forKey: "id") as? String)!
                    print("followBtn",followBtn)
                    
                    
                    let user = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage, role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: followBtn, wallet: "",paypal:paypal ?? "", verified: verified ?? "0")
                    
                    self.userData.append(user)
                    
//                    if self.isFoll == "following" || self.isFoll == "friends" {
//
//                        self.btnFollow.setTitle("Message", for: .normal)
//                        self.btnFollow.setTitleColor(UIColor.black, for: .normal)
//                        self.btnFollow.backgroundColor = UIColor.white
//                        self.btnFollow.layer.borderWidth = 1
//                        self.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
//                        self.btnFollow.layer.cornerRadius = 2
//                        self.unfollowStackView.isHidden = false
//                        self.btn_tag = 1
//
//                    }else {
//                        self.unfollowStackView.isHidden = true
//                        self.btnFollow.setTitle("Follow", for: .normal)
//                        self.btnFollow.setTitleColor(UIColor.white, for: .normal)
//                        self.btnFollow.backgroundColor = UIColor(named: "theme")!
//                        self.btn_tag = 0
//                    }
                    
                    
                    if let block = (userObj.value(forKey: "block") as? NSNumber) {
                        if block == 1 {
                            self.btnNotification.isHidden = true
                            self.blockView.isHidden = false
                            self.isblock = true
                            
                            self.lblBlock.text = "You blocked \(userName)"
                            self.lblBlockContent.text = " You aren't able to see each other's content"
                            self.btnFollow.setTitle("Unblock", for: .normal)
                            self.btnFollow.setTitleColor(UIColor(named: "white"), for: .normal)
                            self.lblDesc.text = ""
                            self.btn_tag = 2
                        }else {
                            self.isFoll = followBtn
                            
                            self.lblDesc.text = bio
                             self.blockView.isHidden = true
                            self.btnNotification.isHidden = false
                            
                            if followBtn == "following" || followBtn == "friends" {
                                
                                self.btnFollow.setTitle("Message", for: .normal)
                                self.btnFollow.setTitleColor(UIColor.black, for: .normal)
                                self.btnFollow.backgroundColor = UIColor.white
                                self.btnFollow.layer.borderWidth = 1
                                self.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
                                self.btnFollow.layer.cornerRadius = 2
                                self.unfollowStackView.isHidden = false
                                self.btn_tag = 1
                            }else {
                                self.unfollowStackView.isHidden = true
                                self.btnFollow.setTitle("Follow", for: .normal)
                                self.btnFollow.setTitleColor(UIColor.white, for: .normal)
                                self.btnFollow.backgroundColor = UIColor(named: "theme")!
                                self.btn_tag = 0
                            }
                            
                            self.isblock = false
                            
                        }
                        
                    }else {
                        let block = userObj.value(forKey: "block") as? String
                        if block == "1" {
                            
                            self.isblock = true
                            
                        }else {
                            
                            self.isblock = false
                            
                        }
                    }
                    
                    
                    self.lblName.text = firstName + lastName
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
                    
                    
                    
                   
                    //                    self.getVideos()
                    //                    self.profileTableView.reloadData()
                }else{
                   
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("showOtherUserDetail API:",response?.value(forKey: "msg") as Any)
                }
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showOtherUserDetail API:",response?.value(forKey: "msg") as Any)
            }
        }
       
        
    }
    
    
    func followUser(rcvrID:String,userID:String){
        
        print("Recid: ",rcvrID)
        print("senderID: ",userID)
        
       
        ApiHandler.sharedInstance.followUser(sender_id: userID, receiver_id: rcvrID) { (isSuccess, response) in
            
            if isSuccess {
                
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    // self.getOtherUserDetails()
                    
                    //                cell?.playerView.pause()
                    //                cell?.pause()
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    let followBtn = (userObj.value(forKey: "button") as? String)!
                    self.isFoll = followBtn
                    print("isFoll",self.isFoll)
                    if followBtn == "following" || followBtn == "friends" {
                        
                        self.btnFollow.setTitle("Message", for: .normal)
                        self.btnFollow.setTitleColor(UIColor.black, for: .normal)
                        self.btnFollow.backgroundColor = UIColor.white
                        self.btnFollow.layer.borderWidth = 1
                        self.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
                        self.btnFollow.layer.cornerRadius = 2
                        self.unfollowStackView.isHidden = false
                        self.btn_tag = 1
                        
                    }else {
                        self.unfollowStackView.isHidden = true
                        self.btnFollow.setTitle("Follow", for: .normal)
                        self.btnFollow.setTitleColor(UIColor.white, for: .normal)
                        self.btnFollow.backgroundColor = UIColor(named: "theme")!
                        self.btn_tag = 0
                    }
                }else{
                    
                    //  self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                }
                
            }else{
                
                //self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
            }
        }
    }
    
    
    //MARK: -BUTTON ACTION
    
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        let myViewController = ShareProfileViewController(nibName: "ShareProfileViewController", bundle: nil)
        myViewController.userData = userData
        myViewController.profileID = self.otherUserID
        myViewController.blockDelegate = self
        myViewController.block = self.isblock
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if isQrCode == false {
            self.navigationController?.popViewController(animated: true)
        }else {
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
            
        }
       

    }
    
    @IBAction func viewAllButtonPressed(_ sender: UIButton) {
        if let rootViewController = UIApplication.topViewController() {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc =  storyMain.instantiateViewController(withIdentifier: "MainFFSViewController") as! MainFFSViewController
            vc.userData = self.userData
            isOtherUserVisit = true
            vc.SelectedIndex = 2
            following_total_count = Int(userData[0].following)!
            followers_total_count = Int(userData[0].followers)!
            
            
            rootViewController.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        let myViewController = LikesViewController(nibName: "LikesViewController", bundle: nil)
        myViewController.username = userData[0].username
        myViewController.likes_count = userData[0].likesCount
        myViewController.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(myViewController, animated: false, completion: nil)
    }
    
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationProfileViewController")as! NotificationProfileViewController
        
        if (isFoll == "follow"){
            vc.Follow = false
        }else {
            vc.Follow = true
        }
        vc.user_name = self.user_name
        vc.otherUserID = self.otherUserID
        vc.delegate = self
        vc.img = self.img_URL
        vc.noti = notifKey
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: false, completion: nil)
        
    }
    
    
    @IBAction func followingButtonPressed(_ sender: UIButton) {
        if let rootViewController = UIApplication.topViewController() {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc =  storyMain.instantiateViewController(withIdentifier: "MainFFSViewController") as! MainFFSViewController
            vc.userData = self.userData
            isOtherUserVisit = true
            
            if sender.tag == 0 {
                vc.data =  "Following"
                vc.SelectedIndex = 0
                following_total_count = Int(userData[0].following)!
                
            }else {
                vc.data =  "Followers"
                vc.SelectedIndex = 1
                followers_total_count = Int(userData[0].followers)!
                
            }
            rootViewController.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    //MARK: DELEGATE
    func setTurnOnNotification(isON: Bool) {
        print("isON",isON)
        if isON == true {
            self.btnNotification.setImage(UIImage(named: "alert-2"), for: .normal)
            self.notifKey = "1"
            
        }else {
            self.btnNotification.setImage(UIImage(named: "no notification"), for: .normal)
            self.notifKey = "0"
        }
    }
    
    func setFollowUser(followUser: String) {
        let followBtn = followUser
        self.isFoll = followBtn
        
        if followBtn == "following" || followBtn == "friends" {
            
            self.btnFollow.setTitle("Message", for: .normal)
            self.btnFollow.setTitleColor(UIColor.black, for: .normal)
            self.btnFollow.backgroundColor = UIColor.white
            self.btnFollow.layer.borderWidth = 1
            self.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
            self.btnFollow.layer.cornerRadius = 2
            self.unfollowStackView.isHidden = false
            
        }else {
            self.unfollowStackView.isHidden = true
            self.btnFollow.setTitle("Follow", for: .normal)
            self.btnFollow.setTitleColor(UIColor.white, for: .normal)
            self.btnFollow.backgroundColor = UIColor(named: "theme")!
        }
    }
    
    func blockUser(){

        let uid = UserDefaultsManager.shared.user_id
        ApiHandler.sharedInstance.blockUser(user_id: uid, block_user_id: userData[0].userID) { (isSuccess, response) in
        
            
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
        
                    print("isFoll",self.isFoll)
                    self.btn_tag = 2
                    self.lblBlock.text = "You blocked \(self.userData[0].username)"
                    self.lblBlockContent.text = " You aren't able to see each other's content"
                    self.btnFollow.setTitle("Unblock", for: .normal)
                    self.btnFollow.setTitleColor(UIColor(named: "white"), for: .normal)
                    self.btnFollow.backgroundColor = UIColor(named: "theme")
                    self.lblDesc.text = ""
                    self.unfollowStackView.isHidden = true
                    self.btnNotification.isHidden = true
                    self.blockView.isHidden = false
                    self.isblock = true
                    
                }else{
                    
                    print("isFoll",self.isFoll)
                    
                    self.btnNotification.isHidden = false
                    self.lblDesc.text = self.userData[0].bio
                    
                    if self.isFoll == "following" || self.isFoll == "friends" {
                        
                        self.btnFollow.setTitle("Message", for: .normal)
                        self.btnFollow.setTitleColor(UIColor.black, for: .normal)
                        self.btnFollow.backgroundColor = UIColor.white
                        self.btnFollow.layer.borderWidth = 1
                        self.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
                        self.btnFollow.layer.cornerRadius = 2
                        self.unfollowStackView.isHidden = false
                        self.btn_tag = 1
                        
                    }else {
                        self.unfollowStackView.isHidden = true
                        self.btnFollow.setTitle("Follow", for: .normal)
                        self.btnFollow.setTitleColor(UIColor.white, for: .normal)
                        self.btnFollow.backgroundColor = UIColor(named: "theme")!
                        self.btn_tag = 0
                    }
                    
                    // hide block view
                     self.blockView.isHidden = true
                    self.isblock = false
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    
                    print("blockUser API:",response?.value(forKey: "msg") as! String)
                }
            }
            
        }
        
    }
    
    
    
    @IBAction func followMessaButtonPressed(_ sender: UIButton) {
        if btn_tag == 0 {
            followUser(rcvrID: self.otherUserID, userID: UserDefaultsManager.shared.user_id)
        }else if btn_tag == 1 {
            print("Go to Message screen")
            let vc = storyboard?.instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
            vc.receiverData = userData
            vc.otherVisiting = true
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            print("block")
            blockUser()
        }
        
//        if isFoll == "follow" {
//
//        } else if self.isFoll == "Unblock"{
//            print("block")
//
//        }else {
//
//        }
        
    }
    
    @IBAction func unFollowButtonPressed(_ sender: UIButton) {
        followUser(rcvrID: self.otherUserID, userID: UserDefaultsManager.shared.user_id)
    }
    
    
    @IBAction func downArrowButtonPressed(_ sender: UIButton) {
        
        if self.isSuggExpended == true {
            // self.btnSuggestionArrow.setImage(UIImage(named: "expandArrowDown"), for: .normal)
            viewSuggestion.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.btnArrow.setImage(UIImage(named: "arrowDown"), for: .normal)
                self.suggestionViewHeight.constant = 0
                
                self.view.layoutIfNeeded()
                self.isSuggExpended = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.viewSuggestion.isHidden = true
                }
            }
            
        }else{
            //  self.btnSuggestionArrow.setImage(UIImage(named: "ic_arrow_right"), for: .normal)
            viewSuggestion.isHidden = true
            self.isSuggExpended = true
            UIView.animate(withDuration: 0.5) {
                self.btnArrow.setImage(UIImage(named: "arrowUp"), for: .normal)
                self.suggestionViewHeight.constant = 220
                self.viewSuggestion.isHidden = false
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    
    
    
    //MARK:-FUNCTION
    //MARK:-TEXTFIELD DELEGATE
    //MARK:-SCROLL VIEW
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == self.scrollViewOutlet {
            let contentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - contentOffset <= 20 {
                //                   print("gggggggg")
                if indexrow == 0 {
                    if hasUserVideos == true && isLoading == false {
                        print("111111111")
                        startPoint = startPoint + 1
                        self.getUserVideos(startPoint: "\(startPoint)")
                    }else {
                        
                    }
                    
                }
                
                if indexrow == 2 {
                    if hasLikedVideos == true && isLoading == false {
                        print("222")
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
    
    
    
    
    
}

//MARK: - EXTENSION FOR COLLECTION VIEW

extension OtherProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggestedCollectionView {
            return recommendUsersData.count
        }else if collectionView == userItemsCollectionView {
            return userItem.count
        }else {
            return videosMainArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newProfileItemsCVC", for: indexPath)as! newProfileItemsCollectionViewCell
        if collectionView == suggestedCollectionView {
            let obj = recommendUsersData[indexPath.row]
            cell.contentView.layer.cornerRadius = 2
            cell.contentView.layer.masksToBounds = true
            
            cell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgUser.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: obj.userProfile_pic ?? ""))!), placeholderImage: UIImage(named:"noUserImg"))
            
            cell.lblName.text = (obj.first_name ?? "") + " " + (obj.last_name ?? "")
            cell.lblDesc.text = obj.username
            
            cell.btnFollow.tag = indexPath.row
            cell.btnFollow.addTarget(self, action: #selector(btnFollowFunc(sender:)), for: .touchUpInside)
            
            cell.btnCross.tag = indexPath.row
            cell.btnCross.addTarget(self, action: #selector(btnCrossTapped(sender:)), for: .touchUpInside)
            
        }else if collectionView == userItemsCollectionView {
            
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
            
            cell.imgVideoTrimer.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgVideoTrimer.sd_setImage(with: URL(string:(gifURL!)), placeholderImage: UIImage(named:"videoPlaceholder"))
            let view = Double(videoObj.view)
            let view_Count = formatPoints(num: view ?? 0.0)
            print("view_Count",view_Count)
            cell.lblViewerCount.setTitle("\(view_Count)", for: .normal)
            
            //            cell.lblViewerCount.text(videoObj.view)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == userItemsCollectionView{
            if self.isblock == true {
                
            }else {
                for i in 0..<self.userItem.count {
                    var obj  = self.userItem[i]
                    obj.updateValue("false", forKey: "isSelected")
                    self.userItem.remove(at: i)
                    self.userItem.insert(obj, at: i)
                    
                }
                
                self.StoreSelectedIndex(index: indexPath.row)
                self.indexSelected =  indexPath.row
                self.storeSelectedIP = indexPath
            }
           
        }else if collectionView == videosCV{
            let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileHomeScreenViewController") as! ProfileHomeScreenViewController
            vc.userVideoArr = videosMainArr
            vc.indexAt = indexPath
            vc.otherUserID =  self.otherUserID
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }else {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyMain.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
            vc.hidesBottomBarWhenPushed = true
            let userObj = recommendUsersData[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            vc.otherUserID = userObj.userID
            vc.user_name = userObj.username
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
        
    }
    
    @objc func StoreSelectedIndex(index:Int){
        var obj  =  self.userItem[index]
        obj.updateValue("true", forKey: "isSelected")
        self.userItem.remove(at: index)
        self.userItem.insert(obj, at: index)
        
        if index == 0{
            self.hasUserVideos = false
            self.indexrow = 0
            print("my vid")
            self.loader.isHidden = false
            self.startPoint = 0
            getUserVideos(startPoint: "\(startPoint)")
            
        }else{
            self.hasLikedVideos = false
            self.indexrow = 2
            print("liked")
            self.loader.isHidden = false
            self.LikedVideoStartPoint = 0
            getLikedVideos(startPoint: "\(LikedVideoStartPoint)")
            
        }
        self.userItemsCollectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == suggestedCollectionView {
            return CGSize(width: (self.suggestedCollectionView.frame.size.width - 34)/3, height: 170)
        }else if collectionView == userItemsCollectionView {
            return CGSize(width: Int(self.userItemsCollectionView.frame.size.width)/(self.userItem.count), height: Int(self.userItemsCollectionView.frame.size.height))
        }else {
            return CGSize(width: self.videosCV.frame.size.width/3-1, height: 204)
            
        }
        
    }
    
    
    //MARK: - COLLEC ACTION
    
    @objc func btnFollowFunc(sender: UIButton){
        let uid = UserDefaultsManager.shared.user_id
        if uid == "" || uid == nil{
            loginScreenAppear()
        }else{
            followUserFunc(cellNo: sender.tag)
            //
            if sender.currentTitle == "Following"{
                sender.setTitle("Follow", for: .normal)
                sender.backgroundColor = UIColor(named: "theme")
                sender.setTitleColor(UIColor(named: "theme"), for: .normal)
                sender.setTitleColor(.white, for: .normal)
            }else{
                sender.setTitle("Following", for: .normal)
                sender.backgroundColor = .white
                sender.setTitleColor(.black, for: .normal)
            }
            
        }
    }
    
    func followUserFunc(cellNo:Int){
        let suggUser = self.recommendUsersData[cellNo]
        let rcvrID = suggUser.userID
        let userID = UserDefaultsManager.shared.user_id
        
        self.followRecomdedUser(rcvrID: rcvrID, userID: userID)
    }
    
    //    MARK:- Follow user API
    func followRecomdedUser(rcvrID:String,userID:String){
        
        print("Recid: ",rcvrID)
        print("senderID: ",userID)
        
        
        ApiHandler.sharedInstance.followUser(sender_id: userID, receiver_id: rcvrID) { (isSuccess, response) in
            
            if isSuccess {
                
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                }else{
                    
                    //  self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                }
                
            }else{
                
                //self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
            }
        }
    }
    
    @objc func btnCrossTapped(sender : UIButton){
        print(sender.tag)
        self.remove(index: sender.tag)
    }
    
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
    
    func remove(index: Int) {
        recommendUsersData.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        suggestedCollectionView.performBatchUpdates({
            self.suggestedCollectionView.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
            self.suggestedCollectionView.reloadItems(at: self.suggestedCollectionView.indexPathsForVisibleItems)
        })
    }
    
    
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

extension Double {
    /// Rounds the double to decimal places value
    mutating func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
}

