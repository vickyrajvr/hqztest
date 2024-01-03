//
//  ShareProfileViewController.swift
//  SmashVideos
//
//  Created by Mac on 28/10/2022.
//


import UIKit
import FBSDKShareKit
import MessageUI
import Photos
import SDWebImage
protocol BlockUserProtocol {
    func BlockUser(isBlock : Bool)
}
class ShareProfileViewController: UIViewController,MFMessageComposeViewControllerDelegate {

    //MARK:- VARS
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    let shareToArr = ["copy","wa","sms","twitter","waStatus","fb","other"]
    var profileID = ""
    var shareUrl = ""
    var objToShare = [String]()
    var block = true
   
    var featuArr = [["title":"Report","img":"flag"],
                    ["title":"Block","img":"block"],
                    ["title":"Send Message","img":"message"]]
    //    var followerUserID = ""
    var Followers = "showFollowing"
    //    var followersArr = [[String:Any]]()
    var followersArr = [FollowerListMVC]()
    
    var blockDelegate : BlockUserProtocol?
    var userData = [userMVC]()
    
    //MARK:- OUTLET
    
    @IBOutlet weak var sendStackView: UIStackView!
    
    @IBOutlet weak var featurCollectionView: UICollectionView!
    
    @IBOutlet weak var shareCollectionView: UICollectionView!
    
    @IBOutlet weak var sendToCollectionView: UICollectionView!
    
    
    @IBOutlet weak var backView: UIView!
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        featurCollectionView.delegate = self
        featurCollectionView.dataSource = self
        
        shareCollectionView.delegate = self
        shareCollectionView.dataSource = self
        
        sendToCollectionView.delegate = self
        sendToCollectionView.dataSource = self
      
        
        objToShare.removeAll()
        
