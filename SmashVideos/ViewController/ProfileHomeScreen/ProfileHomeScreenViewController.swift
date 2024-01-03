//
//  ProfileHomeScreenViewController.swift
//  SmashVideos
//
//  Created by Mac on 24/01/2023.
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

class ProfileHomeScreenViewController: UIViewController ,InternetStatusIndicable, NotInterstedDelegate,/*RepostDelegate*/ CommentCountUpdateDelegate {
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
                    
                    let cell = self.profileHomeVideoCollectionView.cellForItem(at: self.currentVidIP) as? ProfileHomeScreenCollectionViewCell
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
    
    //MARK:- OUTLET
    
    @IBOutlet weak var profileHomeVideoCollectionView: UICollectionView!
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var btnBack: UIButton!
    var videosMainArr = [videoMainMVC]()
    var videosRelatedArr = [videoMainMVC]()
    var videosFollowingArr = [videoMainMVC]()
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
    
    var items = [URL]()
    var startPoint = 0
    var videoEmpty = false
    
    var seconds = 60
    var timer = Timer()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        //        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        profileHomeVideoCollectionView.delegate = self
        profileHomeVideoCollectionView.dataSource = self
       
    
        
        setupAudio()
        self.startMonitoringInternet()
        
       
       
        devicesChecks()
        tapGesturesFunc()
        
        self.getDataForFeeds()
        
        //        loaderView.type = .ballTrianglePath
        //        loaderView.backgroundColor = .clear
        //        loaderView.color = #colorLiteral(red: 1, green: 0.5223166943, blue: 0, alpha: 1)
        
        if #available(iOS 10.0, *) {
            profileHomeVideoCollectionView.refreshControl = refresher
        } else {
            profileHomeVideoCollectionView.addSubview(refresher)
        }
        
    }
    
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        if let flowLayout = profileHomeVideoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.itemSize = CGSize(width: profileHomeVideoCollectionView.frame.width, height: profileHomeVideoCollectionView.frame.height)
//            self.profileHomeVideoCollectionView.reloadData()
//        }
//
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
                        let videoObj = videoMainMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc ?? "", videoURL: videoURL ?? "", videoTHUM: "\(thum ?? "")", videoGIF: "", view: "", section: "", sound_id: "\(sound_id ?? "")", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn ?? "", duetVideoID: "\(duetVidID!)", views: "\(views ?? "")", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: uid ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath  ?? "", role: "", username: userName  ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified!)", followersCount: "\(followers_count ?? "")", soundName: "\(soundName!)")
                        self.videosFollowingArr.append(videoObj)
                    }
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    
                    
                    
                    
                    //                    self.videosMainArr = self.videosFollowingArr
                    self.videosMainArr.append(contentsOf: self.videosFollowingArr)
                    
                    //                    self.loaderView.stopAnimating()
                    self.profileHomeVideoCollectionView.reloadData()
                    print("response@200: ",response!)
                }else{
                    //                    self.loaderView.stopAnimating()
                    
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
        
        navigationController?.popViewController(animated: true)
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
    
    //    @objc func commentButtonPressed(){
    //        let myViewController = CommentViewController(nibName: "CommentViewController", bundle: nil)
    //        myViewController.modalPresentationStyle = .fullScreen
    //        self.present(myViewController, animated: true, completion: nil)
    //
    //    }
    @objc func pauseSongNoti(notification: Notification) {
        if (notification.userInfo?["err"] as? String) != nil {
            print("reloadVid Details Noti")
            
        }else{
            let visiblePaths = self.profileHomeVideoCollectionView.indexPathsForVisibleItems
            for i in visiblePaths  {
                let cell = profileHomeVideoCollectionView.cellForItem(at: i) as? ProfileHomeScreenCollectionViewCell
                cell?.pause()
                
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //self.tabBarController!.tabBar.backgroundColor = UIColor(named: "black")
        setNeedsStatusBarAppearanceUpdate()
        
       // self.navigationController?.isNavigationBarHidden =  true
        
       

        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        
        check()
        hideShowObj()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let visiblePaths = self.profileHomeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = profileHomeVideoCollectionView.cellForItem(at: i) as? ProfileHomeScreenCollectionViewCell
            cell?.pause()
            
        }
    }
    func hideShowObj(){
        let cell1 = profileHomeVideoCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))as? ProfileHomeScreenCollectionViewCell
        if userVideoArr.isEmpty == false
        {
            //            cell?.paidStackVie.isHidden = false
            //            cell?.voteStack.isHidden = false
            btnBack.isHidden = false
            
            //            self.tabBarController?.tabBar.isHidden = false
            
            
            //            btnLiveUser.isHidden = true
        }
        else if discoverVideoArr.isEmpty == false
        {
            
            btnBack.isHidden = false
            
            //            self.tabBarController?.tabBar.isHidden = false
            
            
        }
        else
        {
            
            
            
            
            btnBack.isHidden = true
        }
    }
    //    MARK:- DEVICE CHECKS
    func devicesChecks(){
        if !DeviceType.iPhoneWithHomeButton{
            
            // feedCVtopConstraint.constant = -44
        }
    }
    

    
    
    func getDataForFeeds(){
        if userVideoArr.isEmpty == false
        {
            
            videosMainArr.removeAll()
            videosMainArr = userVideoArr
            //            feedCV.moveItem(at: indexAt, to: indexAt)
            profileHomeVideoCollectionView.reloadData()
            
           
            self.profileHomeVideoCollectionView.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                print("result",result)
                self.profileHomeVideoCollectionView.isPagingEnabled = false
                self.profileHomeVideoCollectionView.scrollToItem(at:self.indexAt, at: .bottom, animated: false)
                self.profileHomeVideoCollectionView.isPagingEnabled = true

            })

            
            
          
        }
        else if discoverVideoArr.isEmpty == false
        {
            
            videosMainArr.removeAll()
            videosMainArr = discoverVideoArr
            //            feedCV.moveItem(at: indexAt, to: indexAt)
            profileHomeVideoCollectionView.reloadData()
            

            self.profileHomeVideoCollectionView.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                self.profileHomeVideoCollectionView.isPagingEnabled = false
                self.profileHomeVideoCollectionView.scrollToItem(at:self.indexAt, at: .bottom, animated: false)
                self.profileHomeVideoCollectionView.isPagingEnabled = true
            })
