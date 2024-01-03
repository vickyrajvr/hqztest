//
//  VisitorLiveViewController.swift
//  SmashVideos
//
//  Created by Mac on 14/07/2023.
//

import UIKit
import FirebaseDatabase
import SDWebImage
class VisitorLiveViewController: UIViewController {

    
    //MARK: - VARS
    
    
    //MARK: - OUTLET
    @IBOutlet var visitorTableView: UITableView!
    var arrliveUser = [[String:Any]]()
    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        visitorTableView.delegate = self
        visitorTableView.dataSource = self
        visitorTableView.register(UINib(nibName: "VisitorLiveTableViewCell", bundle: nil), forCellReuseIdentifier: "VisitorLiveTableViewCell")
        
        getAllLivesUser()
    }
    
    func getAllLivesUser(){
        let JoinStreamUsers = Database.database().reference().child("LiveStreamingUsers").child(UserDefaultsManager.shared.LiveStreamingId).child("JoinStream")
        
            let reference = Database.database().reference()
//        let LiveUser = reference.child("LiveStreamingUsers")
        JoinStreamUsers.observe(.value) { [self] (snapshot) in
//                self.loader.isHidden = true
                self.arrliveUser.removeAll()
            var myUser : [String:Any]?
            
                for users in snapshot.children.allObjects as! [DataSnapshot] {
                    print(users.value)
                    var user = users.value as? [String : Any]
                    if user?["userId"] as? String == UserDefaultsManager.shared.user_id {
                        myUser = user! //s.value as! [String:Any] //self.arrliveUser.append
                    }else {
                        self.arrliveUser.append(users.value as! [String:Any])
                    }
                    

                    
                }
            if myUser == nil {
                return
            }
            self.arrliveUser.append(myUser!)
            self.arrliveUser = self.arrliveUser.reversed()
            
            print("helooo ",self.arrliveUser[0]["userId"] as? String)
            print("heloo01 " , self.arrliveUser[0]["userName"] as? String)
            
            self.visitorTableView.reloadData()
            
//                if self.arrliveUser.count == 0 {
//                    self.liveUserCollectionView.isHidden =  true
//                    self.lblLive.isHidden = false
//                }else{
//                    self.liveUserCollectionView.isHidden =  false
//                    self.lblLive.isHidden = true
//                }

            }

        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.view {
            dismiss(animated: true, completion: nil)
            
        }
    }
  
   
    
    
    



}


//MARK: EXTENSION TABLE VIEW

extension VisitorLiveViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrliveUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorLiveTableViewCell", for: indexPath)as! VisitorLiveTableViewCell
        
       
        
        if indexPath.row == 0 {
            cell.lblVisitor.text = "Host"
        }else {
            cell.lblVisitor.text = "Visitor"
        }
        cell.lblUsername.text =  self.arrliveUser[indexPath.row]["userName"] as? String
        let CoverImgURL =  self.arrliveUser[indexPath.row]["userPicture"] as? String
        print(CoverImgURL)
        cell.imgProfile.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.imgProfile.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: CoverImgURL ?? ""))!), placeholderImage: UIImage(named: "noUserImg"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