        shareUrl = SHARE_PROFILE_URL + "website/profile/" + profileID
        objToShare.append(shareUrl)
        print("block",block)
        if block == false {
            featuArr = [["title":"Report","img":"flag"],
                            ["title":"Block","img":"block"],
                            ["title":"Send Message","img":"message"]]
            
        }else {
            featuArr = [["title":"Report","img":"flag"],
                            ["title":"Unblock","img":"unblock"]]
        }
       
        
        
        
        shareCollectionView.register(UINib(nibName: "ShareToCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShareToCollectionViewCell")
        featurCollectionView.register(UINib(nibName: "FeaturesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FeaturesCollectionViewCell")
        sendToCollectionView.register(UINib(nibName: "SendToCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SendToCollectionViewCell")
    }
    
    func getFollowersAPI(){
        //        self.isLoading = true
        ApiHandler.sharedInstance.showFollowing(Followers: "", user_id: UserDefaultsManager.shared.user_id, other_user_id: UserDefaultsManager.shared.user_id, starting_point: "") { (isSuccess, response) in
            
            if isSuccess{
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    //                    self.isLoading = false
                }
                
                
                
                
                let code = response?.value(forKey: "code") as! NSNumber
                if code == 200{
                    //                    self.whoopView.isHidden = true
                }else {
                    //                    self.whoopView.isHidden = false
                    //                    self.lblWhoop.text = "There is no \(self.Followers) you have so far."
                }
                
                if code == 200{
                    let msgArr = response?.value(forKey: "msg") as! NSArray
                    for objMsg in msgArr{
                        
                        let dict = objMsg as! NSDictionary
                        if let followerDict = dict.value(forKey: "FollowingList") as? NSDictionary {
                            let userId = (followerDict.value(forKey: "id") as? String)
                            let userImage = (followerDict.value(forKey: "profile_pic") as? String)
                            let userName = (followerDict.value(forKey: "username") as? String)
                            let followers = "\(followerDict.value(forKey: "followers_count") ?? "")"
                            let followings = "\(followerDict.value(forKey: "following_count") ?? "")"
                            let videoCount = "\(followerDict.value(forKey: "video_count") ?? "")"
                            let firstName = (followerDict.value(forKey: "first_name") as? String)
                            let lastName = (followerDict.value(forKey: "last_name") as? String)
                            let gender = (followerDict.value(forKey: "gender") as? String)
                            let bio = (followerDict.value(forKey: "bio") as? String)
                            let dob = (followerDict.value(forKey: "dob") as? String)
                            let website = (followerDict.value(forKey: "website") as? String)
                            let followBtn = (followerDict.value(forKey: "button") as? String)
                            let wallet = (followerDict.value(forKey: "wallet") as? String)
                            let verified = (followerDict.value(forKey: "verified") as? String)
                            
                            let obj = FollowerListMVC(userID: userId ?? "", first_name: firstName ?? "", last_name: lastName ?? "", gender: gender ?? "", bio: bio ?? "", website: website ?? "", dob: dob ?? "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage ?? "", role: "", username: userName ?? "this user does not exist", social: "", device_token: "", videoCount: videoCount, followers: followers, following: followings, followBtn: followBtn ?? "", wallet: wallet ?? "", verified: verified ?? "0")
                            
                            self.followersArr.append(obj)
                            
                            
                            print("Following list ")
                        }else {
                            let followerDict = dict.value(forKey: "FollowerList") as! NSDictionary
                            print("Followers list ")
                            let userId = (followerDict.value(forKey: "id") as? String)
                            let userImage = (followerDict.value(forKey: "profile_pic") as? String)
                            let userName = (followerDict.value(forKey: "username") as? String)
                            let followers = "\(followerDict.value(forKey: "followers_count") ?? "")"
                            let followings = "\(followerDict.value(forKey: "following_count") ?? "")"
                            let videoCount = "\(followerDict.value(forKey: "video_count") ?? "")"
                            let firstName = (followerDict.value(forKey: "first_name") as? String)
                            let lastName = (followerDict.value(forKey: "last_name") as? String)
                            let gender = (followerDict.value(forKey: "gender") as? String)
                            let bio = (followerDict.value(forKey: "bio") as? String)
                            let dob = (followerDict.value(forKey: "dob") as? String)
                            let website = (followerDict.value(forKey: "website") as? String)
                            let followBtn = (followerDict.value(forKey: "button") as? String)
                            let wallet = (followerDict.value(forKey: "wallet") as? String)
                            let verified = (followerDict.value(forKey: "verified") as? String)
                            
                            let obj = FollowerListMVC(userID: userId ?? "", first_name: firstName ?? "", last_name: lastName ?? "", gender: gender ?? "", bio: bio ?? "", website: website ?? "", dob: dob ?? "", social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage ?? "", role: "", username : userName ?? "this user does not exist", social: "", device_token: "", videoCount: videoCount, followers: followers, following: followings, followBtn: followBtn ?? "", wallet: wallet ?? "", verified: verified ?? "0")
                            
                            self.followersArr.append(obj)
                            
                        }
                    }
                    if self.followersArr.count == 0 {
                        self.sendStackView.isHidden = true
                    }else {
                        self.sendStackView.isHidden = true
                    }
                    self.sendToCollectionView.reloadData()
                }else{
                    print("!200: ",response as Any)
                }
            }
        }
        
        
        
        
    }
    
    func blockUser(){
        self.loader.isHidden = false
        let uid = UserDefaultsManager.shared.user_id
        print("block uid: \(uid) blockUid: \(profileID)")
        ApiHandler.sharedInstance.blockUser(user_id: uid, block_user_id: profileID) { (isSuccess, response) in
            
            if isSuccess{
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    self.blockDelegate?.BlockUser(isBlock: true)
                    self.dismiss(animated: false, completion: nil)
                    
                    
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    self.blockDelegate?.BlockUser(isBlock: false)
                    print("blockUser API:",response?.value(forKey: "msg") as! String)
                    self.dismiss(animated: false, completion: nil)
                }
            }
            
        }
        
    }
    
    
    @objc func btnProfilePressed(sender : UITapGestureRecognizer){
        let obj = followersArr[sender.view?.tag ?? 0]
        print("obj user id : ",obj.userID)
        print("sender.view?.tag",sender.view?.tag)
        let otherUserID = obj.userID
        let userID = UserDefaultsManager.shared.user_id // UserDefaults.standard.string(forKey: "userID")
        //        sendMsgNoti()
        ApiHandler.sharedInstance.sendMessageNotification(senderID: UserDefaultsManager.shared.user_id, receiverID: otherUserID, msg: "Send an Video...", title: "senderName",video_id : self.profileID) { (isSuccess, response) in
            if isSuccess{
                if response?.value(forKey: "code") as! NSNumber == 200{
                    let msg = response!["msg"] as! String
                    print("msg noti sent: ",msg)
                    self.showToast(message: msg, font: .systemFont(ofSize: 12))
                    //                    self.txtMessage.text = "Send Message..."
                    //                    self.txtMessage.textColor = UIColor.lightGray
                    
                }else{
                    print("!200: ",response as Any)
                    //                    self.txtMessage.text = "Send Message..."
                    //                    self.txtMessage.textColor = UIColor.lightGray
                }
                
                
            }
        }
    }
    
    
 
    
    //MARK:- FUNCTION
    func copyLink(){
        
        
        UIPasteboard.general.string = self.shareUrl
        if UIPasteboard.general.string != nil {
            //            alertModule(title: "Copy", msg: "Url Copied to Pasteboard")
           
            showToast(message: "URL Copied", font: .systemFont(ofSize: 12))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true, completion: nil)
            }
            
        }

        
    }
    
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    func alertModule(title:String,msg:String){
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.destructive, handler: {(alert : UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func shareOnWhatsapp(){
        
         let msg = self.shareUrl
         let urlWhats = "whatsapp://send?text=\(shareUrl)"
         if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
               if let whatsappURL = NSURL(string: urlString) {
                     if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                          UIApplication.shared.open(whatsappURL as URL)
                      }
                      else {
                          print("please install watsapp")
                           alertModule(title: "Whatsapp", msg: "Please install Whatsapp")
                      }
               }
         }
        
       
    }
    
    
    
    func shareOnSMS(){
        
        let msg = self.shareUrl
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = msg
            //                controller.recipients = [phoneNumberTextField.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
        print("SMS SENT")
    }
    
    func shareOnTwitter(){
        let tweetText = "MUSICTOK APP\n"
        let tweetUrl = self.shareUrl
        
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(tweetUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        let url = URL(string: escapedShareString)
        
        // open in safari
        //        UIApplication.shared.openURL(url!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
    }
    
  
    func shareTextOnFaceBook() {
        let shareContent = ShareLinkContent()
        //        shareContent.contentURL = URL.init(string: "https://developers.facebook.com")!
        shareContent.contentURL = URL.init(string: self.shareUrl)!//your link
        shareContent.quote = "MUSICTOK APP"
        
        ShareDialog(viewController: self, content: shareContent, delegate: self as? SharingDelegate).show()
    }
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent?.pageID != nil {
            print("FBShare: Success")
        }
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("FBShare: Fail")
    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("FBShare: Cancel")
    }
    
    func otherFunc(){
        let activityViewController = UIActivityViewController(activityItems: objToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.saveToCameraRoll]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK:- BUTTON ACTION
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.backView {
            dismiss(animated: false, completion: nil)
            
        }
    }

   
}