//
           
          
            
        }
        else
        {
            videosMainArr.removeAll()
            getAllVideos(startPoint: "\(startPoint)")
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
            print("res : ",response!)
            if isSuccess {
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    
                    if startPoint == "0"{
                        self.videosMainArr.removeAll()
                    }
                    self.videosRelatedArr.removeAll()
                    
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    
                    for dic in resMsg{
                        let videoDic = dic["Video"] as! NSDictionary
                        let userDic = dic["User"] as! NSDictionary
                        let soundDic = dic["Sound"] as! NSDictionary
                        
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
                        //                        let thum = videoDic.value(forKey: "thum")
                        
                        let userImgPath = userDic.value(forKey: "profile_pic") as? String
                        let userName = userDic.value(forKey: "username") as? String
                        let followBtn = userDic.value(forKey: "button") as? String
                        let uid = userDic.value(forKey: "id") as? String
                        let verified = userDic.value(forKey: "verified")
                        let followers_count = userDic.value(forKey: "followers_count")
                        
                        let soundName = soundDic.value(forKey: "name")
                        let thum = soundDic.value(forKey: "thum")
                        let thum1 = videoDic.value(forKey: "thum") as? String
                        let promote = videoDic.value(forKey: "promote")
                        let videoObj = videoMainMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc ?? "", videoURL: videoURL ?? "", videoTHUM: "\(thum ?? "")", videoGIF: "", view: "", section: "", sound_id: "\(sound_id ?? "")", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn ?? "", duetVideoID: "\(duetVidID!)", views: "\(views ?? "")", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: uid ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath  ?? "", role: "", username: userName  ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified!)", followersCount: "\(followers_count ?? "")", soundName: "\(soundName!)")
                        self.videosRelatedArr.append(videoObj)
                    }
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    
                    //                    self.videosMainArr = self.videosRelatedArr
                    self.videosMainArr.append(contentsOf: self.videosRelatedArr)
                    //                    self.loaderView.stopAnimating()
                    self.videoEmpty = false
                    self.profileHomeVideoCollectionView.reloadData()
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
                    self.ccuser_id = videoDic.value(forKey: "user_id") as! String
                  //  let repost_count = videoDic.value(forKey: "repost_count")
                    
                    let cell = self.profileHomeVideoCollectionView.cellForItem(at: ip) as? ProfileHomeScreenCollectionViewCell
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
                             cell?.btnAdd.isHidden = false
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
                    let thum1 = videoDic.value(forKey: "thum") as? String
                    
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
                    
                    let cell = self.profileHomeVideoCollectionView.cellForItem(at: ip) as? ProfileHomeScreenCollectionViewCell
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
        
        let singleTapGR = UITapGestureRecognizer(target: self, action: #selector(ProfileHomeScreenViewController.handleSingleTap(_:)))
        singleTapGR.delegate = self
        singleTapGR.numberOfTapsRequired = 1
        view.addGestureRecognizer(singleTapGR)
        
        let doubleTapGR = UITapGestureRecognizer(target: self, action: #selector(ProfileHomeScreenViewController.handleDoubleTap(_:)))
        doubleTapGR.delegate = self
        doubleTapGR.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGR)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ProfileHomeScreenViewController.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.delegate = self
        view.addGestureRecognizer(longPressRecognizer)
        
    }
    
}

