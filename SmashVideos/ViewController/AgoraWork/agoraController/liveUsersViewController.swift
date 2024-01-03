////
////  liveUsersViewController.swift
////  zarathx
////
////  Created by Junaid  Kamoka on 14/12/2020.
////  Copyright © 2020 Junaid Kamoka. All rights reserved.
////
//
import UIKit
import FirebaseDatabase
import FirebaseAuth
import AgoraRtcKit
import SDWebImage

class liveUsersViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
 
    @IBOutlet weak var liveUserCollectionView: UICollectionView!
    
    let commentsArr = [commentNew]()
    
    private lazy var agoraKit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: nil)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        return engine
    }()
    
    private lazy var loader : UIView = {
       return (AppUtility?.createActivityIndicator((UIApplication.shared.keyWindow?.rootViewController?.view)!))!
    }()
 
   
    var arrliveUser = [[String:Any]]()
    var isNotification = false
    var ip = 0
    
    @IBOutlet weak var lblLive: UILabel!
    
    private var settings = Settings()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .darkContent
        self.getAllLivesUser()
        
        if arrliveUser.count == 0 {
            self.lblLive.isHidden = true
        }else {
            self.lblLive.isHidden = false
        }
       
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        if isNotification == false{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier,
            segueId.count > 0 else {
            return
        }
        
        switch segueId {
        case "usersToLive":
            let liveVC = segue.destination as? LiveRoomViewController
            
            liveVC?.isAudiance = true
            liveVC?.userImgString = self.arrliveUser[ip]["user_picture"] as!String
            liveVC?.userNameString  = self.arrliveUser[ip]["user_name"] as! String
            settings.role = .audience
            settings.roomName = self.arrliveUser[ip]["user_id"] as? String
            
            print(self.arrliveUser[ip]["id"] as? String)
            print("ip: ",ip)

            print(settings.roomName)
            liveVC?.dataSource = self
            
        default:
            break
        }
        
    }
    
    func loginScreenAppear(){
        let myViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        let nav = UINavigationController(rootViewController: myViewController)
        nav.isNavigationBarHidden =  true
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }

    
    //MARK:-Firebase
    
//    func getAllLivesUser(){
//        self.loader.isHidden = false
//        let reference = Database.database().reference()
//        let LiveUser = reference.child("LiveUsers")
//        LiveUser.observe(.value) { [self] (snapshot) in
//            self.loader.isHidden = true
//            self.arrliveUser.removeAll()
//            for users in snapshot.children.allObjects as! [DataSnapshot] {
//                print(users.value)
//                self.arrliveUser.append(users.value as! [String:Any])
//
//                self.liveUserCollectionView.reloadData()
//            }
//            if self.arrliveUser.count == 0 {
//                self.liveUserCollectionView.isHidden =  true
//                self.lblLive.isHidden = false
//            }else{
//                self.liveUserCollectionView.isHidden =  false
//                self.lblLive.isHidden = true
//            }
//
//        }
//    }
//    }
    
    func getAllLivesUser(){
            self.loader.isHidden = false
            let reference = Database.database().reference()
        let LiveUser = reference.child("LiveStreamingUsers")
            LiveUser.observe(.value) { [self] (snapshot) in
                self.loader.isHidden = true
                self.arrliveUser.removeAll()
                for users in snapshot.children.allObjects as! [DataSnapshot] {
                    print(users.value)
                    self.arrliveUser.append(users.value as! [String:Any])

                    self.liveUserCollectionView.reloadData()
                }
                if self.arrliveUser.count == 0 {
                    self.liveUserCollectionView.isHidden =  true
                    self.lblLive.isHidden = false
                }else{
                    self.liveUserCollectionView.isHidden =  false
                    self.lblLive.isHidden = true
                }

            }

        }
