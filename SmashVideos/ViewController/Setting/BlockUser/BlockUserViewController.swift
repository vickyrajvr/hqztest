//
//  BlockUserViewController.swift
//  WOOW
//
//  Created by Mac on 18/07/2022.
//

import UIKit
import SDWebImage
class BlockUserViewController: UIViewController {
    
    //MARK:- OUTLET
    
    @IBOutlet weak var blockTableView: UITableView!
    
    @IBOutlet weak var tblHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var noDataView: UIView!
    
    private lazy var loader : UIView = {
                  return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!


    }()
    //MARK:- VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blockTableView.delegate = self
        blockTableView.dataSource = self
        
        blockTableView.register(UINib(nibName: "blockUserTableViewCell", bundle: nil), forCellReuseIdentifier: "blockUserTableViewCell")
        
        showBlockedUsersApi()
        
    }
    
    //MARK:- BUTTON ACTION
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func unblockButtonPressed(sender: UIButton) {
        let index = self.userDataArr[sender.tag]
        self.blockUser(otherUserID: index.userID)
    }
    
    
    //MARK:- GET showBlockedUsers DETAILS
    var userDataArr = [userMVC]()
    func showBlockedUsersApi(){
        userDataArr.removeAll()
        self.loader.isHidden = false
        ApiHandler.sharedInstance.showBlockedUsers(user_id: UserDefaultsManager.shared.user_id) { (isSuccess, response) in
            
            if isSuccess{
                self.loader.isHidden = true
                print("response: ",response?.allValues)
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    let userObjMsg = response?.value(forKey: "msg") as! NSArray
                    
                    for userObject in userObjMsg{
                        let MsgObj = userObject as! NSDictionary
                        
                        let userObj = MsgObj.value(forKey: "BlockedUser") as! NSDictionary
                        
                        let userImage = (userObj.value(forKey: "profile_pic") as? String)
                        let userName = (userObj.value(forKey: "username") as? String)!
                        let followers = "\(userObj.value(forKey: "followers_count") ?? "")"
                        let followings = "\(userObj.value(forKey: "following_count") ?? "")"
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
                        
                        let obj = userMVC(userID: userId, first_name: firstName, last_name: lastName, gender: gender, bio: bio, website: website, dob: dob, social_id: "", userEmail: "", userPhone: "", password: "", userProfile_pic: userImage ?? "", role: "", username: userName, social: "", device_token: "", videoCount: videoCount, likesCount: likesCount, followers: followers, following: followings, followBtn: followBtn ?? "", wallet: wallet,paypal:paypal ?? "", verified: verified ?? "0")
                        
                        self.userDataArr.append(obj)
                    }
                    
                    if self.userDataArr.count == 0 {
                        self.noDataView.isHidden = false
                    }else {
                        self.noDataView.isHidden = true
                    }
                    
                    
                    
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
                    
                }
                print(self.userDataArr.count)
                self.blockTableView.reloadData()
                if self.userDataArr.count == 0 {
                    self.noDataView.isHidden = false
                }else {
                    self.noDataView.isHidden = true
                }
                //                self.tblHeightCons.constant = CGFloat(userDataArr.count * 90)
            }else{
                
                //                self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                print("showOwnDetail API:",response?.value(forKey: "msg") as Any)
            }
        }
        
    }
    
    
    func blockUser(otherUserID : String){
        self.loader.isHidden = false
        let uid = UserDefaultsManager.shared.user_id
        print("block uid: \(uid) blockUid: \(otherUserID)")
        ApiHandler.sharedInstance.blockUser(user_id: uid, block_user_id: otherUserID) { (isSuccess, response) in
            
            if isSuccess{
                self.loader.isHidden = true
                if response?.value(forKey: "code") as! NSNumber == 200 {
                    
                    //self.showToast(message: "Blocked", font: .systemFont(ofSize: 12))
                    //                    self.navigationController?.popToRootViewController(animated: true)
                    
                    
                }else{
                    
                    //                    self.showToast(message: response?.value(forKey: "msg") as! String, font: .systemFont(ofSize: 12))
                    print("blockUser API:",response?.value(forKey: "msg") as! String)
                    self.showBlockedUsersApi()
                    //                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            
        }
        
    }
}

//MARK:- EXTENSION TABLE VIEW

extension BlockUserViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.userDataArr.count)
        return userDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "blockUserTableViewCell", for: indexPath)as! blockUserTableViewCell
        
        let userObj = userDataArr[indexPath.row]
        
        let profilePic = AppUtility?.detectURL(ipString: userObj.userProfile_pic)
        let userImg = URL(string: profilePic!)
        
        
        cell.lblImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.lblImage.sd_setImage(with: userImg, placeholderImage: UIImage(named: "noUserImg"))
        cell.lblName.text = userObj.username
        
        
        cell.btnUnblock.addTarget(self, action: #selector(unblockButtonPressed(sender:)), for: .touchUpInside)
        cell.btnUnblock.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyMain = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyMain.instantiateViewController(withIdentifier: "OtherProfileViewController")as! OtherProfileViewController
        vc.hidesBottomBarWhenPushed = true
        let userObj = userDataArr[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        vc.otherUserID = userObj.userID
        vc.user_name = userObj.username
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