extension ProfileHomeScreenViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videosMainArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileHomeScreenCollectionViewCell", for: indexPath) as! ProfileHomeScreenCollectionViewCell
        
        
        if indexPath.row == 0 {

            profileHomeVideoCollectionView.contentInsetAdjustmentBehavior = .never
        }else {
            profileHomeVideoCollectionView.contentInsetAdjustmentBehavior = .scrollableAxes
        }
        
        
        if indexPath.row == videosMainArr.count - 1 {
            profileHomeVideoCollectionView.contentInsetAdjustmentBehavior = .never
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
        //        let videoTHUM = AppUtility?.detectURL(ipString: vidObj.videoTHUM)
        
        
        if vidObj.followBtn == "follow" {
            //            cell.btnFollow.setTitle("UnFollow", for: .normal)
            cell.btnAdd.isHidden = false
        }else{
            cell.btnAdd.isHidden = true
            //            cell.btnFollow.setTitle("Follow", for: .normal)
        }
        
        print("vidString url: ",vidString)
        
        let vidURL = URL(string: vidString!)
        self.items.append(vidURL!)
        
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
        let repostCount = Int("\(vidObj.repostCount)")?.roundedWithAbbreviations // vidObj.repostCount
        self.name = vidObj.username
        let followersCount = "\(vidObj.followersCount)"
        let getUserLevel = AppUtility?.getUserLevel(CounyValue: followersCount)
        
        
        if vidObj.verified == "0"{
            cell.verifiedUserImg.isHidden = true
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
        cell.lblCommentCount.text = commentCount
        cell.lblLikeCount.text = likeCount
        
        cell.userName.text = "\(userName)"
        cell.musicName.text = soundName
        cell.musicName.type = .continuousReverse
        
        let contentSize = cell.txtDesc.sizeThatFits(CGSize(width: cell.txtDesc.frame.width, height: CGFloat.greatestFiniteMagnitude))
        let paddingHeight = cell.txtDesc.textContainerInset.top + cell.txtDesc.textContainerInset.bottom + cell.txtDesc.contentInset.top + cell.txtDesc.contentInset.bottom + cell.txtDesc.layoutMargins.top + cell.txtDesc.layoutMargins.bottom
        
        let requiredHeight = contentSize.height + paddingHeight
        print("Exact height of UITextView is: \(requiredHeight)")
        
        cell.bottomViewHeight.constant = 100
        
        cell.bottomViewHeight.constant += requiredHeight - 90
        
        
        // add shedow on lable text
        cell.userName.textDropShadow()
        cell.musicName.textDropShadow()
        cell.saveLabel.textDropShadow()
        
        cell.shareLabel.textDropShadow()
        cell.lblCommentCount.textDropShadow()
        cell.lblLikeCount.textDropShadow()
        
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
        
       
        
        
        let gestureBtnHashtag = UITapGestureRecognizer(target: self, action:  #selector(self.hashtagButtonPressed(sender:)))
        cell.btnHashtag.tag = indexPath.row
        cell.btnHashtag.isUserInteractionEnabled = true
        cell.btnHashtag.addGestureRecognizer(gestureBtnHashtag)
        
        
        cell.btnSave.tag = indexPath.row
        cell.btnSave.addTarget(self, action: #selector(SaveVideoFunc(sender:)), for: .touchUpInside)
        
        
        
        return cell
    }
    
  
    
    @objc func SaveVideoFunc(sender: UIButton){
        let buttonTag = sender.tag
        self.getVideoDownloadURL()
    }
    
    
    @objc func hashtagButtonPressed(sender: UITapGestureRecognizer){
        let cell = self.profileHomeVideoCollectionView.cellForItem(at: IndexPath(row: sender.view!.tag, section: 0)) as? ProfileHomeScreenCollectionViewCell
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
        
        let cell = self.profileHomeVideoCollectionView.cellForItem(at: IndexPath(row: sender.view!.tag, section: 0)) as? ProfileHomeScreenCollectionViewCell
        
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
        vc.isProfile = true
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
                    
                    let cell = self.profileHomeVideoCollectionView.cellForItem(at: IndexPath(item: cellNo, section: 0)) as? ProfileHomeScreenCollectionViewCell
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
extension ProfileHomeScreenViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ProfileHomeScreenCollectionViewCell {
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
        checkPreload()
        checkPlay()
    }
    
    func checkPreload() {
        guard let lastRow = profileHomeVideoCollectionView.indexPathsForVisibleItems.last?.row else { return }
        
        let urls = items
            .suffix(from: min(lastRow + 1, items.count))
            .prefix(2)
        
        print("itrems url: ",urls)
        VideoPreloadManager.shared.set(waiting: Array(urls))
        
        //        VideoPlayer.preloadByteCount = 1024 * 1024 // = 1M
        
        
    }
    
    func checkPlay() {
        let visibleCells = profileHomeVideoCollectionView.visibleCells.compactMap { $0 as? ProfileHomeScreenCollectionViewCell }
        
        guard visibleCells.count > 0 else { return }
        
        let visibleFrame = CGRect(x: 0, y: profileHomeVideoCollectionView.contentOffset.y, width: profileHomeVideoCollectionView.bounds.width, height: profileHomeVideoCollectionView.bounds.height)
        
        let visibleCell = visibleCells
            .filter { visibleFrame.intersection($0.frame).height >= $0.frame.height / 2 }
            .first
        
        visibleCell?.play()
    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let frameSize = collectionView.frame.size
//                return CGSize(width: frameSize.width , height: frameSize.height)
//    }
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
        
        return CGSize(width:profileHomeVideoCollectionView.frame.width , height: profileHomeVideoCollectionView.frame.height)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        UIApplication.shared.statusBarStyle = .lightContent
        let vidObj = videosMainArr[indexPath.row]
        videoID = vidObj.videoID
        videoURL = vidObj.videoURL
        
        currentVidIP = indexPath
        
        getVideoDetails(ip: indexPath)
        self.WatchVideo(video_id: videoID)
       
        
        if let cell = cell as? ProfileHomeScreenCollectionViewCell {
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
                self.profileHomeVideoCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
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
    
//@available(iOS 13.0, *)
extension ProfileHomeScreenViewController: UIGestureRecognizerDelegate {
    @objc func handleSingleTap(_ gesture: UITapGestureRecognizer){
        print("singletapped")
        UIApplication.shared.statusBarStyle = .lightContent
        let visiblePaths = self.profileHomeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = profileHomeVideoCollectionView.cellForItem(at: i) as? ProfileHomeScreenCollectionViewCell
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
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer){
        print("doubletapped")
        let visiblePaths = self.profileHomeVideoCollectionView.indexPathsForVisibleItems
        for i in visiblePaths  {
            let cell = profileHomeVideoCollectionView.cellForItem(at: i) as? ProfileHomeScreenCollectionViewCell
            let userID = UserDefaultsManager.shared.user_id
            if userID != ""{
                if cell?.isLiked == false{
                    cell?.like()
                    self.likeVideo(uid:userID,ip: currentVidIP)
                }else{
                    cell?.unlike()
                    self.likeVideo(uid:userID,ip: currentVidIP)
                }
            }else{
                loginScreenAppear()
            }
        }
    }
    
    @objc func handleLongPress(_ gesture: UITapGestureRecognizer){
        print("long press")
        
        let visiblePaths = self.profileHomeVideoCollectionView.indexPathsForVisibleItems
        print("currentVidIP.row",currentVidIP.row)
        let videoObj = videosMainArr[currentVidIP.row]
        let rcvrID = videoObj.videoUserID
        
        //        let myViewController = AddSoundViewController(nibName: "AddSoundViewController", bundle: nil)
        //        myViewController.modalPresentationStyle = .fullScreen
        //
        //        self.navigationController?.present(myViewController, animated: true, completion: nil)
        
        let vc = VideoPopViewController(nibName: "VideoPopViewController", bundle: nil)
        vc.videoID = videoID
        vc.isProfile = true
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
        profileHomeVideoCollectionView.performBatchUpdates({
            self.profileHomeVideoCollectionView.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
            self.profileHomeVideoCollectionView.reloadItems(at: self.profileHomeVideoCollectionView.indexPathsForVisibleItems)
        })
    }
}
