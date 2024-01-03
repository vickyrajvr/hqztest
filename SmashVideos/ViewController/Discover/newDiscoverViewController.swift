//
//  newDiscoverViewController.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 26/10/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class newDiscoverViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    //MARK:-VARS
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator(self.view))!
    }()
    
    
    var timer = Timer()
    var counter = 0
    var isSelc = false
    var index = 0
    var isloading = false
    
    
    //MARK:- Outlets
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    @IBOutlet weak var discoverBannerCollectionView: UICollectionView!
    @IBOutlet weak var discoverTblView: UITableView!
    
    @IBOutlet weak var shimmerView: UIView!
    
    @IBOutlet var tblheight: NSLayoutConstraint!
    @IBOutlet weak var bannerPageController: UIPageControl!
    
    var startPoint = 0
    var hashtagDataArr = [[String:Any]]()
    
    var sliderArr = [sliderMVC]()
    //    var videosArr = [videoMainMVC]()
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoverBannerCollectionView.delegate = self
        discoverBannerCollectionView.dataSource = self
        self.scrollViewOutlet.delegate = self
        discoverTblView.delegate = self
        discoverTblView.dataSource = self
        
        self.loader.isHidden = false
        
        bannerPageController.tintColor = .white
        view.bringSubviewToFront(self.bannerPageController)
        
        getSliderData()
        getVideosData(startPoint: "\(startPoint)")
        self.setupView()
        
        
    }
    
    
    
    
    
    
    
