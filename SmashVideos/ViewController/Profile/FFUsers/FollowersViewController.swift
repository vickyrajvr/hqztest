//
//  FollowersViewController.swift
//  Infotex
//
//  Created by Mac on 31/05/2021.
//


import UIKit
//import SDWebImage

class FollowersViewController: UIViewController {

    //MARK:- Outlets

    @IBOutlet weak var tblFollowers: UITableView!
    var myUSer:[User]?{didSet{}}
    var followersArr = [FollowerListMVC]()
    
    @IBOutlet weak var whoopView: UIView!
    let spinner = UIActivityIndicatorView(style: .white)
    var pageNumber = 0
    var totalPages = 1
    var isDataLoading:Bool = false
   
    var reciverId = ""
    
    
    
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

    //MARK:- ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        tblFollowers.delegate = self
        tblFollowers.dataSource = self
        self.tblFollowers.refreshControl =  refresher
        self.pageNumber = 0
        self.getFollowersAPI(FollowTitle: "Followers", numberOfPages: "0")

        //TableView footer spinner

        spinner.color = UIColor(named: "theme")
        spinner.hidesWhenStopped = true
        tblFollowers.tableFooterView = spinner
    }
    override func viewWillAppear(_ animated: Bool) {
        self.myUSer = User.readUserFromArchive()
    }


    //MARK: -  Functions Section
    @objc func requestData() {
        refreshLoader = true
        isScroll = false
        self.totalPages = 1
        self.pageNumber = 0
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.pageNumber = 0
            self.getFollowersAPI(FollowTitle: "Followers", numberOfPages: "0")
            refreshLoader = false
            self.refresher.endRefreshing()
        }
    }

    
    @objc func followUser(sender: UIButton) {
        
        let uid = UserDefaultsManager.shared.user_id
        let indexPath = IndexPath(row:sender.tag, section:0)
        let cell = self.tblFollowers.cellForRow(at:indexPath) as! ffsTVC
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
    
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
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
    
    @objc func removeFollower(sender: UIButton) {

//        let apiData = self.arrFollowers[sender.tag]
//        reciverId = apiData["id"] as! String
//
//        // Create Alert
//        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this Follower?", preferredStyle: .alert)
//
//        // Create OK button with action handler
//        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
//            print("Yes button tapped")
//            self.deleteFollowerApi(followerId: self.reciverId, tag: sender.tag)
//        })
//
//        // Create Cancel button with action handlder
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//            print("Cancel button tapped")
//        }
//
//        //Add OK and Cancel button to an Alert object
//        dialogMessage.addAction(ok)
//        dialogMessage.addAction(cancel)
//
//        // Present alert message to user
//        self.present(dialogMessage, animated: true, completion: nil)

    }

    //MARK:- API Handler

    
    func getFollowersAPI(FollowTitle : String , numberOfPages: String){
        //self.isLoading = true
        
        if refreshLoader == false{
            self.loader.isHidden = false
        }
        
      
        
        ApiHandler.sharedInstance.showFollowing(Followers: FollowTitle, user_id: UserDefaultsManager.shared.user_id, other_user_id: otherUser_id,starting_point: numberOfPages) { (isSuccess, response) in
    
            if isSuccess{
                
              
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.isLoading = false
//                }

                
        
                if self.isScroll == false {
                    
                    self.followersArr.removeAll()
                }else {
                   
                }

                let code = response?.value(forKey: "code") as! NSNumber
                
                if code == 200{
                    let msgArr = response?.value(forKey: "msg") as! NSArray
                    for objMsg in msgArr{
                        let dict = objMsg as! NSDictionary
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
                            
                            
                            print("Following list ")
                        
                    }
                    print("self.followersArr.count ",self.followersArr.count)
                    if followers_total_count ?? 0 > 10 {
                        self.totalPages = self.totalPages + 1
                        self.isScroll = true
                    }else {
                        self.isScroll = false
                    }
                    
                  
                    refreshLoader =  false
                    self.tblFollowers.reloadData()
                    self.loader.isHidden = true
                }else{
                    self.spinner.stopAnimating()
                    self.loader.isHidden = true
                    print("!200: ",response as Any)
                    if  self.pageNumber == 0 {
                        self.whoopView.isHidden = false
                    }else {
                        
                    }
                }
            }
        }

    }


    func deleteFollowerApi(followerId:String,tag:Int) {
//        ApiHandler.sharedInstance.deleteFollower(user_id: UserDefaultsManager.shared.user_id, follower_id: followerId) { (isSuccess, resp) in
//            if isSuccess {
//                print(resp)
//                let indexPath = IndexPath(row:tag, section:0)
//                let cell = self.tblFollowers.cellForRow(at:indexPath) as! ffsTVC
//
//                if resp?.value(forKey: "code") as! NSNumber == 200{
//                    if resp?.value(forKey: "msg") as? String == "deleted"{
//                        //                        self.tblFollowers.deleteRows(at: [indexPath], with: .fade)
//                        self.arrFollowers.removeAll()
//
//                        self.pageNumber = 0
//                        self.getFollowersApi(numberOfPages: "\(self.pageNumber)")
//                    }
//                }else{
//
//                }
//
//            }else{
//                print(resp)
//            }
//        }
    }

}
extension FollowersViewController: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ffsTVC") as! ffsTVC
      

        let obj = followersArr[indexPath.row]

        cell.btnFollow.setTitle("\(obj.followBtn as! String)", for: .normal)
        
        if obj.followBtn == "0"{
            cell.btnFollow.setTitle("Friends", for: .normal)
        }
        
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
            cell.followersStackView.isHidden = true
        }
        cell.btnFollow.tag = indexPath.row
        cell.btnFollow.addTarget(self, action: #selector(followUser(sender:)), for: .touchUpInside)

       if isOtherUserVisit == true{
            cell.dotStackView.isHidden =  true
        }else{
            cell.dotStackView.isHidden =  true
        }

        cell.btnBell.tag = indexPath.row
        cell.btnBell.addTarget(self, action: #selector(removeFollower(sender:)), for: .touchUpInside)

        cell.lblTitle.text = obj.username as? String
        cell.lblDescription.text = "\(obj.first_name as! String)" + " \(obj.last_name as! String)"
        if obj.username as? String == "this user does not exist" {
            cell.followersStackView.isHidden = true
        }else {
            cell.followersStackView.isHidden = false
        }
        let url = obj.userProfile_pic as! String

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
extension FollowersViewController {
    //MARK: ScrollView Delegate

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        print("scrollViewWillBeginDragging")
        self.spinner.stopAnimating()
        isDataLoading = false
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        print("scrollViewDidEndDragging")
        if scrollView == self.tblFollowers{
            if ((tblFollowers.contentOffset.y + tblFollowers.frame.size.height) >= tblFollowers.contentSize.height)
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
                            self.getFollowersAPI(FollowTitle: "Followers", numberOfPages: "\(pageNumber)")
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
