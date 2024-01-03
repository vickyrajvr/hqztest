//
//  hashtagsVideoViewController.swift
//  WOOW
//
//  Created by Zubair Ahmed on 23/06/2022.
//
import UIKit
import SDWebImage

class hashtagsVideoViewController: UIViewController {
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
        
        
    }()
    @IBOutlet weak var videosCV: UICollectionView!
    @IBOutlet var hashtagTitle: [UILabel]!
    @IBOutlet weak var videosCount : UILabel!
    @IBOutlet weak var btnFav : UIImageView!
    
    @IBOutlet weak var lblFavor: UILabel!
    @IBOutlet weak var btnAddFav : UIButton!
    
    @IBOutlet weak var tblConstr: NSLayoutConstraint!
    
    @IBOutlet weak var favouriteView: UIView!
    
    var hashtagVideosArr = [videoMainMVC]()
    var hashtagData = [String:Any]()
    var hashtag = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        videosCV.delegate = self
        //        videosCV.dataSource = self
        favouriteView.layer.borderColor = UIColor.lightGray.cgColor
        favouriteView.layer.borderWidth = 0.5
        favouriteView.layer.cornerRadius = 2
        self.addXib()
        for title in hashtagTitle{
            title.text = "#\(hashtag)"
        }
        getHashtagDataAPI(hashtag: hashtag)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController!.tabBar.backgroundColor = UIColor.appColor(.black)
        setNeedsStatusBarAppearanceUpdate()
        
        
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
        
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = videosCV.collectionViewLayout.collectionViewContentSize.height
        tblConstr.constant = height
        self.view.layoutIfNeeded()
    }
    
    func addXib(){
        videosCV.delegate = self
        videosCV.dataSource = self
        videosCV.register(UINib(nibName: "VideosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideosCollectionViewCell")
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnFav(_ sender: Any) {
        
        //        if self.hashtagData["favourite"] as! NSNumber == 0{
        //            self.btnFav.image = #imageLiteral(resourceName: "btnFavFilled")
        //        }
        
        self.addFavHashAPI()
    }
    
    //    MARK:- API
    func getHashtagDataAPI(hashtag:String){
        
        //showToast(message: "Loading Videos...", font: .systemFont(ofSize: 12.0))
        var userID = UserDefaultsManager.shared.user_id
        
        if userID == "" || userID == nil{
            userID = ""
        }
        
        self.loader.isHidden = false
        
        ApiHandler.sharedInstance.showVideosAgainstHashtag(user_id: userID, hashtag: hashtag) { (isSuccess, response) in
            
            
            
            if isSuccess{
                self.loader.isHidden = true
                let code = response?.value(forKey: "code") as! NSNumber
                
                if code == 200{
                    let msgArr = response?.value(forKey: "msg") as! NSArray
                    
                    for msgObj in msgArr{
                        
                        
                        let videosData = msgObj as! NSDictionary
                        
                        self.hashtagData = videosData.value(forKey: "Hashtag") as! [String : Any]
                        
                        let videoObj = videosData.value(forKey: "Video") as! NSDictionary
                        let userObj = videoObj.value(forKey: "User") as! NSDictionary
                        let soundObj = videoObj.value(forKey: "Sound") as? AnyObject
                        
                        let videoUrl = videoObj.value(forKey: "video") as! String
                        let thum = soundObj?.value(forKey: "thum")
                        let promote = videoObj.value(forKey: "promote")
                        let videoGif = videoObj.value(forKey: "gif") as! String
                        let videoLikes = "\(videoObj.value(forKey: "like_count") ?? "")"
                        let videoComments = "\(videoObj.value(forKey: "comment_count") ?? "")"
                        let views = videoObj.value(forKey: "view") as! String
                        let repost_count = videoObj.value(forKey: "repost_count")
                        let like = "\(videoObj.value(forKey: "like") ?? "")"
                        let allowComment = videoObj.value(forKey: "allow_comments") as! String
                        let videoID = videoObj.value(forKey: "id") as! String
                        let videoDesc = videoObj.value(forKey: "description") as! String
                        let allowDuet = videoObj.value(forKey: "allow_duet") as! String
                        let created = videoObj.value(forKey: "created") as! String
                        let duetVidID = videoObj.value(forKey: "duet_video_id")
                        
                        let userID = userObj.value(forKey: "id") as? String
                        let username = userObj.value(forKey: "username") as? String
                        let userOnline = userObj.value(forKey: "online") as? String
                        let userImg = userObj.value(forKey: "profile_pic") as? String
                        //                        let followBtn = userObj.value(forKey: "button") as! String
                        let verified = userObj.value(forKey: "verified")
                        let followers_count = userObj.value(forKey: "followers_count")
                        //                            let soundID = soundObj.value(forKey: "id") as? String
                        //                            let soundName = soundObj.value(forKey: "name") as? String
                        
                        let thum1 = videoObj.value(forKey: "thum") as? String
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: "\(thum ?? "")", videoGIF: videoGif, view: views, section: "", sound_id: "", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", views: "\(views )", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: userID ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: "", role: "", username: username ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", followersCount: "\(followers_count  ?? "")", soundName: "")
                        
                        self.hashtagVideosArr.append(video)
                        
                        print("videoLikes: ",videoLikes)
                    }
                    
                    self.videosCount.text = "\(self.hashtagVideosArr.count) views"
                    
                    //                    if sound_fav == true {
                    //                        self.imgFavourite.image = UIImage(named: "hashpressed")
                    //                        self.btnFavourite.setTitle("Remove Favorite", for: .normal)
                    //                    }else {
                    //                        self.imgFavourite.image = UIImage(named: "hashtag")
                    //                        self.btnFavourite.setTitle("Add to Favorites", for: .normal)
                    //                    }
                    
                    if self.hashtagData["favourite"] as! NSNumber == 0{
                        self.btnFav.image =  UIImage(named: "hashtag")
                        self.lblFavor.text = "Add to Favorites"
                        
                    }else{
                        self.btnFav.image = UIImage(named: "hashpressed")
                        self.lblFavor.text = "Added to Favorites"
                    }
                    self.videosCV.reloadData()
                }
            }
            
        }
        
    }
    
    func addFavHashAPI(){
        let uid = UserDefaultsManager.shared.user_id
        guard uid != nil && uid != "" else {
            loginScreenAppear()
            return
        }
        
        self.loader.isHidden = false
        
        ApiHandler.sharedInstance.addHashtagFavourite(user_id: uid, hashtag_id: self.hashtagData["id"] as! String) { (isSuccess, response) in
            
            
            if isSuccess{
                self.loader.isHidden = true
                let code = response?.value(forKey: "code") as! NSNumber
                
                if code == 200{
                    
                    if response?.value(forKey: "msg") as? String == "unfavourite"{
                        self.btnFav.image = UIImage(named: "hashtag")
                        self.lblFavor.text = "Add to Favorites"
                        //self.showToast(message: "UnFavorite", font: .systemFont(ofSize: 12))
                        return
                    }
                    
                    //self.showToast(message: "Added to FAVORITE", font: .systemFont(ofSize: 12))
                    self.btnFav.image = UIImage(named: "hashpressed")
                    
                    self.lblFavor.text = "Added to Favorites"
                    
                }else{
                    //self.showToast(message: "Something went wront try again", font: .systemFont(ofSize: 12))
                }
            }
            
        }
        
    }
    
    //    MARK:- Login screen will appear func
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
        //        let navController = UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "newLoginVC"))
        //        navController.navigationBar.isHidden = true
        //        navController.modalPresentationStyle = .overFullScreen
        //
        //        self.present(navController, animated: true, completion: nil)
    }
    
}
extension hashtagsVideoViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashtagVideosArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let vidCell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideosCollectionViewCell", for: indexPath) as! VideosCollectionViewCell
        
        let vidObj = hashtagVideosArr[indexPath.row]
        //            let vidImg = baseUrl+vidObj.userProfile_pic
        
        let userImg = AppUtility?.detectURL(ipString: vidObj.userProfile_pic)
        
        vidCell.vidImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        vidCell.vidImg.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: vidObj.videoGIF))!), placeholderImage: UIImage(named: "videoPlaceholder"))
        
        let likeCount = Int("\(vidObj.like_count)")?.roundedWithAbbreviations //vidObj.like_count
        let views = Int("\(vidObj.views)")?.roundedWithAbbreviations //vvidObj.views //
        
        //        let likeCount = vidObj.like_count
        //        let views = vidObj.views
        
        vidCell.videoCount.text = views
        vidCell.lblHeartCount.text = likeCount
        
        //        cell.lblLikeCount.text = likeCount
        //        cell.lblVideoCount.text = views
        
        print(vidObj.videoGIF)
        //            let gifURL : String = (AppUtility?.detectURL(ipString: vidObj.videoGIF))!
        //            let imageURL = UIImage.gifImageWithURL(gifURL)
        //            vidCell.vidImg.image = imageURL
        
        //            vidCell.userImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        //            vidCell.userImg.sd_setImage(with: URL(string: userImg!), placeholderImage: UIImage(named: "noUserImg"))
        //
        //            vidCell.usernameLbl.text = vidObj.username
        //            vidCell.nameLbl.text = vidObj.first_name+" "+vidObj.last_name
        //            vidCell.likeCountLbl.text = vidObj.like_count
        //  vidCell.descLbl.text = vidObj.view
        
        return vidCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((videosCV.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if let rootViewController = UIApplication.topViewController() {
        //            let storyMain = UIStoryboard(name: "Main", bundle: nil)
        let storyMain = UIStoryboard(name: "Main", bundle: nil)
        let vc =  storyMain.instantiateViewController(withIdentifier: "ProfileHomeScreenViewController") as! ProfileHomeScreenViewController
        vc.discoverVideoArr = self.hashtagVideosArr
        vc.indexAt = indexPath
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        //        }
    }
    
}
