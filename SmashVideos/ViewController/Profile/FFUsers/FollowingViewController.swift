//
//  FollowingViewController.swift
//  Infotex
//
//  Created by Mac on 31/05/2021.
//


import UIKit
import SDWebImage

class FollowingViewController: UIViewController, UITextFieldDelegate{
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var whoopView: UIView!
    @IBOutlet weak var tblFollowing: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    
    var followersArr = [FollowerListMVC]()
    
    var myUSer:[User]?{didSet{}}
    
    var isDataLoading:Bool = false
    var isFresher = false
    var reciverId = ""
    lazy var tag = 0
    let spinner = UIActivityIndicatorView(style: .white)
    var pageNumber = 0
    var totalPages = 1
    
   
    
    
    var isScroll  = false
    
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "theme")
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        
        return refreshControl
    }()
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.myUSer = User.readUserFromArchive()
    }
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tblFollowing.delegate = self
        tblFollowing.dataSource = self
        self.tfSearch.delegate = self
        self.tblFollowing.refreshControl =  refresher
        
        self.getFollowersAPI(FollowTitle: "Following", numberOfPages: "0")
        
        
        //TableView footer spinner
        spinner.color = UIColor(named: "theme")
        spinner.hidesWhenStopped = true
        tblFollowing.tableFooterView = spinner
        
    }
    //MARK: -  Functions Section
    @objc
    func requestData() {
        refreshLoader = true
        isScroll = false
        self.totalPages = 1
        self.pageNumber = 0
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.getFollowersAPI(FollowTitle: "Following", numberOfPages: "0")
            refreshLoader = false
            self.refresher.endRefreshing()
        }
    }
    
    @objc func followUser(sender: UIButton) {
        
        let uid = UserDefaultsManager.shared.user_id
        let indexPath = IndexPath(row:sender.tag, section:0)
        let cell = self.tblFollowing.cellForRow(at:indexPath) as! ffsTVC
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
                sender.layer.borderWidth = 1.0
                sender.layer.borderColor = UIColor.systemGray5.cgColor
                sender.setTitleColor(.black, for: .normal)
                
            }
            
        }
        
    }
    
    func followUserFunc(cellNo:Int){
        let suggUser = self.followersArr[cellNo]
        
        let rcvrID = suggUser.userID as! String
        let userID = UserDefaultsManager.shared.user_id
        
        self.followRecomdedUser(rcvrID: rcvrID, userID: userID)
    }
    
    
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
    
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func notificationStatus(sender: UIButton) {
        let apiData = self.followersArr[sender.tag]
        reciverId = apiData.userID as! String
        self.tag =  sender.tag
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        vc.modalPresentationStyle = .overCurrentContext
        // vc.delagteNotification =  self
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func notificationStatus(status: String) {
        // self.followerNotifiApi(notification: status)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TFF Begin Editing")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TFF end Editing")
        //self.getSearchApi()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder()
        return true
    }
    
    //MARK:- API Handler
    
    func getFollowersAPI(FollowTitle : String , numberOfPages: String){
        
       // self.isLoading = true
        if refreshLoader == false{
            //self.loader.isHidden = false
            
        }
        
       
        
        ApiHandler.sharedInstance.showFollowing(Followers: FollowTitle, user_id: UserDefaultsManager.shared.user_id, other_user_id: otherUser_id,starting_point: numberOfPages) { (isSuccess, response) in
            
            if isSuccess{
                
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//                    self.isLoading = false
//                }
//
                if self.isScroll == false {
                    
                    self.followersArr.removeAll()
                }else {
                    
                }
                
                
                let code = response?.value(forKey: "code") as! NSNumber
               
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
                        }
                    }
                    
                    print("followersArr",self.followersArr.count)
                    
                    
                if following_total_count ?? 0 > 10 {
                    self.totalPages = self.totalPages + 1
                    self.isScroll = true
                }else {
                    self.isScroll = false
                }
                
                    refreshLoader =  false
                    self.tblFollowing.reloadData()
                    self.loader.isHidden = true
                }else{
                    self.spinner.stopAnimating()
                    print("!200: ",response as Any)
                    self.loader.isHidden = true
                   
                    if self.pageNumber == 0 {
                        
                        self.whoopView.isHidden = false
                        
                    }else {
                        
                    }
                }
            }
        }
        
    }
    
    //    func getSearchApi() {
    //        ApiHandler.sharedInstance.Search(user_id: (self.myUSer?[0].Id)!, type: "following", keyword: self.tfSearch.text ?? "", starting_point: "0") { (isSuccess, resp) in
    //            if isSuccess{
    //                let code = resp?.value(forKey: "code") as! NSNumber
    //                if code == 200{
    //                    self.arrFollowing.removeAll()
    //                    let msgArr = resp?.value(forKey: "msg") as! NSArray
    //                    for objMsg in msgArr{
    //
    //                        let dict = objMsg as! NSDictionary
    //                        let followerDict = dict.value(forKey: "FollowingList") as! [String:Any]
    //
    //
    //                        self.arrFollowing.append(followerDict)
    //                    }
    //                    self.totalPages = self.totalPages + 1
    //
    //                    refreshLoader =  false
    //                    self.tblFollowing.delegate = self
    //                    self.tblFollowing.dataSource =  self
    //                    self.tblFollowing.reloadData()
    //                }else{
    //                    refreshLoader =  false
    //                    self.totalPages = self.pageNumber
    //
    //                    self.spinner.hidesWhenStopped = true
    //                    self.spinner.stopAnimating()
    //                }
    //            }else{
    //                self.loader.isHidden = true
    //                print(resp)
    //            }
    //        }
    //    }
    //
    //    func followApi(tag:Int){
    //        ApiHandler.sharedInstance.followUser(sender_id: (self.myUSer?[0].Id)!, receiver_id: self.reciverId) { (isSucces, resp) in
    //            if isSucces {
    //                let code = resp?.value(forKey: "code") as! NSNumber
    //                if code == 200{
    //                    let msgArr = resp?.value(forKey: "msg") as! NSDictionary
    //                    let receiver = msgArr.value(forKey: "receiver") as! NSDictionary
    //                    let user =  receiver.value(forKey: "User") as! NSDictionary
    //
    //
    //
    //
    //                    let indexPath = IndexPath(row:tag, section:0)
    //                    let cell = self.tblFollowing.cellForRow(at:indexPath) as! ffsTVC
    //
    //
    //                    if user["button"] as! String == "following" {
    //                        cell.contWidthBtnFollow.constant = 63
    //                        cell.btnFollow.setBackgroundImage(UIImage(named: "gradiant_back"), for: .normal)
    //                        cell.btnFollow.layer.borderColor = UIColor.clear.cgColor
    //                        cell.btnFollow.setTitle("Friends", for: .normal)
    //                    }else if user["button"] as! String == "follow"{
    //                        cell.contWidthBtnFollow.constant = 63
    //                        cell.btnFollow.setTitle("Follow", for: .normal)
    //                        cell.btnFollow.setBackgroundImage(nil, for: .normal)
    //                        cell.btnFollow.layer.borderWidth = 1
    //                        cell.btnFollow.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    //                    }else{
    //                        cell.contWidthBtnFollow.constant = 73
    //                        cell.btnFollow.setBackgroundImage(UIImage(named: "gradiant_back"), for: .normal)
    //                        cell.btnFollow.layer.borderColor = UIColor.clear.cgColor
    //                        cell.btnFollow.setTitle("Following", for: .normal)
    //                    }
    //
    //                }
    //
    //            }else{
    //                print(resp)
    //            }
    //        }
    //    }
    //
    
    //    func followerNotifiApi(notification:String)  {
    //        ApiHandler.sharedInstance.followerNotification(sender_id: (self.myUSer?[0].Id)!, receiver_id: self.reciverId, notification: notification) { (isSuccess, resp) in
    //            if isSuccess {
    //                let code = resp?.value(forKey: "code") as! NSNumber
    //                if code == 200{
    //                    let indexPath = IndexPath(row:self.tag, section:0)
    //                    let cell = self.tblFollowing.cellForRow(at:indexPath) as! ffsTVC
    //                    if cell.btnBell.currentImage == UIImage(named:"bellIcon"){
    //                        cell.btnBell.setImage(UIImage(named:"bellMarked"), for: .normal)
    //                    }else{
    //                        cell.btnBell.setImage(UIImage(named:"bellIcon"), for: .normal)
    //                    }
    //                }
    //
    //            }
    //        }
    //    }
    
    
    
}
extension FollowingViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return followersArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ffsTVC") as! ffsTVC
        
        let obj = followersArr[indexPath.row]
        
        cell.btnFollow.setTitle("\(obj.followBtn as! String)", for: .normal)
        
        if obj.followBtn as! String == "Following" {
            cell.btnFollow.setTitle("Following", for: .normal)
            cell.btnFollow.backgroundColor = .white
            cell.btnFollow.layer.borderWidth = 1.0
            cell.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
            cell.btnFollow.setTitleColor(.black, for: .normal)
        }else if obj.followBtn as! String == "Follow"{
            
            cell.btnFollow.setTitle("Follow", for: .normal)
            cell.btnFollow.backgroundColor = UIColor(named: "theme")
            cell.btnFollow.setTitleColor(UIColor(named: "theme"), for: .normal)
            cell.btnFollow.setTitleColor(.white, for: .normal)
            
        }else {
            cell.btnFollow.backgroundColor = .white
            cell.btnFollow.layer.borderWidth = 1.0
            cell.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
            cell.btnFollow.setTitleColor(.black, for: .normal)
            cell.followingStackView.isHidden = true
        }
        
        
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(followUser(sender:)), for: .touchUpInside)
        
        cell.btnBell.tag = indexPath.row
        cell.btnBell.addTarget(self, action: #selector(notificationStatus(sender:)), for: .touchUpInside)
        if isOtherUserVisit == true{
            cell.bellStackView.isHidden = true
        }else{
            cell.bellStackView.isHidden = true
        }
        
        
        cell.btnBell.setImage(UIImage(named: "bellIcon"), for: .normal)
        cell.lblTitle.text = obj.username as? String
        if obj.username as? String == "this user does not exist" {
            cell.followingStackView.isHidden = true
        }else {
            cell.followingStackView.isHidden = false
        }
        cell.lblDescription.text = "\(obj.first_name as! String)" + " \(obj.last_name as! String)"
        
        let url = obj.userProfile_pic as! String
        print(url)
        cell.imgIcon.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "noUserImg"))
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = followersArr[indexPath.row]
        if obj.username as? String == "this user does not exist" {
            
        }else {
            let storyMain = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyMain.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
            vc.hidesBottomBarWhenPushed = true
            let userObj = followersArr[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            vc.otherUserID = userObj.userID
            vc.user_name = userObj.username
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
}
extension FollowingViewController {
    //    //MARK: ScrollView Delegate
    //
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        print("scrollViewWillBeginDragging")
        self.spinner.stopAnimating()
        isDataLoading = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    //
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        print("scrollViewDidEndDragging")
        if scrollView == self.tblFollowing{
            if ((tblFollowing.contentOffset.y + tblFollowing.frame.size.height) >= tblFollowing.contentSize.height)
            {
                if self.isScroll == false {
                    
                }else {
                    if !isDataLoading{
                        isDataLoading = true
                        print("Next page call")
                        if self.pageNumber < self.totalPages{
                            self.pageNumber = self.pageNumber + 1
                            refreshLoader =  true
                            spinner.startAnimating()
                            self.getFollowersAPI(FollowTitle: "Following", numberOfPages: "\(pageNumber)")
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height {
            refreshLoader =  false
            self.spinner.hidesWhenStopped = true
            self.spinner.stopAnimating()
        }
    }
}

