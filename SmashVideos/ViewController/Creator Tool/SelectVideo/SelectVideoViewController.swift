//
//  SelectVideoViewController.swift
//  DubiDabi
//
//  Created by Mac on 21/05/2023.
//

import UIKit
import SDWebImage
class SelectVideoViewController: UIViewController {
    
    //MARK: - VARS
    
    
    
    var userVidArr = [videoMainMVC]()
    var videosMainArr = [videoMainMVC]()
    var isLoading = false
    var hasUserVideos = false
    var startPoint = 0
    
    var videoID = ""
    var audience = ""
    var goal = ""
    var budgeCoin = ""
    var Durationdays = ""
    var img = ""
    var videoViews = ""
    
    
    var actionButton = ""
    var websiteUrl = ""
    
    
    //MARK: - OUTLET
    
    @IBOutlet weak var whoopsView: UIView!
    
    @IBOutlet weak var lblWhoops: UILabel!
    @IBOutlet weak var selectVideoCollectionView: UICollectionView!
    
    
    @IBOutlet weak var btnNext: UIButton!
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        print("goal",goal)
        print("days",budgeCoin)
        
        print("totalPrice",Durationdays)
        
        print("audience",audience)
        print("videoViews",videoViews)
        
        
        
        self.getUserVideos(startPoint: "\(startPoint)")
        selectVideoCollectionView.delegate = self
        selectVideoCollectionView.dataSource = self
        
        selectVideoCollectionView.register(UINib(nibName: "SelectVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SelectVideoCollectionViewCell")
        
    }

    
    //MARK: - FUNCTION
    

    func getUserVideos(startPoint: String){
        
        if hasUserVideos == false {
            self.userVidArr.removeAll()
            self.videosMainArr.removeAll()
        }
        
       
        
        //        AppUtility?.startLoader(view: self.view)
        ApiHandler.sharedInstance.showVideosAgainstUserID(user_id: UserDefaultsManager.shared.user_id, starting_point: startPoint) { (isSuccess, response) in
            if isSuccess{
                
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
                        let talent_verified = userObj.value(forKey: "talent_verified")
                        
                        let soundID = soundObj.value(forKey: "id") as? String
                        let soundName = soundObj.value(forKey: "name") as? String
                        
                        let repost_count = videoObj.value(forKey: "repost_count")
                        let followers_count = userObj.value(forKey: "followers_count")
                        
                        let thum1 = videoObj.value(forKey: "thum") as! String
                        let video = videoMainMVC(videoID: videoID, videoUserID: "", fb_id: "", description: videoDesc, videoURL: videoUrl, videoTHUM: "\(thum ?? "")", videoGIF: videoGif, view: views, section: "", sound_id: "\(soundID ?? "")", privacy_type: "", allow_comments: allowComment, allow_duet: allowDuet, block: "", duet_video_id: "", old_video_id: "", created: created, like: like, favourite: "", comment_count: videoComments, like_count: videoLikes, followBtn: "", duetVideoID: "\(duetVidID!)", views: "\(views )", repostCount: "\(repost_count ?? "")",promote: "\(promote ?? "")", videoThum: thum1, userID: userID, first_name: "", last_name: "", gender: "", bio: "", website: "", dob: "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImg, role: "", username: username, social: "", device_token: "", videoCount: "", verified: "\(verified ?? "")", followersCount: "\(followers_count ?? "")", soundName: "\(soundName ?? "")")
                        
                        
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
                
                
//                let height = self.videosCV.collectionViewLayout.collectionViewContentSize.height + 30
//                self.uperViewHeightConst.constant = height
//                print("height: ",height)
//                //        self.heightOfLikedCVconst.constant =  CGFloat(200 * arrImage.count/3)
//                self.view.layoutIfNeeded()
                
                self.selectVideoCollectionView.reloadData()
                
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showVideosAgainstUserID API:",response?.value(forKey: "msg") as Any)
            }
        }
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
    
    //MARK: - BUTTON ACTION
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
        if self.videoID == "" && self.img == ""{
            self.showToast(message: "Must select any video", font: .systemFont(ofSize: 12.0))
        }else{
            let myViewController = TotalResultViewController(nibName: "TotalResultViewController", bundle: nil)
            
            myViewController.audience = audience
            myViewController.goal = goal
            myViewController.budgeCoin = budgeCoin
            myViewController.Durationdays = Durationdays
            myViewController.img = img
            myViewController.videoID = videoID
            myViewController.videoViews  = videoViews
            
            myViewController.actionButton  = actionButton
            myViewController.websiteUrl  = websiteUrl
            
            self.navigationController?.pushViewController(myViewController, animated: true)
            
        }
 
       
    }
    
    
    

}


//MARK:- EXTENSION FOR COLLECTION VIEW

extension SelectVideoViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videosMainArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectVideoCollectionViewCell", for: indexPath)as! SelectVideoCollectionViewCell
        let videoObj = videosMainArr[indexPath.row]
        //            cell.imgVideoTrimer.sd_setImage(with: URL(string:videoObj.videoGIF), placeholderImage: UIImage(named: "videoPlaceholder"))
        
        let gifURL = AppUtility?.detectURL(ipString: videoObj.videoGIF)
        
        cell.imgVideoTrimer.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgVideoTrimer.sd_setImage(with: URL(string:(gifURL!)), placeholderImage: UIImage(named:"videoPlaceholder"))
        let view = Double(videoObj.view)
        let view_Count = formatPoints(num: view ?? 0.0)
        print("view_Count",view_Count)
        cell.lblViewerCount.setTitle("\(view_Count)", for: .normal)
        
        cell.imgAutomatic.tag = indexPath.row
        
        if videosMainArr.count > 10 {
            if indexPath.row == videosMainArr.count - 4{
                
                startPoint += 1
                self.getUserVideos(startPoint: "\(startPoint)")
            }else{
                
            }
        }else{
            
        }
        
       
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.selectVideoCollectionView.frame.size.width/3-1, height: 204)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = selectVideoCollectionView.cellForItem(at: indexPath)as! SelectVideoCollectionViewCell
        self.videoID = videosMainArr[indexPath.row].videoID
        self.img = videosMainArr[indexPath.row].videoThum

        self.btnNext.isUserInteractionEnabled = true
        self.btnNext.alpha = 1
        
        cell.imgAutomatic.image = UIImage(named: "red circle")
        cell.imgAutomatic.tintColor = UIColor(named: "theme")
        
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("index",indexPath.row)
        let cell = selectVideoCollectionView.cellForItem(at: indexPath)as! SelectVideoCollectionViewCell
        cell.imgAutomatic.image = UIImage(named: "gray_circle")
        cell.imgAutomatic.tintColor = .systemGray4
    
    }
    
    
}

