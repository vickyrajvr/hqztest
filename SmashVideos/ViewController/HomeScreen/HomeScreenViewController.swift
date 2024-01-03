//
//  HomeViewController.swift
//  WOOW
//
//  Created by Wasiq Tayyab on 05/06/2022.
//

import UIKit
import AVFoundation
import EFInternetIndicator
import NVActivityIndicatorView
import GSPlayer
import SDWebImage
import MarqueeLabel
import Photos
import Lottie


class HomeViewController: UIViewController ,InternetStatusIndicable, NotInterstedDelegate,/*RepostDelegate*/ CommentCountUpdateDelegate {
   
    
    
    func CommentCountUpdateDelegate(commentCount: Int) {
        if commentCount == 1 {
            updateCommentCountOfVideo()
        }
    }
    
    func updateCommentCountOfVideo(){
        var uid = UserDefaultsManager.shared.user_id
        ApiHandler.sharedInstance.showVideoDetail(user_id: uid, video_id: self.videoID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let resMsg = response?.value(forKey: "msg") as! NSDictionary
                    
                    let videoDic = resMsg.value(forKey: "Video") as! NSDictionary
                    let userDic = resMsg.value(forKey: "User") as! NSDictionary
                    let soundDic = resMsg.value(forKey: "Sound") as! NSDictionary
                    
                    print("videoDic: ",videoDic)
                    print("userDic: ",userDic)
                    print("soundDic: ",soundDic)
                    
                    let likeCount = videoDic.value(forKey: "like_count")
                    let commentCount = videoDic.value(forKey: "comment_count")
                    let like = videoDic.value(forKey: "like")
                    let thum1 = videoDic.value(forKey: "thum") as? String
                    //                    let repost_count = videoDic.value(forKey: "repost_count")
                    
                    let cell = self.homeVideoCollectionView.cellForItem(at: self.currentVidIP) as? HomeScreenCollectionViewCell
                    //                cell?.playerView.pause()
                    //                cell?.pause()
                    cell?.lblLikeCount.text = "\(likeCount!)"
                    cell?.lblCommentCount.text = "\(commentCount!)"
                    
                    let liked = "\(like!)"
                    if liked == "1"{
                        //                            cell?.like()
                        cell?.alreadyLiked()
                        
                    }else{
                        cell?.heartAnimationView?.removeFromSuperview()
                    }
                    print("likedd: ",like!)
                    
                    let vidDetail = videoDetailMVC(vidLikes: "\(likeCount!)", vidComments: "\(commentCount!)", isLike: "\(like!)", thum: "\(thum1)")
                    
                    self.videoDetail.append(vidDetail)
                    
                }
            }
            
        }
    }
    func notInterstedFunc(status: Bool) {
        self.remove(index: currentVidIP.row)
    }
    
    func reposstFunc(repostStatus: Bool) {
        if repostStatus == true {
            self.getVideoDetails(ip: self.currentVidIP)
        }
    }
    var internetConnectionIndicator: InternetViewIndicator?
    
    
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
        
        
    }()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "theme")
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    
    //MARK:- OUTLET
    @IBOutlet weak var segmentVideos: UISegmentedControl!
    @IBOutlet weak var homeVideoCollectionView: UICollectionView!
    
    @IBOutlet weak var liveBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet var homeTabCollectionView: UICollectionView!
    
    
    var userItem = [["title":"Following","isSelected":"false"],["title":"For You","isSelected":"true"]]
    var indexSelected = 0
    var storeSelectedIP = IndexPath(item: 0, section: 0)
    
    var progressUpdateTimer: Timer?
    
    var videosMainArr = [videoMainPromotionMVC]()
    var videosRelatedArr = [videoMainPromotionMVC]()
    var videosFollowingArr = [videoMainPromotionMVC]()
    var userVideoArr = [videoMainMVC]()
    var discoverVideoArr = [videoMainMVC]()
    
    var videoDetail = [videoDetailMVC]()
    var indexAt : IndexPath!
    var currentVidIP : IndexPath!
    var isFollowing = false
    var videoID = ""
    var videoURL = ""
    var otherUserID = ""
    var name = ""
    var arrThumb = [URL]()
    var isLoad = false
    var items = [URL]()
    var startPoint = 0
    var videoEmpty = false
    var startIndex = 0
    var seconds = 60
    var timer = Timer()
    var giftName: String = ""
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        homeVideoCollectionView.delegate = self
        homeVideoCollectionView.dataSource = self
        self.homeVideoCollectionView.refreshControl =  refresher
        
        
        homeTabCollectionView.delegate = self
        homeTabCollectionView.dataSource = self
       
        homeTabCollectionView.register(UINib(nibName: "homeTabCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "homeTabCollectionViewCell")
        
       
        self.segmentVideos.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
      
        
//        segmentVideos.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
//        segmentVideos.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
//        segmentVideos.selectedSegmentIndex = 1
//        segmentVideos.addTarget(self, action: #selector(HomeViewController.indexChanged(_:)), for: .valueChanged)
        
       
        setupAudio()
        self.startMonitoringInternet()
        
        
        devicesChecks()
        tapGesturesFunc()
        showAdsVideo = true
        self.getDataForFeeds()
        
    
        if #available(iOS 10.0, *) {
            homeVideoCollectionView.refreshControl = refresher
        } else {
            homeVideoCollectionView.addSubview(refresher)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateSoundPlay(notification:)), name: .stopSoundPlayNotify, object: nil)
        
        
        

        
    }
    
    //MARK: giftTap
   
    
    @objc func updateSoundPlay(notification: Notification) {
        //    NotificationCenter.default.post(name: .getAudioPath, object: "myObject", userInfo: [:])
        print("updateSoundPlay")
//        self.singleTabPlayPause()
        
        let visiblePaths = self.homeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = homeVideoCollectionView.cellForItem(at: i) as? HomeScreenCollectionViewCell
            //                cell?.playerView.pause()
            //                cell?.pause()
            
            if cell!.videoView.state == .playing {
                cell!.videoView.pause(reason: .userInteraction)
               
                //                cell!.btnPlayImg.isHidden = false
            } else {
                //                cell!.btnPlayImg.isHidden = true
               // cell!.videoView.resume()
            }
            
        }
        
    }
    
    @objc func requestData() {
        
        
        print("requesting data")
        self.startPoint = 0
       
        for i in 0..<self.userItem.count {
            var obj  = self.userItem[i]
            obj.updateValue("false", forKey: "isSelected")
            self.userItem.remove(at: i)
            self.userItem.insert(obj, at: i)
            
        }
        self.isLoad = false
        self.isFollowing = false
        self.getAllVideos(startPoint: "\(self.startPoint)")
        self.StoreSelectedIndex(index: 1)
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
        
        
//        self.startPoint = 0
//
//        let deadline = DispatchTime.now() + .milliseconds(700)
//        DispatchQueue.main.asyncAfter(deadline: deadline) {
//
//            if self.segmentVideos.selectedSegmentIndex == 0 {
//
//
//                self.isFollowing = true
//
//                self.getFollowingVideos(startPoint: "\(self.startPoint)")
//
//            } else if self.segmentVideos.selectedSegmentIndex == 1 {
//
//                self.isLoad = false
//                self.isFollowing = false
//                self.getAllVideos(startPoint: "\(self.startPoint)")
//
//            }
//
//            self.refresher.endRefreshing()
//        }
    }
    
