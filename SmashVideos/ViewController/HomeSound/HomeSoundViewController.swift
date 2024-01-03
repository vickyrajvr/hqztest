//
//  HomeSoundViewController.swift
//  WOOW
//
//  Created by Wasiq Tayyab on 14/06/2022.
//

import UIKit
import SDWebImage
import AVFoundation
class HomeSoundViewController: UIViewController,UIScrollViewDelegate {
    
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
        
        
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var imgSong: UIImageView!
    @IBOutlet weak var lblVideos: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var soundCollectionView: UICollectionView!
    @IBOutlet weak var loaderActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var imgFavourite: UIImageView!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var favourView: UIView!
    @IBOutlet weak var createView: UIView!
    @IBOutlet weak var lblFavourite: UILabel!
    
    @IBOutlet weak var soundConst: NSLayoutConstraint!
    
    var soundVideosMainArr = [videoMainMVC]()
    
    var videoDetail = [videoDetailMVC]()
    var indexAt : IndexPath!
    var currentVidIP : IndexPath!
    var isFollowing = false
    var videoID = ""
    var videoURL = ""
    var otherUserID = ""
    
    var totalVideosCount = 5
    var TotalLoadingCount = 5
    var isPageRefreshing:Bool = false
    
    
    var items = [URL]()
    var startPoint = 0
    var videoEmpty = false
    var sound_id = ""
    var soundName = ""
    var userImgUrl = ""
    var audioUrl = ""
    var sound = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addXib()
        
        favourView.layer.borderColor = UIColor.lightGray.cgColor
        favourView.layer.borderWidth = 0.5
        favourView.layer.cornerRadius = 2
        startPoint = 0
        getAllVideos(startPoint: "\(startPoint)")
        