//    }
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrliveUser.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liverUserCVC", for: indexPath) as! liverUserCollectionViewCell
        cell.lblName.text =  self.arrliveUser[indexPath.row]["userName"] as? String
        let CoverImgURL =  self.arrliveUser[indexPath.row]["userPicture"] as? String
        print(CoverImgURL)
        cell.imgUser.sd_imageIndicator = SDWebImageActivityIndicator.white
        cell.imgUser.sd_setImage(with: URL(string: (AppUtility?.detectURL(ipString: CoverImgURL ?? ""))!), placeholderImage: UIImage(named: "videoPlaceholder"))
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userID = UserDefaultsManager.shared.user_id //UserDefaults.standard.string(forKey: "userID")
        
        if userID == nil || userID == ""{
            
            loginScreenAppear()
        }else{
//            let liveVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LiveRoomVC") as! LiveRoomViewController
            
            print(self.arrliveUser[indexPath.row])
            
            print(self.arrliveUser[indexPath.row]["userId"] as? String)
//            StaticData.singleton.liveUserID = self.arrliveUser[indexPath.row]["userId"] as? String ?? ""
//            StaticData.singleton.liveUserName = self.arrliveUser[indexPath.row]["userName"] as? String ?? ""

            
            self.ip = indexPath.row
            
//            let ob = self.arrliveUser[ip]
//            liveVC.isAudiance = true
//            liveVC.userImgString = self.arrliveUser[ip]["userPicture"] as? String ?? ""
//            liveVC.userNameString  = self.arrliveUser[ip]["userName"] as? String ?? ""
//            settings.role = .audience
            UserDefaultsManager.shared.LiveStreamingId = self.arrliveUser[ip]["streamingId"] as? String ?? ""
//            settings.roomName = self.arrliveUser[ip]["streamingId"] as? String
//
            print(self.arrliveUser[ip]["id"] as? String)
            print("ip: ",ip)

//            print(settings.roomName)
//            liveVC.dataSource = self
//            liveVC.receiver_id = self.arrliveUser[ip]["userId"] as? String ?? ""

//            liveVC.ip = self.ip
//            liveVC.arrliveUser = self.arrliveUser

//            self.navigationController?.pushViewController(liveVC, animated: true)
            
            let liveVC1 = self.storyboard?.instantiateViewController(withIdentifier: "LiveRooomVC")as! LiveRooomVC
//            liveVC1.userData = userData
            liveVC1.isAudiance = true
            settings.role = .audience
            liveVC1.arrliveUser = self.arrliveUser
//            liveVC1.LiveStreamingId = self.arrliveUser[ip]["streamingId"] as? String ?? ""
//            liveVC1.dataSource = self
            liveVC1.ip = self.ip
            self.navigationController?.pushViewController(liveVC1, animated: true)
            
            
//            let liveVC1 = self.storyboard?.instantiateViewController(withIdentifier: "_LiveRoomViewController")as! LiveRooomVC
////            liveVC1.userData = userData
//            liveVC1.isAudiance = true
//            liveVC1.LiveStreamingId = self.arrliveUser[ip]["streamingId"] as? String ?? ""
//            liveVC1.dataSource = self
//            liveVC1.ip = self.ip
//            self.navigationController?.pushViewController(liveVC1, animated: true)
            
        }
        
        
      
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let noOfCellsInRow = 3
            
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
            
            let size = Int((liveUserCollectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            
            return CGSize(width: size, height: 120)
        
    }
    
}
extension liveUsersViewController: LiveVCDataSource {
    func liveVCNeedSettings() -> Settings {
        return settings
    }
    
    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit {
        return agoraKit
    }
}

//extension liveUsersViewController: SettingsVCDelegate {
//    func settingsVC(_ vc: SettingsViewController, didSelect dimension: CGSize) {
//        settings.dimension = dimension
//    }
//
//    func settingsVC(_ vc: SettingsViewController, didSelect frameRate: AgoraVideoFrameRate) {
//        settings.frameRate = frameRate
//    }
//}
//
//extension liveUsersViewController: SettingsVCDataSource {
//    func settingsVCNeedSettings() -> Settings {
//        return settings
//    }
//}
//
