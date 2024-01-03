//
//  RaiseHandUsersVC.swift
//  SmashVideos
//
//  Created by Zubair Ahmed on 29/05/2023.
//

import UIKit
import SDWebImage
class RaiseHandUsersVC: UIViewController {

    @IBOutlet weak var raisehandTblVC: UITableView!
    
    // local veriables
    var liveRoomArray = [[String : Any]]()
    var roomId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        raisehandTblVC.delegate = self
        raisehandTblVC.dataSource = self
        raisehandTblVC.sectionFooterHeight = 0
        raisehandTblVC.register(UINib(nibName: "RaiseHandUserTblCell", bundle: nil), forCellReuseIdentifier: "RaiseHandUserTblCell")
        setup()
        // Do any additional setup after loading the view.
    }

    func setup() {
        
        SpacesListeners.shared.LiveRoom() { (isSuccess, message) in
            self.liveRoomArray.removeAll()
            if isSuccess == true
            {
                print(message)
                for key in message
                {
                    print(key)
                    print(key.value)
                    let key1 = key.key
                    print("key1: ", key1)
//                    self.roomId = key1
                    let value1 = key.value
//                    var arr =  [ String : Any ]()
//                    arr["key"] = key1
//                    arr["value"] = value1
                    let messages = key.value as? [String : Any] ?? [:]
                    
//                    let user = value1["Users"] as? [String : Any] ?? [:]
                    
                    if self.roomId == key1 {
                        if let obj = value1 as? NSDictionary {
//                            self.roomId = key1
                            print(obj.allKeys)
                            print(obj.value(forKey: "\(key1)"))
                            let user = obj["Users"] as?  NSDictionary // [[String : Any]]
                            print(user?.count)
                            print(user?.allKeys)
                            print(user?.allValues)
                            
                            let userKeys = user?.allKeys
                            
                            let userValues = user?.allValues
                            
                            for j in 0..<(userValues?.count ?? 0) {
                                
                                let userKey = userKeys?[j]
                                let userValues = userValues?[j]
                                
                                print("userKey",userKey ?? "")
                                print("userValues",userValues ?? "")
                                
                                var arr =  [ String : Any ]()
                                arr["key"] = userKey ?? ""
                                arr["value"] = userValues ?? ""
                                
                                let dict = userValues as? NSDictionary
                                let userModel = dict?["userModel"] as? NSDictionary
                                
                                print(userModel)
                                
                                if userModel == nil {
                                    print("user is not in active ")
                                }else {
                                    print("user is in active ")
                                    if userKey as? String == UserDefaultsManager.shared.user_id {
                                        
                                    }else {
                                        self.liveRoomArray.append(arr)
                                    }
                                    
                                }
                                
                            }
                             
                        }
                    }
//                    self.liveRoomArray.append(arr)
                    
//                    self.arrMessages.sort(by: { ("\($0["time"]!)") < ("\($1["time"]!)") })
//                    self.scrollToBottom()
                }
                print(self.liveRoomArray.count)
                self.raisehandTblVC.reloadData()
            }
        }
    }

    
    func AcceptRaisHandRoom(UserId: String) {
        SpacesListeners.shared.UpdateRaisehandUserLiveRoom(roomID: self.roomId, userid : UserId, raishand : "2") { (isSuccess) in
            if isSuccess == true
            {
                
            }
        }
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
    }
    
    // MARK: - Navigation

     @objc func micBtnAction(sender: UIButton) {
         print("Mic btn Action \(sender.tag)")
         let obj = self.liveRoomArray[sender.tag]
         let Userid = obj["key"] as? String ?? ""
         self.AcceptRaisHandRoom(UserId: Userid)
     }
     

}


//MARK:- EXTENSION TABLE VIEW

extension RaiseHandUsersVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveRoomArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RaiseHandUserTblCell", for: indexPath)as! RaiseHandUserTblCell
        let obj = self.liveRoomArray[indexPath.row]
        let dict = obj["value"] as? NSDictionary
        let usermodel = dict?["userModel"] as? NSDictionary
        let profilePic = usermodel?["profilePic"]
        let username = usermodel?["username"]
        let userImgPath = AppUtility?.detectURL(ipString: "\(profilePic)" as! String)
        let userImgUrl = URL(string: userImgPath!)
        
        cell.profileimg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.profileimg.sd_setImage(with: userImgUrl, placeholderImage: UIImage(named: "noUserImg"))
        cell.profileimg.layer.cornerRadius = cell.profileimg.frame.height / 2.0
        cell.profileimg.layer.masksToBounds = true
        
        cell.userNameLbl.text = "\(username ?? "")"
        
        cell.addMicBtn.tag = indexPath.row
        cell.addMicBtn.addTarget(self, action: #selector(micBtnAction(sender:)), for: .touchUpInside)
        
        
//        let obj = profileViewArr[indexPath.row]
//        print("obj",obj)
//
//        let firstName = obj.firstName
//        let lastName = obj.lastName
//        let userna = obj.username
//        let followBtn = obj.button
//
//        if firstName == "" || lastName == "" {
//            cell.lblProfileUsername.text = obj.username
//        }else {
//            cell.lblProfileUsername.text = firstName + lastName
//        }
//
//        if userna == "" {
//            cell.btnFollow.isHidden = true
//            cell.lblProfileUsername.text = "this user does not exist"
//
//        }
//
//
//        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.gray
//        cell.imgProfile.sd_setImage(with: URL(string:(AppUtility?.detectURL(ipString: obj.profilePic ?? ""))!), placeholderImage: UIImage(named:"noUserImg"))
//
//        if followBtn == "following" || followBtn == "friends" {
//
//            cell.btnFollow.setTitle("Message", for: .normal)
//            cell.btnFollow.setTitleColor(UIColor.black, for: .normal)
//            cell.btnFollow.backgroundColor = UIColor.white
//            cell.btnFollow.layer.borderWidth = 1
//            cell.btnFollow.layer.borderColor = UIColor.systemGray5.cgColor
//            cell.btnFollow.layer.cornerRadius = 2
//            self.btn_tag = 1
//        }else {
//            cell.btnFollow.setTitle("Follow", for: .normal)
//            cell.btnFollow.setTitleColor(UIColor.white, for: .normal)
//            cell.btnFollow.backgroundColor = UIColor(named: "theme")!
//            self.btn_tag = 0
//        }
//        print("indexPath.row",indexPath.row)
//        print("indexPath.row",self.profileViewArr.count - 1)
//        if indexPath.row == self.profileViewArr.count - 1 {
//            self.isScroll = true
//            pageNumber = pageNumber + 1
//            self.showProfileVisitors(starting_point:"\(pageNumber)")
//
//        }
//
//
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let obj = self.liveRoomArray[indexPath.row]
//        let Userid = obj["key"] as? String ?? ""
//
//        self.AcceptRaisHandRoom(UserId: Userid)
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
//        let label = UILabel()
//
//        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
//        if #available(iOS 13.0, *) {
//            label.textColor = UIColor.lightGray
//        } else {
//            label.textColor = UIColor.lightGray
//        }
//        label.sizeToFit()
//        label.numberOfLines = 0
//        label.lineBreakMode = .byWordWrapping
//        label.textAlignment = .center
//
//        footerView.addSubview(label)
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
//        label.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 15).isActive = true
//        label.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -15).isActive = true
//        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
//
//        label.text = "People who viewed your profile in the past 30 days will appear here. Only you can see this."
//
//        return footerView
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