//MARK:- EXTENSION FOR COLLECTION VIEW

extension ShareProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == featurCollectionView {
            return featuArr.count
        }else if collectionView == shareCollectionView{
            return shareToArr.count
        }else {
            return followersArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == featurCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturesCollectionViewCell", for: indexPath)as! FeaturesCollectionViewCell
            cell.imgFeature.image = UIImage(named: featuArr[indexPath.row]["img"]!)
            cell.lblFeature.text = featuArr[indexPath.row]["title"]!
            return cell
        }else if collectionView == shareCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShareToCollectionViewCell", for: indexPath)as! ShareToCollectionViewCell
            cell.imgShareto.image = UIImage(named: shareToArr[indexPath.row])
            return cell
        }else {
            let cell = sendToCollectionView.dequeueReusableCell(withReuseIdentifier: "SendToCollectionViewCell", for: indexPath)as! SendToCollectionViewCell
            
            //            @IBOutlet weak var imgProfile: CustomImageView!
            //            @IBOutlet weak var lblProfile: UILabel!
            //
            
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.height / 2
            cell.imgProfile.clipsToBounds = true
            
            let followObj = followersArr[indexPath.row]
            let userImgPath = AppUtility?.detectURL(ipString: followObj.userProfile_pic)
            cell.lblProfile.text = followObj.username
            cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgProfile.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: userImgPath!))!), placeholderImage: UIImage(named:"noUserImg"))
            //            cell.lblName.text = followObj.first_name + " " + followObj.last_name
            //            cell.btnFollow.setTitle(followObj.followBtn.capitalized, for: .normal)
            //
            //            if followObj.followBtn == "0"{
            //                cell.btnFollow.setTitle("Friends", for: .normal)
            //            }
            
            //            if followObj.followBtn == "Following" || followObj.followBtn == "Friends" || followObj.followBtn == "0"  {
            //                cell.btnFollow.backgroundColor = UIColor.appColor(.borderColor)
            //                cell.btnFollow.setTitleColor(UIColor.appColor(.black), for: .normal)
            //                cell.btnFollow.layer.borderColor = UIColor(named: "darkgray")?.cgColor
            //                cell.btnFollow.layer.borderWidth = 1
            //
            //            }else {
            //                cell.btnFollow.backgroundColor = UIColor.appColor(.maincolor)
            //                cell.btnFollow.setTitleColor(UIColor.appColor(.white), for: .normal)
            //            }
            
            //            cell.btnFollow.tag = indexPath.row
            //            cell.btnFollow.addTarget(self, action: #selector(btnFollowFunc(sender:)), for: .touchUpInside)
            //
            let gestureUserImg = UITapGestureRecognizer(target: self, action:  #selector(self.btnProfilePressed(sender:)))
            cell.imgProfile.tag = indexPath.row
            gestureUserImg.view?.tag = indexPath.row
            cell.imgProfile.isUserInteractionEnabled = true
            cell.imgProfile.addGestureRecognizer(gestureUserImg)
            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == featurCollectionView {
            return CGSize(width: self.featurCollectionView.frame.width / 5.1, height: 100.0)
        }else if collectionView == shareCollectionView {
            return CGSize(width: self.shareCollectionView.frame.width / 5.1, height: 80.0)
        }else {
            return CGSize(width: self.sendToCollectionView.frame.width / 5.1, height: 80.0)
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == shareCollectionView{
            switch shareToArr[indexPath.row] {
            case "copy":
                print("copy")
                copyLink()
            case "wa":
                print("Whatsapp Tapped")
                shareOnWhatsapp()
            case "sms":
                shareOnSMS()
                print("sms Tapped")
            case "twitter":
                print("twitter Tapped")
                shareOnTwitter()
            case "waStatus":
                print("waStatus Tapped")
                shareOnWhatsapp()
            case "fb":
                print("fb Tapped")
                shareTextOnFaceBook()
            case "other":
                print("other Tapped")
                otherFunc()
            default:
                print("DEFAULT")
            }
        }else if collectionView == sendToCollectionView {
            
        }else {
            
            switch indexPath.row {
            case 0:
                print("report")
                
                    let myViewController = ReportDetailViewController(nibName: "ReportDetailViewController", bundle: nil)
                    myViewController.modalPresentationStyle = .overFullScreen
                    myViewController.otherUserID = self.profileID
                    self.present(myViewController, animated: true, completion: nil)
                
                
            case 1:
                blockUser()


            case 2:

                if UserDefaultsManager.shared.user_id == "" {
                    self.loginScreenAppear()
                }else {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
                    vc.receiverData = userData
                    vc.otherVisiting = true
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            default:
                print("default")
            }
            
        }
    }
    
    
}