        self.lblSongName.text = "\(soundName)"
        //        for img in userImageOutlet{
        imgSong.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imgSong.sd_setImage(with: URL(string:userImgUrl), placeholderImage: UIImage(named: "noMusicIcon"))
        //        }
        scrollView.delegate = self
        self.loaderActivity.isHidden = true
        self.btnPlay.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = soundCollectionView.collectionViewLayout.collectionViewContentSize.height
        soundConst.constant = height
        self.view.layoutIfNeeded()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController!.tabBar.backgroundColor = UIColor.appColor(.black)
        setNeedsStatusBarAppearanceUpdate()
        
        
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
        
    }
    func addXib(){
        soundCollectionView.delegate = self
        soundCollectionView.dataSource = self
        soundCollectionView.register(UINib(nibName: "HomeSoundCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeSoundCollectionViewCell")
        
    }
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if(self.soundCollectionView.contentOffset.y >= (self.soundCollectionView.contentSize.height - self.soundCollectionView.frame.size.height)) {
    //            if !isPageRefreshing {
    //                isPageRefreshing = true
    //                print(startPoint)
    //                startPoint = startPoint + 1
    //
    //                getAllVideos(startPoint: "\(startPoint)")
    //            }
    //        }
    //    }
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //
    //            if scrollView == self.scrollView {
    //                let contentOffset = scrollView.contentOffset.y
    //                let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    //                if contentOffset <= maximumOffset {
    //                    if ((!self.isPageRefreshing)){
    //                        startPoint += 1
    //                        getAllVideos(startPoint: "\(startPoint)")
    //                    }
    //                }
    //            }
    //        }
    
    
    //MARK:-API handler
    func addFavSong(soundID:String){
        self.loader.isHidden = false
        ApiHandler.sharedInstance.addSoundFavourite(user_id: UserDefaultsManager.shared.user_id, sound_id: soundID) { (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200{
                    print("msg: ",response?.value(forKey: "msg")!)
                    
                    if response?.value(forKey: "msg") as? String == "unfavourite"{
                        self.imgFavourite.image = UIImage(named: "hashtag")
                        self.lblFavourite.text = "Add to Favorites"
                        
                        return
                    }
                    
                    self.imgFavourite.image = UIImage(named: "hashpressed")
                    self.lblFavourite.text = "Added to Favorites"
                    
                }else{
                    //self.showToast(message: "!200", font: .systemFont(ofSize: 12))
                }
            }
            
        }
    }
    
    
    func getAllVideos(startPoint:String){
        var userID = UserDefaultsManager.shared.user_id
        
        if userID == "" || userID == nil{
            userID = ""
        }
        let startingPoint = startPoint
        let deviceID = UserDefaultsManager.shared.deviceID
        if sound == false {
            self.soundVideosMainArr.removeAll()
            self.loader.isHidden = false
        }else {
            
        }
        sound = true
        print("deviceid: ",deviceID)
        //  self.showToast(message: "Loading ...", font: .systemFont(ofSize: 12))
        
        ApiHandler.sharedInstance.showVideosAgainstSound(user_id: userID, sound_id:sound_id,starting_point:startPoint,device_id:deviceID) { (isSuccess, response) in
            print("res : ",response!)
            if isSuccess {
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    
                    let resMsg = response?.value(forKey: "msg") as! [[String:Any]]
                    
                    if let sound_fav = response?["sound_fav"] as? Bool {
                        if sound_fav == true {
                            self.imgFavourite.image = UIImage(named: "hashpressed")
                            self.lblFavourite.text = "Added to Favourites"
                            
                            
                        }else {
                            self.imgFavourite.image = UIImage(named: "hashtag")
                            self.lblFavourite.text = "Add to Favorites"
                            
                        }
                    }else {
                        
                    }
                    //
                    for dic in resMsg{
                        let videoDic = dic["Video"] as! NSDictionary
                        let userDic = dic["User"] as! NSDictionary
                        let soundDic = dic["Sound"] as! NSDictionary
                        
                        print("videoDic: ",videoDic)
                        print("userDic: ",userDic)
                        print("soundDic: ",soundDic)
                        
                        let videoURL = videoDic.value(forKey: "video") as? String
                        
                        let videoThum = videoDic.value(forKey: "thum") as! String
                        let videoGif = videoDic.value(forKey: "gif") as! String
                        
                        let promote = videoDic.value(forKey: "promote")
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
                        self.audioUrl = soundDic.value(forKey: "audio") as? String ?? ""
                        let videoObj = videoMainMVC(videoID: videoID, videoUserID: "\(videoUserID!)", fb_id: "", description: desc ?? "", videoURL: videoURL ?? "", videoTHUM: "\(videoThum)", videoGIF: "\(videoGif)", view: "\(views ?? "")", section: "", sound_id: "\(sound_id ?? "")", privacy_type: "", allow_comments: "\(allowComments!)", allow_duet: "\(allowDuet!)", block: "", duet_video_id: "", old_video_id: "", created: "", like: "", favourite: "", comment_count: "\(commentCount!)", like_count: "\(likeCount!)", followBtn: followBtn ?? "", duetVideoID: "\(duetVidID!)", views: "\(views ?? "")", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: uid ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImgPath  ?? "", role: "", username: userName  ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified!)", followersCount: "\(followers_count ?? "")", soundName: "\(soundName!)")
                        self.soundVideosMainArr.append(videoObj)
                    }
                    
                    //                    self.feedCV.delegate = self
                    //                    self.feedCV.dataSource = self
                    
                    //                    self.videosMainArr = self.videosRelatedArr
                    self.soundVideosMainArr.append(contentsOf: self.soundVideosMainArr)
                    //                    self.loaderView.stopAnimating()
                    self.videoEmpty = false
                    
                    self.lblVideos.text = "\(self.soundVideosMainArr.count) videos"
                    
                    
                    
                    self.soundCollectionView.reloadData()
                    print("response@200: ",response!)
                }
                else{
                    self.videoEmpty = true
                    self.lblVideos.text = "0 videos"
                }
                
            }else{
                print("response failed: ",response!)
                //self.showToast(message: (response?.value(forKey: "msg") as? String)!, font: .systemFont(ofSize: 12))
                //                self.loaderView.stopAnimating()
            }
            
            
            //            self.loaderView.stopAnimating()
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.isPlaying == true{
            self.loadAudio(audioURL: self.audioUrl)
        }
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillDisappear(_ animated : Bool) {
        if self.isPlaying == true{
            self.loadAudio(audioURL: self.audioUrl)
        }
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        
        self.loadAudio(audioURL: self.audioUrl)
        
        // self.loadAudio(audioURL: "https://d25v8ddvfjl5cf.cloudfront.net/audio/60b40ec98e475n690f.mp3")
    }
    
    var audioPlayer: AVPlayer?
    var isPlaying = false
    
    func loadAudio(audioURL: String) {
        let dictionary: Dictionary <String, AnyObject> = SpringboardData.springboardDictionary(title: "audioP", artist: "audioP Artist", duration: Int (300.0), listScreenTitle: "audioP Screen Title", imagePath:Bundle.main.path(forResource: "Spinner-1s-200px", ofType: "gif")!)
        self.btnPlay.isHidden = true
        self.loaderActivity.isHidden =  false
        self.loaderActivity.startAnimating()
        self.btnPlay.setImage(UIImage(named: "ic_pause_icon"), for: .normal)
        
        TPGAudioPlayer.sharedInstance().playPauseMediaFile(audioUrl: URL(string: audioURL)! as NSURL, springboardInfo: dictionary, startTime: 0.0, completion: {(isplaying,_ , stopTime) -> () in
            print("isplaying",isplaying)
            self.isPlaying = isplaying
            self.btnPlay.isHidden = false
            self.loaderActivity.isHidden =  true
            self.loaderActivity.stopAnimating()
            if isplaying == true {
                self.btnPlay.setImage(UIImage(named: "ic_pause_icon"), for: .normal)
            }else{
                self.btnPlay.setImage(UIImage(named: "ic_play_icon"), for: .normal)
            }
            
//            self.updatePlayButton(ip: "ip")
            print("there",stopTime)
            
            
        } )
        
        
    }
    
    func updatePlayButton() {
        
        let playPauseImage = (TPGAudioPlayer.sharedInstance().isPlaying ? UIImage(named: "ic_pause_icon") : UIImage(named: "ic_play_icon"))
        
        self.btnPlay.setImage(playPauseImage, for: .normal)
    }
    
    
    
    
    @IBAction func addToFavouriteButtonPressed(_ sender: UIButton) {
        
        let uid = UserDefaultsManager.shared.user_id
        if uid == "" {
            //  showToast(message: "Please Login..", font: .systemFont(ofSize: 12.0))
            loginScreenAppear()
        }else{
            self.addFavSong(soundID: self.sound_id)
        }
    }
    
    @IBAction func createVideoButtonPressed(_ sender: UIButton) {
    }
    
    //MARK:- Music Load
    
    
    //    MARK:- Login screen will appear func
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .automatic
        self.present(nav, animated: true, completion: nil)
    }
    func updatePlayButton(ip:IndexPath) {
        
        let cell = soundCollectionView.cellForItem(at: ip) as! HomeSoundCollectionViewCell
        
        let playPauseImage = (TPGAudioPlayer.sharedInstance().isPlaying ? UIImage(named: "ic_pause_icon") : UIImage(named: "ic_play_icon"))
        
        //        cell.btnSelect.isHidden = TPGAudioPlayer.sharedInstance().isPlaying ? false : true
        //        self.playButton.setImage(playPauseImage, for: UIControlState())
        //        cell.playImg.image = playPauseImage
    }}

//MARK:- COLLECTION VIEW
extension HomeSoundViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return soundVideosMainArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = soundCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeSoundCollectionViewCell", for: indexPath)as! HomeSoundCollectionViewCell
        let vidObj = soundVideosMainArr[indexPath.row]
        let vidString = AppUtility?.detectURL(ipString: vidObj.videoURL)
        
        print("vidString url: ",vidString)
        
        let vidURL = URL(string: vidString!)
        self.items.append(vidURL!)
        
        let gifURL : String = (AppUtility?.detectURL(ipString: vidObj.videoGIF))!
        print("gifURL url: ",gifURL)
        
        cell.img.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.img.sd_setImage(with: URL(string:(gifURL)), placeholderImage: UIImage(named:"videoPlaceholder"))
        
        let likeCount = Int("\(vidObj.like_count)")?.roundedWithAbbreviations //vidObj.like_count
        let views = Int("\(vidObj.view)")?.roundedWithAbbreviations //vvidObj.views //
        
        cell.videoCount.text = views
        
        cell.lblHeartCount.text = likeCount
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.soundCollectionView.frame.width / 3.0, height: 170)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if let rootViewController = UIApplication.topViewController() {
        //            let storyMain = UIStoryboard(name: "Main", bundle: nil)
        let storyMain = UIStoryboard(name: "Main", bundle: nil)
        let vc =  storyMain.instantiateViewController(withIdentifier: "ProfileHomeScreenViewController") as! ProfileHomeScreenViewController
        vc.discoverVideoArr = self.soundVideosMainArr
        vc.indexAt = indexPath
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
    
    
}

