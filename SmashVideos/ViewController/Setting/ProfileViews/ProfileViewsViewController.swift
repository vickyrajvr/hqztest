//
//  ProfileViewsViewController.swift
//  SmashVideos
//
//  Created by Mac on 25/01/2023.
//

import UIKit
import SDWebImage
class ProfileViewsViewController: UIViewController {
    
    //MARK: - VARS
    
    private lazy var loader : UIView = {
        return (AppUtility?.createActivityIndicator((UIApplication.shared.windows.filter {$0.isKeyWindow}.first)!))!
    }()
    
    
    var profileViewArr = [Visitor]()
    var btn_tag: Int?
    var isScroll  = false
    var pageNumber =  0
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(named: "theme")
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)

        return refreshControl
    }()
    
    //MARK: - OUTLET
    
    
    @IBOutlet weak var profileViewsTableView: UITableView!
    
    
    @IBOutlet weak var whoopView: UIView!
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewsTableView.delegate = self
        profileViewsTableView.dataSource = self
        profileViewsTableView.sectionFooterHeight = 0
        profileViewsTableView.register(UINib(nibName: "ProfileViewsTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileViewsTableViewCell")
        self.profileViewsTableView.refreshControl =  refresher
        self.showProfileVisitors(starting_point: "0")
        
        
        
    }
    
    //MARK: - FUNCTION
    
    @objc func requestData() {
        isScroll = false
        self.pageNumber = 0
        let deadline = DispatchTime.now() + .milliseconds(700)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.showProfileVisitors(starting_point:"\(self.pageNumber)")
            self.refresher.endRefreshing()
        }
    }
    
    
    func showProfileVisitors(starting_point: String){
        
        if self.isScroll == false {
            
            self.loader.isHidden = false
        }else {
            
        }
        
        
        
        ApiHandler.sharedInstance.showProfileVisitors(user_id: UserDefaultsManager.shared.user_id, starting_point: starting_point) { (isSuccess, response) in
            if isSuccess{
                self.loader.isHidden = true
                
                
                if self.isScroll == false {
                    
                    self.profileViewArr.removeAll()
                }else {
                    
                }
                let code = response?.value(forKey: "code") as! NSNumber
                if code == 200{
                    
                    let msgArr = response?.value(forKey: "msg") as! NSArray
                    
                    print("msgArr",msgArr)
                    
                    for objMsg in msgArr{
                        let dict = objMsg as! NSDictionary
                        let visitorDict = dict.value(forKey: "Visitor") as! NSDictionary
                        let userId = (visitorDict.value(forKey: "id") as? String)
                        let userImage = (visitorDict.value(forKey: "profile_pic") as? String)
                        let userImage1 = (visitorDict.value(forKey: "profile_pic_small") as? String)
                        let firstName = (visitorDict.value(forKey: "first_name") as? String)
                        let lastName = (visitorDict.value(forKey: "last_name") as? String)
                        let gender = (visitorDict.value(forKey: "gender") as? String)
                        let bio = (visitorDict.value(forKey: "bio") as? String)
                        let dob = (visitorDict.value(forKey: "dob") as? String)
                        let website = (visitorDict.value(forKey: "website") as? String)
                        let email = (visitorDict.value(forKey: "email") as? String)
                        let username = (visitorDict.value(forKey: "username") as? String)
                        let phone = (visitorDict.value(forKey: "phone") as? String)
                        let followBtn = (visitorDict.value(forKey: "button") as? String)
                        let role = (visitorDict.value(forKey: "role") as? String)
                        let profileview = (visitorDict.value(forKey: "profile_view") as? String)
                        let userPrivate = (visitorDict.value(forKey: "user_Private") as? String)
                        let verified = (visitorDict.value(forKey: "verified") as? String)
                        
                        let obj = Visitor(id: userId ?? "", firstName: firstName ?? "", lastName: lastName ?? "", gender: gender ?? "", bio: bio ?? "", website: website ?? "", dob: dob ?? "", email: email ?? "", phone: phone ?? "", profilePic: userImage ?? "", profile_pic_small: userImage1 ?? "", role: role ?? "", username: username ?? "", verified: verified ?? "", userPrivate: userPrivate ?? "", profileView: profileview ?? "", button: followBtn ?? "")
                        
                        self.profileViewArr.append(obj)
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    if self.profileViewArr.count == 0 {
                        self.whoopView.isHidden = false
                    }else {
                        self.whoopView.isHidden = true
                    }
                    self.profileViewsTableView.sectionFooterHeight = 50
                    self.profileViewsTableView.reloadData()
                    self.loader.isHidden = true
                    
                }else{
                
                    if self.profileViewArr.count == 0 {
                        self.whoopView.isHidden = false
                    }else {
                        self.whoopView.isHidden = true
                    }
                    self.profileViewsTableView.sectionFooterHeight = 0
                    self.loader.isHidden = true
                    print("!200: ",response as Any)
                    
                }
            }
        }
        
        
    }
    
    //MARK: - ACTION
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //
    //    @IBAction func followMessaButtonPressed(_ sender: UIButton) {
    //        if btn_tag == 0 {
    //            followUser(rcvrID: self.otherUserID, userID: UserDefaultsManager.shared.user_id)
    //        }else if btn_tag == 1 {
    //            print("Go to Message screen")
    //            let vc = storyboard?.instantiateViewController(withIdentifier: "newChatVC") as! newChatViewController
    //            vc.receiverData = userData
    //            vc.otherVisiting = true
    //            vc.hidesBottomBarWhenPushed = true
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //
    //
    //    }
    
    
}


//MARK:- EXTENSION TABLE VIEW

extension ProfileViewsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profileViewArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileViewsTableViewCell", for: indexPath)as! ProfileViewsTableViewCell
        let obj = profileViewArr[indexPath.row]
        print("obj",obj)
        
        let firstName = obj.firstName
        let lastName = obj.lastName
        let userna = obj.username
        let followBtn = obj.button
        
        if firstName == "" || lastName == "" {
            cell.lblProfileUsername.text = obj.username
        }else {
            cell.lblProfileUsername.text = firstName + lastName
        }
        
        if userna == "" {
            cell.btnFollow.isHidden = true
            cell.lblProfileUsername.text = "this user does not exist"
            
        }
        
        
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProfile.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: obj.profilePic ?? ""))!), placeholderImage: UIImage(named:"noUserImg"))
        
        if followBtn == "following" || followBtn == "friends" {
            
            cell.btnFollow.setTitle("Message", for: .normal)
            cell.btnFollow.setTitleColor(UIColor.black, for: .normal)
            cell.btnFollow.backgroundColor = UIColor.white
            cell.btnFollow.layer.borderWidth = 1
            cell.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
            cell.btnFollow.layer.cornerRadius = 2
            self.btn_tag = 1
        }else {
            cell.btnFollow.setTitle("Follow", for: .normal)
            cell.btnFollow.setTitleColor(UIColor.white, for: .normal)
            cell.btnFollow.backgroundColor = UIColor(named: "theme")!
            self.btn_tag = 0
        }
        print("indexPath.row",indexPath.row)
        print("indexPath.row",self.profileViewArr.count - 1)
        if indexPath.row == self.profileViewArr.count - 1 {
            self.isScroll = true
            pageNumber = pageNumber + 1
            self.showProfileVisitors(starting_point:"\(pageNumber)")
            
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.lightGray
        } else {
            label.textColor = UIColor.lightGray
        }
        label.sizeToFit()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        footerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -15).isActive = true
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        label.text = "People who viewed your profile in the past 30 days will appear here. Only you can see this."
        
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