//    @objc func indexChanged(_ sender: UISegmentedControl) {
//
//        self.startPoint = 0
//
//
//
//        if segmentVideos.selectedSegmentIndex == 0 {
//            print("Select 0")
//            let userID = UserDefaultsManager.shared.user_id
//            if userID == nil || userID == ""{
//                segmentVideos.selectedSegmentIndex = 1
//                loginScreenAppear()
//            }else{
//                //  print("device key: ",UserDefaults.standard.string(forKey: "deviceKey")!)
//
//                self.isLoad = false
//                self.isFollowing = true
//                getFollowingVideos(startPoint: "\(startPoint)")
//            }
//        } else if segmentVideos.selectedSegmentIndex == 1 {
//            print("Select 1")
//            self.isLoad = false
//
//            self.isFollowing = false
//            getAllVideos(startPoint: "\(startPoint)")
//
//        }
//    }
    
    @objc func usernameButtonPressed(sender: UIButton){
        print(sender.tag)
        
        let obj = videosMainArr[sender.tag]
        print("obj user id : ",obj.userID)
        
        let otherUserID = obj.userID
        let userID = UserDefaultsManager.shared.user_id // UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
            //            showToast(message: "Login to Continue..", font: .systemFont(ofSize: 12))
            loginScreenAppear()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
            vc.hidesBottomBarWhenPushed = true
            vc.otherUserID = otherUserID
            vc.user_name = name
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    func getFollowingVideos(startPoint:String){
        
        //         showToast(message: "Loading ...", font: .systemFont(ofSize: 12.0))
        //
        let startingPoint = startPoint
        
        let userID = UserDefaultsManager.shared.user_id
        let deviceID =  UserDefaultsManager.shared.deviceID
        
        //        self.loaderView.startAnimating()
        
        ApiHandler.sharedInstance.showFollowingVideos(user_id: userID, device_id: deviceID, starting_point: startingPoint) { (isSuccess, response) in
            print("res;: ",response!)
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    
                    if startPoint == "0"{
                        self.videosMainArr.removeAll()
                    }
                    self.videosFollowingArr.removeAll()
                    
                    
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    
                    for dic in resMsg{
                        let videoDic = dic["Video"] as! NSDictionary
                        let userDic = dic["User"] as! NSDictionary
                        let soundDic = dic["Sound"] as! NSDictionary
                        
                       
                        let promotionDic = videoDic["Promotion"] as? NSDictionary
                        print("promotionDic: ",promotionDic)
                        let actionButton = promotionDic?.value(forKey: "action_button") as? String
                        let audienceId = promotionDic?.value(forKey: "audience_id")
                        let clicks = promotionDic?.value(forKey: "clicks")
                        let coin = promotionDic?.value(forKey: "coin")
                        let destination = promotionDic?.value(forKey: "destination")
                        let destinatioTap = promotionDic?.value(forKey: "destination_tap")
                        let endDatetime = promotionDic?.value(forKey: "end_datetime")
                        let followers = promotionDic?.value(forKey: "followers")
                        let reach = promotionDic?.value(forKey: "reach")
                        let startDatetime = promotionDic?.value(forKey: "start_datetime")
                        let totalReach = promotionDic?.value(forKey: "total_reach")
                        let userId = promotionDic?.value(forKey: "user_id")
                        let videoId = promotionDic?.value(forKey: "video_id")
                        let websiteUrl = promotionDic?.value(forKey: "website_url")
                        
                        
                        
                        print("videoDic: ",videoDic)
                        print("userDic: ",userDic)
                        print("soundDic: ",soundDic)
                        
                        let videoURL = videoDic.value(forKey: "video") as? String
                        let desc = videoDic.value(forKey: "description") as? String
                        let allowComments = videoDic.value(forKey: "allow_comments")
                        let videoUserID = videoDic.value(forKey: "user_id")
                        let videoID = videoDic.value(forKey: "id") as! String
                        let allowDuet = videoDic.value(forKey: "allow_duet")
                        let duetVidID = videoDic.value(forKey: "duet_video_id")
                        
                        //                        not strings
                        let commentCount = videoDic.value(forKey: "comment_count")
                        let likeCount = videoDic.value(forKey: "like_count")
                        let views = videoDic.value(forKey: "view")
                        let repost_count = videoDic.value(forKey: "repost_count")
                        let sound_id = videoDic.value(forKey: "sound_id")
                        
                        let userImgPath = userDic.value(forKey: "profile_pic") as? String
                        let userName = userDic.value(forKey: "username") as? String
                        let followBtn = userDic.value(forKey: "button") as? String
                        let uid = userDic.value(forKey: "id") as? String
                        let verified = userDic.value(forKey: "verified")
                        let followers_count = userDic.value(forKey: "followers_count")
                        let thum1 = videoDic.value(forKey: "thum") as? String
                        let soundName = soundDic.value(forKey: "name")
                        let thum = soundDic.value(forKey: "thum")
                        let promote = videoDic.value(forKey: "promote")
                        let videoObj = videoMainPromotionMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc ?? "", videoURL: videoURL ?? "", videoTHUM: "\(thum ?? "")", videoGIF: "", view: "", section: "", sound_id: "\(sound_id ?? "")", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn ?? "", duetVideoID: "\(duetVidID!)", views: "\(views ?? "")", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: uid ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath  ?? "", role: "", username: userName  ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified!)", followersCount: "\(followers_count ?? "")", soundName: "\(soundName!)", actionButton: actionButton ?? "", audienceId: "\(audienceId ?? "")", clicks: "\(clicks ?? "")", coin: "\(coin ?? "")", destination: "\(destination ?? "")", destinationTap: "\(destinatioTap ?? "")", endDatetime: "\(endDatetime ?? "")", followers: "\(followers ?? "")", reach: "\(reach ?? "")", startDatetime: "\(startDatetime ?? "")", totalReach: "\(totalReach ?? "")", userId: "\(userId ?? "")", videoId: "\(videoId ?? "")", websiteUrl: "\(websiteUrl ?? "")")
                        self.videosFollowingArr.append(videoObj)
                    }
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    
                    
                    
                    
                    //                    self.videosMainArr = self.videosFollowingArr
                    self.videosMainArr.append(contentsOf: self.videosFollowingArr)
                    
                    //                    self.loaderView.stopAnimating()
                    self.homeVideoCollectionView.reloadData()
                    print("response@200: ",response!)
                }else{
                    //                    self.loaderView.stopAnimating()
                    self.segmentVideos.selectedSegmentIndex = 1
                    //                    self.showToast(message: "Please Follow Someone", font: .systemFont(ofSize: 12))
                }
                
                
            }else{
                print("response failed: ",response!)
                //                self.loaderView.stopAnimating()
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
            }
            
            //            self.loaderView.stopAnimating()
        }
        
    }
    
    //MARK:- BUTTON ACTION
    
    @objc func btnProfilePressed(sender : UIButton){
        print(sender.tag)
        
        let obj = videosMainArr[sender.tag]
        print("obj user id : ",obj.userID)
        
        let otherUserID = obj.userID
        let userID = UserDefaultsManager.shared.user_id // UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
            //            showToast(message: "Login to Continue..", font: .systemFont(ofSize: 12))
            loginScreenAppear()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
            vc.hidesBottomBarWhenPushed = true
            vc.otherUserID = otherUserID
            vc.user_name = obj.username
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func liveBtnAction(_ sender: Any) {
        let userID = UserDefaultsManager.shared.user_id
        
        if userID == "" {
            self.loginScreenAppear()
        }else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "liveUsersVC") as! liveUsersViewController
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @IBAction func skiptnAction(_ sender: Any) {
        if showAdsVideo == false {
            
        }
        let visiblePaths = self.homeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell1 = homeVideoCollectionView.cellForItem(at: i) as? HomeScreenCollectionViewCell
            cell1?.bottomView.isHidden = false
            cell1?.rightView.isHidden = false
            cell1?.btnProfile.isHidden = false
            cell1?.imgUserProfile.isHidden = false
            cell1?.btnAdd.isHidden = false
            
        }
     
        homeTabCollectionView.isHidden = false
        
        liveBtn.isHidden = false
        skipBtn.isHidden = true
        self.tabBarController?.tabBar.isHidden = false

    }
    
    @objc func btnMusicPlayer(sender:UIButton){
        
        
        let userID = UserDefaultsManager.shared.user_id //UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
            
            loginScreenAppear()
        }else{
            let obj = videosMainArr[sender.tag]
            print("obj sound_id : ",obj.sound_id)
            
            
            let soundName = obj.soundName
            
            let userImgPath = AppUtility?.detectURL(ipString: obj.videoTHUM)
            let sound_id = obj.sound_id
            
            
            let vc = HomeSoundViewController(nibName: "HomeSoundViewController", bundle: nil)
            vc.sound_id = sound_id
            vc.soundName = soundName
            vc.userImgUrl = userImgPath ?? ""
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated:   true)
        }
        
        
    }
    
    @objc func pauseSongNoti(notification: Notification) {
        if (notification.userInfo?["err"] as? String) != nil {
            print("reloadVid Details Noti")
            
        }else{
            let visiblePaths = self.homeVideoCollectionView.indexPathsForVisibleItems
            for i in visiblePaths  {
                let cell = homeVideoCollectionView.cellForItem(at: i) as? HomeScreenCollectionViewCell
                cell?.pause()
                
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        self.navigationController?.isNavigationBarHidden =  true

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
       
        
        check()
        hideShowObj()
    }
    
   
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let visiblePaths = self.homeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = homeVideoCollectionView.cellForItem(at: i) as? HomeScreenCollectionViewCell
            cell?.pause()
            
        }
    }
    func hideShowObj(){
       
            
//            segmentVideos.isHidden = false

//            btnBack.isHidden = true
        
    }
    //    MARK:- DEVICE CHECKS
    func devicesChecks(){
        if !DeviceType.iPhoneWithHomeButton{
            
            // feedCVtopConstraint.constant = -44
        }
    }
    
    //MARK:- GET USER OWN DETAILS
    func getUserDetails(){
        
        
        ApiHandler.sharedInstance.showOwnDetail(user_id: UserDefaultsManager.shared.user_id) { (isSuccess, response) in
           
            if isSuccess{

                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as? NSDictionary
                    let userObj = userObjMsg?.value(forKey: "User") as! NSDictionary
                
                    let wallet = (userObj.value(forKey: "wallet") as? String)
                    UserDefaultsManager.shared.wallet = wallet ?? "0"
                  
                    
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
    
    
    
    
    var showAdsVideo = true
    func getDataForFeeds(){
        
        if UserDefaultsManager.shared.user_id == ""{
            
        }else{
            self.getUserDetails()

        }
        
    
            
            liveBtn.isHidden = false
            skipBtn.isHidden = true
            
            
            if showAdsVideo == true {
                segmentVideos.isHidden = true
                liveBtn.isHidden = true
                skipBtn.isHidden = false
                self.isLoad = true
                showVideoDetailAd(startPoint: "\(startPoint)")
                
                
                  //self.tabBarController?.tabBar.isHidden = true
            }else {
                homeTabCollectionView.isHidden = false
                liveBtn.isHidden = false
                skipBtn.isHidden = true
                getAllVideos(startPoint: "\(startPoint)")
                 //  self.tabBarController?.tabBar.isHidden = false
            }
            
       
    }
    
    
    //MARK:-API handler
    
    func getAllVideos(startPoint:String){
        
        
        
        var userID = UserDefaultsManager.shared.user_id
        
        if userID == "" || userID == nil{
            userID = ""
        }
        let startingPoint = startPoint
        let deviceID = UserDefaultsManager.shared.deviceID
        
        print("deviceid: ",deviceID)
        //        self.showToast(message: "Loading ...", font: .systemFont(ofSize: 12))
        
        
        ApiHandler.sharedInstance.showRelatedVideos(device_id: deviceID, user_id: userID, starting_point: startingPoint) { (isSuccess, response) in
//            print("res : ",response!)
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    
                    if self.isLoad == false{
                        self.videosMainArr.removeAll()
                        self.videosRelatedArr.removeAll()
                        self.items.removeAll()
                    }

                    
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    
                    for dic in resMsg{
                        let videoDic = dic["Video"] as! NSDictionary
                        let userDic = dic["User"] as! NSDictionary
                        let soundDic = dic["Sound"] as! NSDictionary
                        
                       
                        let promotionDic = videoDic["Promotion"] as? NSDictionary
                        print("promotionDic: ",promotionDic)
                        let actionButton = promotionDic?.value(forKey: "action_button") as? String
                        let audienceId = promotionDic?.value(forKey: "audience_id")
                        let clicks = promotionDic?.value(forKey: "clicks")
                        let coin = promotionDic?.value(forKey: "coin")
                        let destination = promotionDic?.value(forKey: "destination")
                        let destinatioTap = promotionDic?.value(forKey: "destination_tap")
                        let endDatetime = promotionDic?.value(forKey: "end_datetime")
                        let followers = promotionDic?.value(forKey: "followers")
                        let reach = promotionDic?.value(forKey: "reach")
                        let startDatetime = promotionDic?.value(forKey: "start_datetime")
                        let totalReach = promotionDic?.value(forKey: "total_reach")
                        let userId = promotionDic?.value(forKey: "user_id")
                        let videoId = promotionDic?.value(forKey: "video_id")
                        let websiteUrl = promotionDic?.value(forKey: "website_url")
                        
                        
                        
                        print("videoDic: ",videoDic)
                        print("userDic: ",userDic)
                        print("soundDic: ",soundDic)
                        
                        let videoURL = videoDic.value(forKey: "video") as? String
                        let desc = videoDic.value(forKey: "description") as? String
                        let allowComments = videoDic.value(forKey: "allow_comments")
                        let videoUserID = videoDic.value(forKey: "user_id")
                        let videoID = videoDic.value(forKey: "id") as! String
                        let allowDuet = videoDic.value(forKey: "allow_duet")
                        let duetVidID = videoDic.value(forKey: "duet_video_id")
                        
                        //                        not strings
                        let commentCount = videoDic.value(forKey: "comment_count")
                        let likeCount = videoDic.value(forKey: "like_count")
                        let views = videoDic.value(forKey: "view")
                        let repost_count = videoDic.value(forKey: "repost_count")
                        let sound_id = videoDic.value(forKey: "sound_id")
                        
                        let userImgPath = userDic.value(forKey: "profile_pic") as? String
                        let userName = userDic.value(forKey: "username") as? String
                        let followBtn = userDic.value(forKey: "button") as? String
                        let uid = userDic.value(forKey: "id") as? String
                        let verified = userDic.value(forKey: "verified")
                        let followers_count = userDic.value(forKey: "followers_count")
                        let thum1 = videoDic.value(forKey: "thum") as? String
                        let soundName = soundDic.value(forKey: "name")
                        let thum = soundDic.value(forKey: "thum")
                        let promote = videoDic.value(forKey: "promote")
                        let videoObj = videoMainPromotionMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc ?? "", videoURL: videoURL ?? "", videoTHUM: "\(thum ?? "")", videoGIF: "", view: "", section: "", sound_id: "\(sound_id ?? "")", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn ?? "", duetVideoID: "\(duetVidID!)", views: "\(views ?? "")", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: uid ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath  ?? "", role: "", username: userName  ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified!)", followersCount: "\(followers_count ?? "")", soundName: "\(soundName!)", actionButton: actionButton ?? "", audienceId: "\(audienceId ?? "")", clicks: "\(clicks ?? "")", coin: "\(coin ?? "")", destination: "\(destination ?? "")", destinationTap: "\(destinatioTap ?? "")", endDatetime: "\(endDatetime ?? "")", followers: "\(followers ?? "")", reach: "\(reach ?? "")", startDatetime: "\(startDatetime ?? "")", totalReach: "\(totalReach ?? "")", userId: "\(userId ?? "")", videoId: "\(videoId ?? "")", websiteUrl: "\(websiteUrl ?? "")")
                        self.videosRelatedArr.append(videoObj)
                        
                        
                        
                        let vidURL = URL(string: videoURL!)
                        self.items.append(vidURL!)
                        VideoPreloadManager.shared.set(waiting: self.items)
                        
                        self.startIndex = self.videosRelatedArr.count - dic.count
            
                        
                      
                        
                    }
                
                       
                    
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    
                    //                    self.videosMainArr = self.videosRelatedArr
                    self.videosMainArr.append(contentsOf: self.videosRelatedArr)
                    //                    self.loaderView.stopAnimating()
                    self.videoEmpty = false
                    
                    if self.startPoint == 0 {
                        self.homeVideoCollectionView.reloadData()
                    }else{
                        var indexPaths = [IndexPath]()
                        for i in self.startIndex..<self.videosMainArr.count {
                            let indexPath = IndexPath(item: i, section: 0)
                            indexPaths.append(indexPath)
                        }
                        self.homeVideoCollectionView.insertItems(at: indexPaths)
                    }
                    
                    
                    

                    print("response@200: ",response!)
                    
                    
                    
                }
                else{
                    self.videoEmpty = true
                }
                
            }else{
                print("response failed: ",response!)
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                //                self.loaderView.stopAnimating()
            }
            
            //            self.loaderView.stopAnimating()
        }
       
    }
    
    
    func showVideoDetailAd(startPoint:String){
        
        
        
        var userID = UserDefaultsManager.shared.user_id
        
        if userID == "" || userID == nil{
            userID = ""
        }
        let startingPoint = startPoint
        let deviceID = UserDefaultsManager.shared.deviceID
        
        
        print("deviceid: ",deviceID)
        //        self.showToast(message: "Loading ...", font: .systemFont(ofSize: 12))
        
        
        ApiHandler.sharedInstance.showVideoDetailAd(user_id: userID) { (isSuccess, response) in
            print("res : ",response!)
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    
                    if startPoint == "0"{
                        self.videosMainArr.removeAll()
                    }
                    self.videosRelatedArr.removeAll()
                    
                    let dic = response?.value(forKey: "msg") as! NSDictionary
                    
                    //                    for dic in resMsg{
                    let videoDic = dic["Video"] as! NSDictionary
                    let userDic = dic["User"] as! NSDictionary
                    let soundDic = dic["Sound"] as! NSDictionary
                    
                   
                    let promotionDic = videoDic["Promotion"] as? NSDictionary
                    print("promotionDic: ",promotionDic)
                    let actionButton = promotionDic?.value(forKey: "action_button") as? String
                    let audienceId = promotionDic?.value(forKey: "audience_id")
                    let clicks = promotionDic?.value(forKey: "clicks")
                    let coin = promotionDic?.value(forKey: "coin")
                    let destination = promotionDic?.value(forKey: "destination")
                    let destinatioTap = promotionDic?.value(forKey: "destination_tap")
                    let endDatetime = promotionDic?.value(forKey: "end_datetime")
                    let followers = promotionDic?.value(forKey: "followers")
                    let reach = promotionDic?.value(forKey: "reach")
                    let startDatetime = promotionDic?.value(forKey: "start_datetime")
                    let totalReach = promotionDic?.value(forKey: "total_reach")
                    let userId = promotionDic?.value(forKey: "user_id")
                    let videoId = promotionDic?.value(forKey: "video_id")
                    let websiteUrl = promotionDic?.value(forKey: "website_url")
                    
                    
                    
                    print("videoDic: ",videoDic)
                    print("userDic: ",userDic)
                    print("soundDic: ",soundDic)
                    
                    let videoURL = videoDic.value(forKey: "video") as? String
                    let desc = videoDic.value(forKey: "description") as? String
                    let allowComments = videoDic.value(forKey: "allow_comments")
                    let videoUserID = videoDic.value(forKey: "user_id")
                    let videoID = videoDic.value(forKey: "id") as! String
                    let allowDuet = videoDic.value(forKey: "allow_duet")
                    let duetVidID = videoDic.value(forKey: "duet_video_id")
                    
                    //                        not strings
                    let commentCount = videoDic.value(forKey: "comment_count")
                    let likeCount = videoDic.value(forKey: "like_count")
                    let views = videoDic.value(forKey: "view")
                    let repost_count = videoDic.value(forKey: "repost_count")
                    let sound_id = videoDic.value(forKey: "sound_id")
                    
                    let userImgPath = userDic.value(forKey: "profile_pic") as? String
                    let userName = userDic.value(forKey: "username") as? String
                    let followBtn = userDic.value(forKey: "button") as? String
                    let uid = userDic.value(forKey: "id") as? String
                    let verified = userDic.value(forKey: "verified")
                    let followers_count = userDic.value(forKey: "followers_count")
                    let thum1 = videoDic.value(forKey: "thum") as? String
                    let soundName = soundDic.value(forKey: "name")
                    let thum = soundDic.value(forKey: "thum")
                    let promote = videoDic.value(forKey: "promote")
                    let videoObj = videoMainPromotionMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc ?? "", videoURL: videoURL ?? "", videoTHUM: "\(thum ?? "")", videoGIF: "", view: "", section: "", sound_id: "\(sound_id ?? "")", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn ?? "", duetVideoID: "\(duetVidID!)", views: "\(views ?? "")", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: uid ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath  ?? "", role: "", username: userName  ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified!)", followersCount: "\(followers_count ?? "")", soundName: "\(soundName!)", actionButton: actionButton ?? "", audienceId: "\(audienceId ?? "")", clicks: "\(clicks ?? "")", coin: "\(coin ?? "")", destination: "\(destination ?? "")", destinationTap: "\(destinatioTap ?? "")", endDatetime: "\(endDatetime ?? "")", followers: "\(followers ?? "")", reach: "\(reach ?? "")", startDatetime: "\(startDatetime ?? "")", totalReach: "\(totalReach ?? "")", userId: "\(userId ?? "")", videoId: "\(videoId ?? "")", websiteUrl: "\(websiteUrl ?? "")")
                    self.videosRelatedArr.append(videoObj)
                    self.getAllVideos(startPoint: "\(startPoint)")
                    
                
                    
                    //                    }
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    
                    //                    self.videosMainArr = self.videosRelatedArr
                    //                    self.videosMainArr.append(contentsOf: self.videosRelatedArr)
                    //                    self.loaderView.stopAnimating()
                    self.videoEmpty = false
                     self.homeVideoCollectionView.reloadData()
                    print("response@200: ",response!)
                }
                else{
                    self.videoEmpty = true
                    self.showAdsVideo = false
                    self.getAllVideos(startPoint: "\(startPoint)")
                }
                
            }else{
                print("response failed: ",response!)
                
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                //                self.loaderView.stopAnimating()
            }
            
            //            self.loaderView.stopAnimating()
        }
    }
    
    
    func WatchVideo(video_id:String){
        
        var userID = UserDefaultsManager.shared.user_id
        
        if userID == "" || userID == nil{
            userID = ""
        }
        let deviceID = UserDefaultsManager.shared.deviceID
        
        print("deviceid: ",deviceID)
        //        self.showToast(message: "Loading ...", font: .systemFont(ofSize: 12))
        
        ApiHandler.sharedInstance.watchVideo(device_id: deviceID,video_id:video_id) { (isSuccess, response) in
            
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    print(" WatchVideo response@200: ",response!)
                }
                else{
                    print("WatchVideo response@201: ",response!)
                }
                
            }else{
                print("response failed: ",response!)
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
            }
            
        }
    }
    
    func rePostVideo(){
        
        var userID = UserDefaultsManager.shared.user_id
        
        if userID == "" || userID == nil{
            userID = ""
        }
        let deviceID = UserDefaultsManager.shared.deviceID
        let vidID = videoID
        print("deviceid: ",deviceID)
        //        self.showToast(message: "Loading ...", font: .systemFont(ofSize: 12))
        
        ApiHandler.sharedInstance.rePostVideo(repost_user_id:userID,video_id:vidID,repost_comment:"") { (isSuccess, response) in
            print("res : ",response!)
            
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    print(" RepostVideo response@200: ",response!)
                    self.showToast(message: "Video reposted Successfully", font: .systemFont(ofSize: 12))
                }
                else{
                    print("RepostVideo response@201: ",response!)
                    let msg = response?["msg"] as? String
                    self.showToast(message: msg ?? "", font: .systemFont(ofSize: 12))
                }
                
            }else{
                print("response failed: ",response!)
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
            }
            
        }
    }
    
    var ccuser_id = ""
    func getVideoDetails(ip:IndexPath){
        videoDetail.removeAll()
        
        var uid = UserDefaultsManager.shared.user_id
        
        if uid == nil || uid == ""{
            uid = ""
        }
        
        //        if userVideoArr.isEmpty == false || discoverVideoArr.isEmpty == false{
        //            uid = UserDefaultsManager.shared.otherUserID
        //        }
        //
        
        
        ApiHandler.sharedInstance.showVideoDetail(user_id: uid, video_id: self.videoID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let resMsg = response?.value(forKey: "msg") as! NSDictionary
                    
                    let videoDic = resMsg.value(forKey: "Video") as! NSDictionary
                    let userDic = resMsg.value(forKey: "User") as! NSDictionary
                    let soundDic = resMsg.value(forKey: "Sound") as! NSDictionary
                    
                    print("videoDic: ",videoDic)
                    print("userDic: ",userDic)
                    print("soundDic: ",soundDic)
                    
                    let likeCount = videoDic.value(forKey: "like_count")
                    let commentCount = videoDic.value(forKey: "comment_count")
                    let like = videoDic.value(forKey: "like")
                    let favourite = videoDic.value(forKey: "favourite")
                    let thum1 = videoDic.value(forKey: "thum") as? String
                  
                   
                    self.ccuser_id = videoDic.value(forKey: "user_id") as! String
                    //  let repost_count = videoDic.value(forKey: "repost_count")
                    
                    let cell = self.homeVideoCollectionView.cellForItem(at: ip) as? HomeScreenCollectionViewCell
                    //                cell?.playerView.pause()
                    //                cell?.pause()
                    cell?.lblLikeCount.text = "\(likeCount!)"
                    cell?.lblCommentCount.text = "\(commentCount!)"
                    
                    print("favourite",favourite)
                    
                    print("userDic",userDic)

                    
                    let followBtn = userDic.value(forKey: "button") as? String ?? ""
                    
                    if uid != ""{
                        print("followBtn",followBtn)
                        if followBtn == "follow" {
                            //            cell.btnFollow.setTitle("UnFollow", for: .normal)
                            //                            cell?.btnAdd.isHidden = false
                            //                            if self.showAdsVideo == true {
                            //                                cell?.btnAdd.isHidden = true
                            //                            }else {
                            //                                cell?.btnAdd.isHidden = false
                            //                            }
                        }else{
                                                        cell?.btnAdd.isHidden = true
                            //            cell.btnFollow.setTitle("Follow", for: .normal)
                        }
                        
                    }
                    
                    
                    
                    let fav = "\(favourite!)"
                    
                    if fav == "1"{
                        cell?.alreadyFavourite()
                    }else {
                        cell?.heartAnimationView?.removeFromSuperview()
                    }
                    
                    print("fav ",fav)
                    let liked = "\(like!)"
                    if liked == "1"{
                        //                            cell?.like()
                        cell?.alreadyLiked()
                        
                    }else{
                        cell?.heartAnimationView?.removeFromSuperview()
                    }
                    print("likedd: ",like!)
                    
                    let vidDetail = videoDetailMVC(vidLikes: "\(likeCount!)", vidComments: "\(commentCount!)", isLike: "\(like!)", thum: "\(thum1)")
                    
                    self.videoDetail.append(vidDetail)
                    
                }
            }
            
        }
        
    }
    
    
    
    func likeVideo(uid:String,ip:IndexPath){
        
        let vidID = videoID
        ApiHandler.sharedInstance.likeVideo(user_id: uid, video_id: vidID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    print("likeVideo response msg: ",response?.value(forKey: "msg"))
                    
                    let like = response?.value(forKey: "like") as! NSNumber
                    
                    let like_count = response?.value(forKey: "like_count") as! NSNumber
                    
                    let cell = self.homeVideoCollectionView.cellForItem(at: ip) as? HomeScreenCollectionViewCell
                    //                cell?.playerView.pause()
                    //                cell?.pause()
                    cell?.lblLikeCount.text = "\(like_count)"
                    
                    if like == 1 {
                        cell?.alreadyLiked()
                    }else {
                        cell?.heartAnimationView?.removeFromSuperview()
                    }
                    
                    //                    if let msg = response?.value(forKey: "msg") as? String {
                    //                        self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12.0))
                    //
                    //                    }else {
                    //
                    //                    }
                    //                    let resMsg = response?.value(forKey: "msg") as! NSDictionary
                    //
                    //                    let videoDic = resMsg.value(forKey: "Video") as! NSDictionary
                    //                    let userDic = resMsg.value(forKey: "User") as! NSDictionary
                    ////                    let soundDic = resMsg.value(forKey: "Sound") as! NSDictionary
                    //
                    //                    print("videoDic: ",videoDic)
                    //                    print("userDic: ",userDic)
                    ////                    print("soundDic: ",soundDic)
                    //
                    //                    let likeCount = videoDic.value(forKey: "like_count")
                    ////                    let commentCount = videoDic.value(forKey: "comment_count")
                    ////                    let like = videoDic.value(forKey: "like")
                    //                    let repost_count = videoDic.value(forKey: "repost_count")
                    //
                    //                    let cell = self.homeVideoCollectionView.cellForItem(at: ip) as? HomeScreenCollectionViewCell
                    //                    //                cell?.playerView.pause()
                    //                    //                cell?.pause()
                    //                    cell?.lblLikeCount.text = "\(likeCount!)"
                    ////                    cell?.lblCommentCount.text = "\(commentCount!)"
                    ////                    cell?.repost_count.text = "\(repost_count ?? "")"
                    ////                    let liked = "\(like!)"
                    //                    if liked == "1"{
                    //                        //                            cell?.like()
                    //                        cell?.alreadyLiked()
                    //
                    //                    }else{
                    //                        cell?.heartAnimationView?.removeFromSuperview()
                    //                    }
                    //                        print("likedd: ",like!)
                    
                }else{
                    print("likeVideo response msg: ",response?.value(forKey: "msg"))
                }
            }
            
        }
    }
    var currentVideoUrl = ""
    func getVideoDownloadURL(){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.downloadVideo(video_id: videoID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let currentUrl =  response?.value(forKey: "msg") as! String
                    self.currentVideoUrl = (AppUtility?.detectURL(ipString: currentUrl))!
                    self.downloadVideo()
                    
                    print(response?.value(forKey: "msg"))
                    
                }else{
                    print("!2200: ",response as Any)
                }
            }
        }
    }
    
    //    MARK:- SAVE VIDEO SETUP
    func downloadVideo() {
        print("current url: ",currentVideoUrl)
        self.saveVideoToAlbum((AppUtility?.detectURL(ipString: currentVideoUrl))!) { (error) in
            
            print("err: ",error)
            if error == nil{
                
            }
            
        }
    }
    //    MARK:- DOWNLOAD API
    func downloadAPI(){
        
        ApiHandler.sharedInstance.deleteWaterMarkVideo(video_url: currentVideoUrl) { (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                print("respone: ",response?.value(forKey: "msg"))
                
            }else{
                print("!200: ",response as Any)
            }
            
        }
        
    }
    
    func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
    }
    
    func saveVideoToAlbum(_ vidUrlString: String, _ completion: ((Error?) -> Void)?) {
        requestAuthorization {
            //            self.showToast(message: "Video saved!", font: .systemFont(ofSize: 12))
            DispatchQueue.global(qos: .background).async {
                if let url = URL(string: vidUrlString),
                   let urlData = NSData(contentsOf: url) {
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                    let filePath="\(documentsPath)/tempFile.mp4"
                    DispatchQueue.main.async {
                        urlData.write(toFile: filePath, atomically: true)
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                        }) { completed, error in
                            if completed {
                                
                                self.downloadAPI()
                                DispatchQueue.main.async { // Correct
                                    
                                    self.dismiss(animated: true)
                                }
                                
                                print("Video is saved!")
                                
                                //                                self.showToast(message: "Video saved!", font: .systemFont(ofSize: 12))
                            }else{
                                
                                //                                self.showToast(message: error as! String, font: .systemFont(ofSize: 12))
                                
                                self.dismiss(animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func tapGesturesFunc(){
        
        
        
         let singleTapGR = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleSingleTap(_:)))
         singleTapGR.delegate = self
         singleTapGR.numberOfTapsRequired = 1
         homeVideoCollectionView.addGestureRecognizer(singleTapGR)

     
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gesture:)))
        doubleTapGR.delegate = self
        doubleTapGR.numberOfTapsRequired = 2
        homeVideoCollectionView.addGestureRecognizer(doubleTapGR)
        singleTapGR.require(toFail: doubleTapGR)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.delegate = self
        homeVideoCollectionView.addGestureRecognizer(longPressRecognizer)
        
        
    }
    
}