//    @objc func hashtagButtonPressed(sender:UIButton){
//        let cell = discoverTblView.cellForRow(at: IndexPath(item: sender.tag, section: 0))as! newDiscoverTableViewCell
//        if (isSelc == true){
//
//            cell.btnHashtag.setImage(UIImage(named: "ic_my_un_favourite"), for: .normal)
//            isSelc = false
//        }else {
//            isSelc = true
//            cell.btnHashtag.setImage(UIImage(named: "ic_my_favourite"), for: .normal)
//
//        }
//    }
    
    @objc
    func requestData() {
        print("requesting data")
        
        self.hashtagDataArr.removeAll()
        self.sliderArr.removeAll()
        self.startPoint = 0
        self.isloading = false
        getVideosData(startPoint: "\(self.startPoint)")
        getSliderData()
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController!.tabBar.backgroundColor = UIColor(named: "black")
        setNeedsStatusBarAppearanceUpdate()


        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .darkContent
        
        if #available(iOS 10.0, *) {
            scrollViewOutlet.refreshControl = refresher
        } else {
            scrollViewOutlet.addSubview(refresher)
        }
        
    }
    
    //    @objc func slidetoNext() {
    //
    //        if counter < sliderArr.count {
    //
    //            let index = IndexPath(index: counter)
    //            print("index",index)
    //            print("counter",counter)
    //            self.discoverBannerCollectionView.scrollToItem(at: index, at: .left, animated: true)
    //            bannerPageController.currentPage = counter
    //            counter += 1
    //
    //        }else {
    //            counter = 0
    //            let index = IndexPath.init(item: counter, section: 0)
    //            self.discoverBannerCollectionView.scrollToItem(at: index, at: .left, animated: false)
    //            bannerPageController.currentPage = counter
    //            counter = 1
    //
    //        }
    //
    //    }
    //
    //MARK:- SetupView
    
    func setupView(){
        tblheight.constant = CGFloat(hashtagDataArr.count * 190)
        
    }
    
    //MARK: TableView
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
          self.bannerPageController.currentPage = Int(self.discoverBannerCollectionView.contentOffset.x) / Int(self.discoverBannerCollectionView.frame.width)
        
        if scrollView == self.scrollViewOutlet {
            let contentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            if maximumOffset - contentOffset <= 20 {
                //                   print("gggggggg")
                //                if indexrow == 0 {
                if self.loader.isHidden == false {
                    print("111111111")
                    startPoint = startPoint + 1
                    self.getVideosData(startPoint: "\(startPoint)")
                }else {
                    
                }
                
                //                }
                
                //                if indexrow == 2 {
                //                    if hasLikedVideos == true && isLoading == false {
                //                        print("222")
                //                        LikedVideoStartPoint = LikedVideoStartPoint + 1
                //                        self.getLikedVideos(startPoint: "\(LikedVideoStartPoint)")
                //                    }else {
                //
                //                    }
                //
                //                }
                
                //                   if ((!self.isLoading) && (isHasMore)) {
                //                       findRideHistoryOfCustomerAPI()
                //                   }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hashtagDataArr.count: ",hashtagDataArr.count)
        return hashtagDataArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("hashtagNamesArr.count: ",hashtagDataArr.count)
        let cell =  tableView.dequeueReusableCell(withIdentifier: "newDiscoverTVC") as! newDiscoverTableViewCell
        
        
        let hashObj = hashtagDataArr[indexPath.row]
        let hashName = hashObj["hashName"] as! String
        let videos_count = hashObj["videos_count"] as! String
        
        cell.hashName.text = hashName
        cell.hashNameSub.text = "Trending Hashtags"
        cell.index = indexPath.row
//        cell.btnHashtag.addTarget(self, action: #selector(hashtagButtonPressed(sender:)), for: .touchUpInside)
      //  cell.btnHashtag.tag = indexPath.row
        cell.lblVideoCount.text = videos_count
        cell.videosObj = hashObj["videosObj"] as! [videoMainMVC]
        cell.hashtagDataArr = self.hashtagDataArr
        cell.hashTagIndexPath = indexPath
        index = indexPath.row
        
        cell.discoverCollectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let vc = hashtagsVideoViewController(nibName: "hashtagsVideoViewController", bundle: nil)
                vc.hashtag = hashtagDataArr[indexPath.row]["hashName"] as! String
               // vc.totalVideo = hashtagDataArr[indexPath.row]["videos_count"] as! String
        
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderArr.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "newDiscoverBannerCVC", for: indexPath) as! newDiscoverBannerCollectionViewCell
        
        let obj = sliderArr[indexPath.row]
        let sliderUrl = AppUtility?.detectURL(ipString: obj.img)
        
        cell.img.sd_setImage(with: URL(string:sliderUrl!), placeholderImage: UIImage(named:"bannerPlaceholder"))
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.discoverBannerCollectionView.frame.size.width, height: 192)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("hashtagNamesArr.coun: ",hashtagDataArr[indexPath.row])
        
        if collectionView == discoverBannerCollectionView{
            let obj = sliderArr[indexPath.row]
            let sliderUrl = obj.url
            guard let url = URL(string: sliderUrl) else { return }
            UIApplication.shared.open(url)
        }
        
    }
    
    //    MARK:- SEARCH BTN ACTION
    
    @IBAction func searchBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "discoverSearchVC") as! discoverSearchViewController
        //        let transition = CATransition()
        //        transition.duration = 0.5
        //        transition.type = CATransitionType.fade
        //        transition.subtype = CATransitionSubtype.fromLeft
        //        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        //        view.window!.layer.add(transition, forKey: kCATransition)
        vc.modalPresentationStyle = .overFullScreen
        //        present(vc, animated: false, completion: nil)
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: false)
        //        present(vc, animated: false, completion: nil)
    }
   
    
    //    MARK:- VIDEOS DATA API
    func getSliderData(){
        
        sliderArr.removeAll()
        ApiHandler.sharedInstance.showAppSlider{ (isSuccess, response) in
            if isSuccess{
                print("response: ",response?.allValues as Any)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    let sliderDataArr = response?.value(forKey: "msg") as! NSArray
                    
                    for i in 0..<sliderDataArr.count{
                        let sliderObj = sliderDataArr[i] as! NSDictionary
                        let appSlider = sliderObj.value(forKey: "AppSlider") as! NSDictionary
                        
                        let id = appSlider.value(forKey: "id") as! String
                        let img = appSlider.value(forKey: "image") as! String
                        let url = appSlider.value(forKey: "url") as! String
                        
                        let obj = sliderMVC(id: id, img: img, url: url)
                        
                        self.sliderArr.append(obj)
                    }
                }
                
                self.discoverBannerCollectionView.reloadData()
                self.bannerPageController.numberOfPages = self.sliderArr.count
                
            }
        }
    }
    
    
    //    MARK:- VIDEOS DATA API
    func getVideosData(startPoint : String){
        
        //        hashtagDataArr.removeAll()
        //        videosArr.removeAll()
        let country_id = UserDefaultsManager.shared.country_id
        let uid = UserDefaultsManager.shared.user_id
        ApiHandler.sharedInstance.showDiscoverySections(user_id: uid, country_id: country_id, starting_point: startPoint ) { (isSuccess, response) in
            self.loader.isHidden = true
            if isSuccess{
                // print("response: ",response?.allValues as Any)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let videosHashtags = response?.value(forKey: "msg") as? NSArray
                    
                    //                    videos hashtags extract
                    
                    // print("videosHashtags.count: ",videosHashtags?.count ?? 0)
                    for i in 0 ..< (videosHashtags?.count ?? 0){
                        
                        let dic = videosHashtags?[i] as! NSDictionary
                        let hashtagsDic = dic.value(forKey: "Hashtag") as! NSDictionary
                        
                        let hashName =  hashtagsDic.value(forKey: "name") as! String
                        let videos_count =  hashtagsDic.value(forKey: "videos_count") as? NSNumber
                        let views = hashtagsDic.value(forKey: "views") as! String
                        
                        let videosObj = hashtagsDic.value(forKey: "Videos") as! NSArray
                        
                        //                        extract videos data against hashtag
                        
                        var videosArr = [videoMainMVC]()
                        videosArr.removeAll()
                        
                        for j in 0 ..< videosObj.count{
                            
                            let videosData = videosObj[j] as! NSDictionary
                            
                            let videoDic = videosData.value(forKey: "Video") as! NSDictionary
                            let userObj = videoDic.value(forKey: "User") as! NSDictionary
                            let soundObj = videoDic.value(forKey: "Sound") as? NSDictionary
                            //
                            
                            //
                            //
                            let videoUrl = videoDic.value(forKey: "video") as! String
                            let videoThum = videoDic.value(forKey: "thum") as! String
                            let videoGif = videoDic.value(forKey: "gif") as! String
                            let videoLikes = "\(videoDic.value(forKey: "like_count") ?? "")"
                            let videoComments = "\(videoDic.value(forKey: "comment_count") ?? "")"
                            let like = "\(videoDic.value(forKey: "like") ?? "")"
                            let allowComment = videoDic.value(forKey: "allow_comments") as! String
                            let videoID = videoDic.value(forKey: "id") as! String
                            let videoDesc = videoDic.value(forKey: "description") as! String
                            let allowDuet = videoDic.value(forKey: "allow_duet") as! String
                            let created = videoDic.value(forKey: "created") as! String
                            let views = "\(videoDic.value(forKey: "view") ?? "")"
                            let repost_count = videoDic.value(forKey: "repost_count")
                            let duetVidID = videoDic.value(forKey: "duet_video_id")
                            
                            
                            let userID = userObj.value(forKey: "id") as? String
                            let username = userObj.value(forKey: "username") as? String
                            let userOnline = userObj.value(forKey: "online") as? String
                            let userImg = userObj.value(forKey: "profile_pic") as? String
                            let followers_count = userObj.value(forKey: "followers_count")
                            //                        let followBtn = userObj.value(forKey: "button") as! String
                            let verified = userObj.value(forKey: "verified")
                            
                            let soundID = soundObj?["id"] as? String
                            let soundName = soundObj?["name"] as? String
                            let promote = videoDic.value(forKey: "promote")
                            let thum1 = videoDic.value(forKey: "thum") as? String
                            let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: videoThum, videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)",views: "\(views )", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: "\(thum1)", userID: userID ?? "", first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg ?? "", role: "", username: username ?? "", social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", followersCount: "\(followers_count ?? "")", soundName: soundName ?? "")
                            
                            videosArr.append(video)
                            
                            //  print("videoLikes: ",videoLikes)
                        }
                        
                        self.hashtagDataArr.append(["videosObj":videosArr,"hashName":hashName,"views":views,"videos_count" : "\(videos_count ?? 0)" ])
                        //  print("hastag: ",videosHashtags?[i])
                    }
                    // AppUtility?.stopLoader(view: self.view)
                    
                    
                    
                    
                }else{
                    //self.showToast(message: "not200", font: .systemFont(ofSize: 12))
                    // AppUtility?.stopLoader(view: self.view)
                    
                    
                    
                }
                
            }
            
            
            //            self.discoverTblView.reloadData()
            self.setupView()
            self.discoverTblView.reloadData()
            
            
            
        }
        
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        
        isloading = true
    }
    
    
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    
            print("scrollViewDidEndDragging")
            if scrollView == self.scrollViewOutlet{
                if ((scrollViewOutlet.contentOffset.y + scrollViewOutlet.frame.size.height) >= scrollViewOutlet.contentSize.height)
                {
                    if isloading == true {
                        startPoint = startPoint + 1
                        self.getVideosData(startPoint: "\(startPoint)")
                        isloading = false
                    }else {

                    }
                }
            }
    
        }
}