extension HomeViewController:UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == homeTabCollectionView{
            return userItem.count
        }else{
            return videosMainArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == homeTabCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeTabCollectionViewCell", for: indexPath) as! homeTabCollectionViewCell
            
            if indexPath.row == 0 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.lineView.isHidden  = true
                    cell.lblHome.text = self.userItem[indexPath.row]["title"]!
                   
                }else{
                    
                    cell.lineView.isHidden  = false
                    cell.lblHome.text = self.userItem[indexPath.row]["title"]!
                   
                }
            }
            
            if indexPath.row == 1 {
                if self.userItem[indexPath.row]["isSelected"] == "false"{
                    cell.lineView.isHidden  = true
                    cell.lblHome.text = self.userItem[indexPath.row]["title"]!
                }else{
                    cell.lineView.isHidden  = false
                    cell.lblHome.text = self.userItem[indexPath.row]["title"]!
                   
                }
            }
        
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeScreenCollectionViewCell", for: indexPath) as! HomeScreenCollectionViewCell
            
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                    case 1136:
                        print("iPhone 5 or 5S or 5C")
                    
                    case 1334:
                        print("iPhone 6/6S/7/8")
                    
                    case 1920, 2208:
                        print("iPhone 6+/6S+/7+/8+")
                    cell.bottomViewConstant.constant = 55
                    cell.progressViewBottomConstr.constant = 45
                    
                    case 2436:
                        print("iPhone X/XS/11 Pro")
                    cell.bottomViewConstant.constant = 90
                    cell.progressViewBottomConstr.constant = 80
                    
                    
                    case 2688:
                        print("iPhone XS Max/11 Pro Max")
                    cell.bottomViewConstant.constant = 90
                    cell.progressViewBottomConstr.constant = 80
                    
                    case 1792:
                        print("iPhone XR/ 11 ")
                    cell.bottomViewConstant.constant = 90
                    cell.progressViewBottomConstr.constant = 80
                    
                    default:
                    cell.bottomViewConstant.constant = 90
                    cell.progressViewBottomConstr.constant = 80
                    }
            }else{
                
            }
            if indexPath.row == 0 {
                
                homeVideoCollectionView.contentInsetAdjustmentBehavior = .never
            }else {
                homeVideoCollectionView.contentInsetAdjustmentBehavior = .scrollableAxes
            }
            
            if indexPath.row == videosMainArr.count - 1 {
                homeVideoCollectionView.contentInsetAdjustmentBehavior = .scrollableAxes
            }
           
            
            if userVideoArr.isEmpty == false{
                //            cell.btnFollow.isHidden = true
                //            cell.userImg.isUserInteractionEnabled = false
                
            }else{
                //            cell.btnFollow.isHidden = false
                //            cell.userImg.isUserInteractionEnabled = true
            }
            
            if isFollowing == true{
                //            cell.btnFollow.isHidden = true
            }else{
                //            cell.btnFollow.isHidden = false
            }
            
            
            let vidObj = videosMainArr[indexPath.row]
            let vidString = AppUtility?.detectURL(ipString: vidObj.videoURL)
           
            
          
            
            videoID = vidObj.videoID
            
            if showAdsVideo == true {
                
            }else{
                if vidObj.promote == "1" &&  vidObj.destination != ""{
                    cell.adsStackView.isHidden = false
                    cell.descriptionStackView.isHidden = true
                    
                    if vidObj.description == ""{
                        cell.adsDescriptionStackView.isHidden = true
                       
                    }else{
                        cell.adsDescriptionStackView.isHidden = false
                    }
                    
                    print("vidObj.destination",vidObj.destination)
                    print("vidObj.actionButton",vidObj.actionButton)
                   
                    
                    if vidObj.destination == "website"{
                        cell.btnAds.setTitle(vidObj.actionButton, for: .normal)
                        cell.btnAds.tag = indexPath.row
                        cell.btnAds.addTarget(self, action: #selector(btnWebsiteClick(sender:)), for: .touchUpInside)
                    }else if vidObj.destination == "follower"{
                        cell.btnAds.setTitle(vidObj.actionButton, for: .normal)
                        cell.btnAds.tag = indexPath.row
                        cell.btnAds.addTarget(self, action: #selector(adsButtonPressed(sender:)), for: .touchUpInside)
                    }else{
                        cell.adsBtnStack.isHidden = true
                    }
                    
                }else{
                    cell.adsStackView.isHidden = true
                    cell.descriptionStackView.isHidden = false
                }
                
            }
            
            
            
            
            
            if vidObj.followBtn == "follow" {
                //            cell.btnFollow.setTitle("UnFollow", for: .normal)
                cell.btnAdd.isHidden = false
            }else{
                cell.btnAdd.isHidden = true
                //            cell.btnFollow.setTitle("Follow", for: .normal)
            }
            //        let videoTHUM = AppUtility?.detectURL(ipString: vidObj.videoTHUM)
            
            print("vidString url: ",vidString)
            
            let vidURL = URL(string: vidString!)
            
            let vidDesc = vidObj.description
            let count = Int("\(vidObj.comment_count)")?.roundedWithAbbreviations
            print(count)
            let commentCount = Int("\(vidObj.comment_count)")?.roundedWithAbbreviations //vidObj.comment_count
            let likeCount = Int("\(vidObj.like_count)")?.roundedWithAbbreviations //vidObj.like_count
            let views = Int("\(vidObj.views)")?.roundedWithAbbreviations //vvidObj.views //
            let soundName = vidObj.soundName
            
            let userImgPath = AppUtility?.detectURL(ipString: vidObj.userProfile_pic)
            let userImgUrl = URL(string: userImgPath!)
            let userThumbImgPath = AppUtility?.detectURL(ipString: vidObj.videoTHUM)
            let userThumbImgUrl = URL(string: userThumbImgPath!)
            let userName = vidObj.username
            giftName = vidObj.username
            let repostCount = Int("\(vidObj.repostCount)")?.roundedWithAbbreviations // vidObj.repostCount
            self.name = vidObj.username
            let followersCount = "\(vidObj.followersCount)"
            let getUserLevel = AppUtility?.getUserLevel(CounyValue: followersCount)
            
            
            if vidObj.verified == "0"{
                cell.verifiedUserImg.isHidden = true
                cell.verifiedAdsUserImage.isHidden = true
                
            }else{
                cell.verifiedUserImg.isHidden = false
                cell.verifiedAdsUserImage.isHidden = false
            }
           
            //        if vidObj.promote == "1"{
            //            cell.voteStack.isHidden = true
            //            cell.paidStackVie.isHidden = false
            //        }
            
            let duetVidID = vidObj.duetVideoID
            if duetVidID != "0"{
                cell.videoView.contentMode = .scaleAspectFill
            }else{
                cell.videoView.contentMode = .scaleAspectFill
            }
            print("CommentCount: ",commentCount)
            cell.set(url: vidURL!)
            
          
            cell.txtDesc.setText(text: vidDesc,textColor: .white, withHashtagColor: .white, andMentionColor: .white, andCallBack: { (strng, type) in
                print("type: ",type)
                print("strng: ",strng)
                
                
                switch type{
                case .hashtag:
                    
                    let vc = hashtagsVideoViewController(nibName: "hashtagsVideoViewController", bundle: nil)
                    vc.hashtag = strng
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .mention:
                    break
                }
                
            }, normalFont: .systemFont(ofSize: 12, weight: UIFont.Weight.medium), hashTagFont: .systemFont(ofSize: 12, weight: UIFont.Weight.bold), mentionFont: .systemFont(ofSize: 12, weight: UIFont.Weight.bold))
            
            cell.txtDescAds.setText(text: vidDesc,textColor: .white, withHashtagColor: .white, andMentionColor: .white, andCallBack: { (strng, type) in
                print("type: ",type)
                print("strng: ",strng)
                
                
                switch type{
                case .hashtag:
                    
                    let vc = hashtagsVideoViewController(nibName: "hashtagsVideoViewController", bundle: nil)
                    vc.hashtag = strng
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    break
                case .mention:
                    break
                }
                
            }, normalFont: .systemFont(ofSize: 12, weight: UIFont.Weight.medium), hashTagFont: .systemFont(ofSize: 12, weight: UIFont.Weight.bold), mentionFont: .systemFont(ofSize: 12, weight: UIFont.Weight.bold))
            
            
            cell.lblCommentCount.text = commentCount
            cell.lblLikeCount.text = likeCount
            
            cell.userName.text = "\(userName)"
            giftName = cell.userName.text ?? ""
            cell.lblAdsUsername.text = "\(userName)"
           
            cell.musicName.text = soundName
            cell.musicName.type = .continuousReverse
            
            
            
            
            
    //        let contentSize = cell.txtDesc.sizeThatFits(CGSize(width: cell.txtDesc.frame.width, height: CGFloat.greatestFiniteMagnitude))
    //        let paddingHeight = cell.txtDesc.textContainerInset.top + cell.txtDesc.textContainerInset.bottom + cell.txtDesc.contentInset.top + cell.txtDesc.contentInset.bottom + cell.txtDesc.layoutMargins.top + cell.txtDesc.layoutMargins.bottom
    //
    //        let requiredHeight = contentSize.height + paddingHeight
    //        print("Exact height of UITextView is: \(requiredHeight)")
    //
    //        cell.bottomViewHeight.constant = 100
    //
    //        cell.bottomViewHeight.constant += requiredHeight - 90
          
            
            
            // add shedow on lable text
            cell.userName.textDropShadow()
            cell.musicName.textDropShadow()
            cell.saveLabel.textDropShadow()
            
            cell.shareLabel.textDropShadow()
            cell.lblCommentCount.textDropShadow()
            cell.lblLikeCount.textDropShadow()
            
            
            
            cell.txtDescAds.layer.shadowColor = UIColor.black.cgColor;
            cell.txtDescAds.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cell.txtDescAds.layer.shadowOpacity = 1.0
            cell.txtDescAds.layer.shadowRadius = 5.0
            cell.txtDescAds.layer.masksToBounds = false
            
            cell.txtDesc.layer.shadowColor = UIColor.black.cgColor;
            cell.txtDesc.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            cell.txtDesc.layer.shadowOpacity = 1.0
            cell.txtDesc.layer.shadowRadius = 5.0
            cell.txtDesc.layer.masksToBounds = false
            //        cell.musicName.animationCurve = .linear
            //        cell.musicName.startLoading()
            
            //        cell.btnProfile.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
            
            print("vidObj.followBtn: ",vidObj.followBtn)
            
          
            
            cell.btnAdd.tag = indexPath.row
            cell.btnAdd.addTarget(self, action: #selector(btnFollowFunc(sender:)), for: .touchUpInside)
            
            cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.height / 2
            cell.imgUserProfile.clipsToBounds = true
            
            cell.playerCD.layer.cornerRadius = cell.playerCD.frame.height / 2
            cell.playerCD.clipsToBounds = true
            
            cell.imgUserProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgUserProfile.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
            cell.imgUserProfile.layer.cornerRadius = cell.imgUserProfile.frame.height / 2.0
            cell.imgUserProfile.layer.masksToBounds = true
            
            cell.playerCD.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.playerCD.sd_setImage(with: userThumbImgUrl, placeholderImage: UIImage(named: "noMusicIcon"))
            
            
            cell.btnUsername.tag = indexPath.row
            cell.btnUsername.addTarget(self, action: #selector(usernameButtonPressed(sender:)), for: .touchUpInside)
            
            cell.btnProfile.tag = indexPath.row
            cell.btnProfile.addTarget(self, action: #selector(btnProfilePressed(sender:)), for: .touchUpInside)
            
            cell.btnAdsUsername.tag = indexPath.row
            cell.btnAdsUsername.addTarget(self, action: #selector(btnProfilePressed(sender:)), for: .touchUpInside)
            
            cell.showSoundBtn.tag = indexPath.row
            cell.showSoundBtn.addTarget(self, action: #selector(btnMusicPlayer(sender:)), for: .touchUpInside)
            
            
            
            //        let gestureMusicPlayer = UITapGestureRecognizer(target: self, action:  #selector(btnMusicPlayer(sender:)))
            //
            //        cell.blackDiskCd.addGestureRecognizer(gestureMusicPlayer)
            
            let gestureBtnLike = UITapGestureRecognizer(target: self, action:  #selector(self.btnLikeTapped(sender:)))
            cell.btnLike.tag = indexPath.row
            cell.btnLike.isUserInteractionEnabled = true
            cell.btnLike.addGestureRecognizer(gestureBtnLike)
            
            let gestureBtnShare = UITapGestureRecognizer(target: self, action:  #selector(self.btnShareTapped(sender:)))
            cell.btnShare.tag = indexPath.row
            cell.btnShare.isUserInteractionEnabled = true
            cell.btnShare.addGestureRecognizer(gestureBtnShare)
            
            let gestureBtnComment = UITapGestureRecognizer(target: self, action:  #selector(self.btnCommentTapped(sender:)))
            cell.btnComment.tag = indexPath.row
            cell.btnComment.isUserInteractionEnabled = true
            cell.btnComment.addGestureRecognizer(gestureBtnComment)
            
            let gestureBtnGift = UITapGestureRecognizer(target: self, action:  #selector(self.btnGiftTapped(sender:)))
            cell.giftBtn.tag = indexPath.row
            cell.giftBtn.isUserInteractionEnabled = true
            cell.giftBtn.addGestureRecognizer(gestureBtnGift)
            
            
            let gestureBtnHashtag = UITapGestureRecognizer(target: self, action:  #selector(self.hashtagButtonPressed(sender:)))
            cell.btnHashtag.tag = indexPath.row
            cell.btnHashtag.isUserInteractionEnabled = true
            cell.btnHashtag.addGestureRecognizer(gestureBtnHashtag)
            
            
            cell.btnSave.tag = indexPath.row
            cell.btnSave.addTarget(self, action: #selector(SaveVideoFunc(sender:)), for: .touchUpInside)
            
            
            
            return cell
            
            
        }
       
    }
    
    // Create a function to update the video progress periodically
    func startProgressUpdateTimer(promote:String,destination:String,desc:String,websiteUrl:String,actionButton:String,profileImage:String,userName:String) {
    
        progressUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            // This block will be executed every 1 second (adjust the interval as needed)
            guard let self = self else { return }
            let visibleIndexPaths = self.homeVideoCollectionView.indexPathsForVisibleItems
            for indexPath in visibleIndexPaths {
                if let cell = self.homeVideoCollectionView.cellForItem(at: indexPath) as? HomeScreenCollectionViewCell {
                    
                    let progress = Float(cell.videoView.currentDuration)
                    let total = Float(cell.videoView.totalDuration)
                    let progressPercentage = total - progress
                    let number = Int(progressPercentage)
//                    print("Current progress: \(Int(progressPercentage))")
                    if number == 0 {
                        if promote == "1" && destination != ""{
                            cell.videoView.isAutoReplay = false
                            cell.videoView.pause(reason: .userInteraction)
                            self.stopProgressUpdateTimer()
                            cell.adsBackView.isHidden = false
                            cell.btnPlayImg.isUserInteractionEnabled = false
                            
                            cell.lblAdsName.text = userName
                            let vidURL = URL(string: profileImage)
                            
                            cell.adsBackImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                            cell.adsBackImageView.sd_setImage(with: vidURL, placeholderImage: UIImage(named: "noUserImg"))
                            
                            cell.adsTextView.text = desc
                            
                            if destination == "website"{
                                cell.adsBtnUrl.setTitle(actionButton, for: .normal)
                                cell.adsBtnUrl.tag = indexPath.row
                                cell.adsBtnUrl.addTarget(self, action: #selector(self.btnWebsiteClick(sender:)), for: .touchUpInside)
                            }else if destination == "follower"{
                                cell.adsBtnUrl.setTitle(actionButton, for: .normal)
                                cell.adsBtnUrl.tag = indexPath.row
                                cell.adsBtnUrl.addTarget(self, action: #selector(self.adsButtonPressed(sender:)), for: .touchUpInside)
                            }else{
                                cell.adsStackViewUrl.isHidden = true
                            }
                            
                            cell.btnReplay.tag = indexPath.row
                            cell.btnReplay.addTarget(self, action: #selector(self.adsReplayButtonPressed(sender:)), for: .touchUpInside)
                            
                        }
                    }else{
                        
                    }
                   
 
                }
            }
        }
    }
    
    @objc func adsReplayButtonPressed(sender: UIButton){
        print(sender.tag)
        let cell = self.homeVideoCollectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? HomeScreenCollectionViewCell
        cell?.videoView.isAutoReplay = true
        cell?.adsBackView.isHidden = true
        cell?.videoView.resume()
        
        let vidObj = videosMainArr[sender.tag]
        
        startProgressUpdateTimer(promote: vidObj.promote, destination: vidObj.destination,desc:vidObj.description,websiteUrl:vidObj.websiteUrl,actionButton:vidObj.actionButton,profileImage:vidObj.userProfile_pic,userName:vidObj.username)
        cell?.btnPlayImg.isUserInteractionEnabled = true
        
    }
    
    
    
    func stopProgressUpdateTimer() {
        progressUpdateTimer?.invalidate()
        progressUpdateTimer = nil
    }
    
    
    @objc func adsButtonPressed(sender: UIButton){
        print(sender.tag)
        
        let obj = videosMainArr[sender.tag]
        
        let otherUserID = obj.userId
        let userID = UserDefaultsManager.shared.user_id // UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
            //            showToast(message: "Login to Continue..", font: .systemFont(ofSize: 12))
            loginScreenAppear()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
            vc.hidesBottomBarWhenPushed = true
            vc.otherUserID = otherUserID
            vc.user_name = name
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @objc func SaveVideoFunc(sender: UIButton){
        let buttonTag = sender.tag
        self.getVideoDownloadURL()
    }
    
    
    @objc func hashtagButtonPressed(sender: UITapGestureRecognizer){
        let cell = self.homeVideoCollectionView.cellForItem(at: IndexPath(row: sender.view!.tag, section: 0)) as? HomeScreenCollectionViewCell
        let userID = UserDefaultsManager.shared.user_id
        if userID != "" && userID != nil{
            
            if cell?.isFavourite == false{
                cell?.favourite()
                self.addFavAPI(sender:self.currentVidIP)
                // self.getVideoDetails(ip: currentVidIP)
            }else{
                cell?.unFavourite()
                self.addFavAPI(sender:self.currentVidIP)
                //  self.getVideoDetails(ip: currentVidIP)
            }
            
            
        }else{
            
            loginScreenAppear()
        }
    }
    
    
    //MARK:- ADD FAV API
    
    func addFavAPI(sender:IndexPath){
        
        ApiHandler.sharedInstance.addVideoFavourite(video_id: videoID, user_id: UserDefaultsManager.shared.user_id) { (isSuccess, response) in
            
            
            
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print(response?.value(forKey: "msg"))
                    
                    let msg = response?.value(forKey: "msg") as? String
                    print("msg",msg)
                    guard msg != "unfavourite" else {
                        return
                    }
                    
                    
                    
                }else{
                    print(response?.value(forKey: "msg"))
                }
            }
        }
    }
    
    
    @objc func btnWebsiteClick(sender : UIButton){
        print(sender.tag)
        let obj = videosMainArr[sender.tag]
        
        let website = obj.websiteUrl
        print("obj.actionButton",obj.websiteUrl)
        openURLInBrowser(obj.websiteUrl);
     
       
    }
    
    func openURLInBrowser(_ urlString: String) {
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    
    @objc func btnFollowFunc(sender : UIButton){
        print(sender.tag)
        
        let uid = UserDefaultsManager.shared.user_id
        if uid == "" || uid == nil{
            //  showToast(message: "Please Login..", font: .systemFont(ofSize: 12.0))
            loginScreenAppear()
        }else{
            followUserFunc(cellNo: sender.tag)
            print("sender.currentTitle: ",sender.currentTitle)
            
            if sender.currentTitle == "UnFollow"{
                sender.setTitle("Follow", for: .normal)
            }else{
                sender.setTitle("UnFollow", for: .normal)
            }
            
        }
    }
    
    @objc func btnLikeTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        print("btn like : \(sender.view?.tag)")
        
        let cell = self.homeVideoCollectionView.cellForItem(at: IndexPath(row: sender.view!.tag, section: 0)) as? HomeScreenCollectionViewCell
        
        let userID = UserDefaultsManager.shared.user_id
        if userID != ""{
            if cell?.isLiked == false{
                cell?.like()
                self.likeVideo(uid:userID,ip: currentVidIP)
                // self.getVideoDetails(ip: currentVidIP)
            }else{
                cell?.unlike()
                self.likeVideo(uid:userID,ip: currentVidIP)
                //  self.getVideoDetails(ip: currentVidIP)
            }
        }else{
            loginScreenAppear()
        }
    }
    @objc func btnShareTapped(sender : UITapGestureRecognizer) {
        let obj = videosMainArr[sender.view!.tag]
        print("obj.userID",obj.userID)
        let vc = ShareToViewController(nibName: "ShareToViewController", bundle: nil)
        vc.videoID = videoID
        vc.objToShare.removeAll()
        // vc.videoRepostCount = videoObj.repostCount
        //vc.repostDelegate = self
        vc.objToShare.append(videoURL)
        vc.currentVideoUrl = videoURL
        vc.userID = obj.userID
        vc.NotInterstedDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true)
        
    }
    @objc func btnCommentTapped(sender : UITapGestureRecognizer) {
        // Do what you want
        
        print("btn comment : \(sender.view?.tag)")
        
        print("user img : \(sender.view?.tag)")
        
        let obj = videosMainArr[sender.view!.tag]
        print("obj user id : ",obj.userID)
        
        //        let obj = self.friends_array[sender.view!.tag] as! Home
        //        self.video_id = obj.v_id
        
        
        let otherUserID = obj.userID
        let userID = UserDefaultsManager.shared.user_id //UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
            
            loginScreenAppear()
        }else{
            let myViewController = CommentViewController(nibName: "CommentViewController", bundle: nil)
            
            myViewController.Video_Id = videoID //video_id!
            // myViewController.modalPresentationStyle = .overFullScreen
            myViewController.commentDelegate = self
            let nav = UINavigationController(rootViewController: myViewController)
            nav.modalPresentationStyle = .overFullScreen
            present(nav, animated: true, completion: nil)
        }
        
    }
    @objc func btnGiftTapped(sender : UITapGestureRecognizer) {
        
        if let rootViewController = UIApplication.topViewController() {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc =  storyMain.instantiateViewController(withIdentifier: "CoinShareViewController") as! CoinShareViewController
            vc.modalPresentationStyle = .overFullScreen
            vc.hidesBottomBarWhenPushed = true
            vc.userName = name
            
            vc.callback = { (text,id) -> Void in
                print("string: ",id)
                print("id: ",text)
               
            }
            
            
            rootViewController.navigationController?.isNavigationBarHidden = true
            rootViewController.navigationController?.present(vc, animated: false)
        }


    }
    
    
    func followUserFunc(cellNo:Int){
        let videoObj = videosMainArr[cellNo]
        let rcvrID = ccuser_id
        let userID = UserDefaultsManager.shared.user_id
        
        followUser(rcvrID: rcvrID, userID: userID, cellNo: cellNo)
    }
    
    //    MARK:- Follow user API
    func followUser(rcvrID:String,userID:String,cellNo : Int){
        
        print("Recid: ",rcvrID)
        print("senderID: ",userID)
        
        
        ApiHandler.sharedInstance.followUser(sender_id: userID, receiver_id: rcvrID) { (isSuccess, response) in
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let cell = self.homeVideoCollectionView.cellForItem(at: IndexPath(item: cellNo, section: 0)) as? HomeScreenCollectionViewCell
                    //                cell?.playerView.pause()
                    //                cell?.pause()
                    let userObjMsg = response?.value(forKey: "msg") as! NSDictionary
                    let userObj = userObjMsg.value(forKey: "User") as! NSDictionary
                    let followBtn = (userObj.value(forKey: "button") as? String)!
                    
                    if followBtn == "following" || followBtn == "friends" {
                        cell?.btnAdd.isHidden = true
                        
                    }else {
                        cell?.btnAdd.isHidden = false
                    }
                    
                }else{
                    
                    //                    self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                }
                
            }else{
                
                //                self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
            }
        }
    }
    
    //    MARK:- Login screen will appear func
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
}
//@available(iOS 13.0, *)
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? HomeScreenCollectionViewCell {
            cell.pause()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { check() }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        check()
    }
    
    func check() {
       // checkPreload()
        checkPlay()
    }
    
    func checkPreload() {
        guard let lastRow = homeVideoCollectionView.indexPathsForVisibleItems.last?.row else { return }
        
        let urls = items
            .suffix(from: min(lastRow + 1, items.count))
            .prefix(2)
        
        print("itrems url: ",urls)
        VideoPreloadManager.shared.set(waiting: Array(urls))
        
        //        VideoPlayer.preloadByteCount = 1024 * 1024 // = 1M
        
    }
    
    func checkPlay() {
        let visibleCells = homeVideoCollectionView.visibleCells.compactMap { $0 as? HomeScreenCollectionViewCell }
        
        guard visibleCells.count > 0 else { return }
        
        let visibleFrame = CGRect(x: 0, y: homeVideoCollectionView.contentOffset.y, width: homeVideoCollectionView.bounds.width, height: homeVideoCollectionView.bounds.height)
        
        let visibleCell = visibleCells
            .filter { visibleFrame.intersection($0.frame).height >= $0.frame.height / 2 }
            .first
        
        visibleCell?.play()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == homeTabCollectionView{
            return CGSize(width:homeTabCollectionView.frame.size.width / 2.0 , height: 40)
        }else{
            return CGSize(width:homeVideoCollectionView.frame.width , height: homeVideoCollectionView.frame.height)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == homeTabCollectionView{
            for i in 0..<self.userItem.count {
                var obj  = self.userItem[i]
                obj.updateValue("false", forKey: "isSelected")
                self.userItem.remove(at: i)
                self.userItem.insert(obj, at: i)
                
            }
            
            self.StoreSelectedIndex(index: indexPath.row)
            self.indexSelected =  indexPath.row
            self.storeSelectedIP = indexPath
        }else{
            
            
            
        }
       
    }
    
    @objc func StoreSelectedIndex(index:Int){
        var obj  =  self.userItem[index]
        obj.updateValue("true", forKey: "isSelected")
        self.userItem.remove(at: index)
        self.userItem.insert(obj, at: index)
        print("index",index)
        homeTabCollectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: .centeredVertically)
        
        if index == 0{
            
            let userID = UserDefaultsManager.shared.user_id
            if userID == nil || userID == ""{
                
                loginScreenAppear()
            }else{
                //  print("device key: ",UserDefaults.standard.string(forKey: "deviceKey")!)
                
                self.isLoad = false
                self.isFollowing = true
                getFollowingVideos(startPoint: "0")
            }

         
        }else{
            
          
            self.isLoad = false
            
            self.isFollowing = false
            getAllVideos(startPoint: "0")
            
          

        }
        self.homeTabCollectionView.reloadData()
    }
   
   
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == homeTabCollectionView{
            
        }else{
            
            let cell1 = cell as? HomeScreenCollectionViewCell //{
            
            getVideoDetails(ip: indexPath)
            self.WatchVideo(video_id: videoID)
            //   }
            if showAdsVideo == true {
                
                cell1?.bottomView.isHidden = true
                cell1?.rightView.isHidden = true
                cell1?.btnProfile.isHidden = true
                cell1?.imgUserProfile.isHidden = true
                cell1?.btnAdd.isHidden = true
                
                self.tabBarController?.tabBar.isHidden = true
                
                
                showAdsVideo = false
                
                segmentVideos.isHidden = true
                liveBtn.isHidden = true
                skipBtn.isHidden = false
            }else {
                
                cell1?.bottomView.isHidden = false
                cell1?.rightView.isHidden = false
                cell1?.btnProfile.isHidden = false
                cell1?.imgUserProfile.isHidden = false
                cell1?.btnAdd.isHidden = false
                
                
                homeTabCollectionView.isHidden = false
                liveBtn.isHidden = false
                skipBtn.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
                
                
                
            }
            
            
            
            
            //        if indexPath.row == 0 {
            //
            //        }
            
            
            let vidObj = videosMainArr[indexPath.row]
            videoID = vidObj.videoID
            videoURL = vidObj.videoURL
         
            currentVidIP = indexPath
            stopProgressUpdateTimer()
            startProgressUpdateTimer(promote: vidObj.promote, destination: vidObj.destination,desc:vidObj.description,websiteUrl:vidObj.websiteUrl,actionButton:vidObj.actionButton,profileImage:vidObj.userProfile_pic,userName:vidObj.username)
            
            if let cell = cell as? HomeScreenCollectionViewCell {
                cell.play()
                
                //            if vidObj.promote == "1"{
                //                cell.voteStack.isHidden = true
                //                cell.paidStackVie.isHidden = false
                //            }
                
            }
            print("videoID: \(videoID), videoURL: \(videoURL)")
            
            print("index@row: ",indexPath.row)
            if indexPath.row == videosMainArr.count-1{
                if videoEmpty{
                    self.homeVideoCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
            
            print("index@row: ",indexPath.row)
            if !videoEmpty{
                if indexPath.row == videosMainArr.count - 4{
                    
                    self.startPoint+=1
                    print("StartPoint: ",startPoint)
                    
                    if isFollowing == true{
                        //  self.getFollowingVideos(startPoint: "\(self.startPoint)")
                    }else if userVideoArr.isEmpty == false || discoverVideoArr.isEmpty == false{
                       
                    }else{
                        self.getAllVideos(startPoint: "\(self.startPoint)")
                       
                        
                        
                    }
                    
                    print("index@row: ",indexPath.row)
                    
                }
            }
            
        }
            
        }
        
}
//@available(iOS 13.0, *)
extension HomeViewController: UIGestureRecognizerDelegate {
    @objc func handleSingleTap(_ gesture: UITapGestureRecognizer){
        print("singletapped")
        StaticData.obj.isSingle = false
        let visiblePaths = self.homeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = homeVideoCollectionView.cellForItem(at: i) as? HomeScreenCollectionViewCell
            //                cell?.playerView.pause()
            //                cell?.pause()
            
            if cell!.videoView.state == .playing {
                cell!.videoView.pause(reason: .userInteraction)
               
                //                cell!.btnPlayImg.isHidden = false
            } else {
                //                cell!.btnPlayImg.isHidden = true
                cell!.videoView.resume()
               
            }
            
        }
    }
    
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer){
        print("doubletapped")
        let visiblePaths = self.homeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = homeVideoCollectionView.cellForItem(at: i) as? HomeScreenCollectionViewCell
            let userID = UserDefaultsManager.shared.user_id
            if userID != ""{
                
                let location = gesture.location(in: cell?.videoView)
                let heartView = UIImageView(image: UIImage(systemName: "heart.fill"))
                heartView.tintColor = .red
                let width : CGFloat = 110
                heartView.contentMode = .scaleAspectFit
                heartView.frame = CGRect(x: location.x - width / 2, y: location.y - width / 2, width: width, height: width)
                heartView.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -CGFloat.pi * 0.2...CGFloat.pi * 0.2))
                cell?.videoView.addSubview(heartView)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
                    heartView.transform = heartView.transform.scaledBy(x: 0.85, y: 0.85)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
                        heartView.transform = heartView.transform.scaledBy(x: 2.3, y: 2.3)
                        heartView.alpha = 0
                    }, completion: { _ in
                        heartView.removeFromSuperview()
                    })
                })
                
                if cell?.isLiked == false{
                    
                    cell?.like()
                    self.likeVideo(uid:userID,ip: currentVidIP)
                }else{
                    
                    
//                    cell?.unlike()
//                    self.likeVideo(uid:userID,ip: currentVidIP)
                }
            }else{
                loginScreenAppear()
            }
        }
    }
    
    @objc func handleLongPress(_ gesture: UITapGestureRecognizer){
        print("long press")
        
        let visiblePaths = self.homeVideoCollectionView.indexPathsForVisibleItems
        print("currentVidIP.row",currentVidIP.row)
        let videoObj = videosMainArr[currentVidIP.row]
        let rcvrID = videoObj.videoUserID
        
        //        let myViewController = AddSoundViewController(nibName: "AddSoundViewController", bundle: nil)
        //        myViewController.modalPresentationStyle = .fullScreen
        //
        //        self.navigationController?.present(myViewController, animated: true, completion: nil)
        
        let vc = VideoPopViewController(nibName: "VideoPopViewController", bundle: nil)
        vc.videoID = videoID
        vc.currentVideoUrl = videoURL
        vc.receiverID = rcvrID
        vc.NotInterstedDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        
        self.present(nav, animated: false, completion: nil)
        
    }
    
    
    //    Mark:- On audio on mute button
    func setupAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        _ = try? audioSession.setCategory(AVAudioSession.Category.playback)
        _ = try? audioSession.setActive(true)
        
    }
    
    func remove(index: Int) {
        videosMainArr.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        homeVideoCollectionView.performBatchUpdates({
            self.homeVideoCollectionView.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
            self.homeVideoCollectionView.reloadItems(at: self.homeVideoCollectionView.indexPathsForVisibleItems)
        })
    }
}
